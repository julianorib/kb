# Trivy

<https://edu.chainguard.dev/chainguard/chainguard-images/staying-secure/working-with-scanners/grype-tutorial/>

## Install
```
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.52.2
```
## Template HTML
```
git clone git@github.com:anchore/grype.git ~/.grype
```
## Execute com Report em HTML
```
trivy image --format template --template "@.trivy/contrib/html.tpl" -o report.html nginx
```

# Grype

<https://edu.chainguard.dev/chainguard/chainguard-images/staying-secure/working-with-scanners/grype-tutorial/>

## Install
```
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
```
## Template HTML
```
git clone https://github.com/aquasecurity/trivy.git ~/.trivy
```
## Execute com Report em HTML
```
grype -o template -t ~/.grype/templates/html.tmpl python:3.10.14-alpine3.20 > report.html
```