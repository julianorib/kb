# Istio Envoy Filter

```
kubectl debug -it pod-foo --image=ubuntu --share-processes
```
apt install tcpdump
```
tcpdump -i eth0 -A port 8080
```

remoção dos headers do istio:
```
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: strip-headers-with-lua
  namespace: ingress-nginx
spec:
  workloadSelector:
    labels:
      app.kubernetes.io/name: ingress-nginx
      app.kubernetes.io/component: controller
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
    patch:
      operation: INSERT_BEFORE
      value:
        name: envoy.filters.http.lua
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.http.lua.v3.Lua
          inlineCode: |
            function envoy_on_request(handle)
              local to_remove = {
                "x-envoy-peer-metadata",
                "x-envoy-peer-metadata-id",
                "x-envoy-attempt-count",
                "x-envoy-original-dst-host",
                "x-b3-traceid",
                "x-b3-spanid",
                "x-b3-sampled"
              }
              for _, h in ipairs(to_remove) do
                handle:headers():remove(h)
              end
            end
```

deploy-foo.yaml
```
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: deploy-foo-strip-headers-lua
  namespace: ingress-nginx
spec:
  workloadSelector:
    labels:
      app.kubernetes.io/name: ingress-nginx
      app.kubernetes.io/component: controller

  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_OUTBOUND
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
            subFilter:
              name: envoy.filters.http.router
    patch:
      operation: INSERT_BEFORE
      value:
        name: envoy.filters.http.lua
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.http.lua.v3.Lua
          inlineCode: |
            local TARGET_HOSTS = {
              ["api.foo.com.br"] = true,
              ["api.foo.svc.cluster.local"] = true
            }

            local HEADERS_TO_REMOVE = {
              "x-envoy-peer-metadata",
              "x-envoy-peer-metadata-id",
              "x-envoy-attempt-count",
              "x-envoy-original-dst-host",
              "x-b3-traceid",
              "x-b3-spanid",
              "x-b3-sampled"
            }

            function envoy_on_request(handle)
              local host = handle:headers():get(":authority") or handle:headers():get("host") or ""
              if TARGET_HOSTS[host] then
                for _, h in ipairs(HEADERS_TO_REMOVE) do
                  handle:headers():remove(h)
                end
              end
            end
```


Ativar Debug log no Istio-Proxy:
```
istioctl proxy-config log podname.namespace --level debug
istioctl proxy-config log podname.namespace --level trace
```
