# Ansible Cheat Sheet

### Quick reference

CLI cheatsheet: <https://docs.ansible.com/ansible/latest/command_guide/cheatsheet.html>\
Ad-hoc: <https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html>\
Builtin Modules: <https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html>\
All Modules: <https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html>\
Conditionals: <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#conditions-based-on-registered-variables>\
Vars Facts: <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html>\
Filters: <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html>\
Boas Práticas: <https://amaurybsouza.medium.com/as-boas-pr%C3%A1ticas-do-ansible-que-ningu%C3%A9m-te-conta-e-que-n%C3%A3o-existem-no-google-4fcc3126ad1>


### Criando estrutura de pastas para Roles
```
ansible-galaxy init <roleName>
```

### Opções de linha de comando
| Opções | Descrição |
|--------|-----------|
| -i hosts.cfg        | Especificar um arquivo com o Inventário de hosts |
| grupo               | Especificar um Grupo dentro do Inventário de Hosts |
| -u root             | Especificar o usuário que utilizar no destino |
| --private keyfile   | Especificar a Chave SSH associada ao usuário |
| -m ping             | Especificar o Módulo ping |
| -m shell            | Especificar o Módulo shell  |
| -a "ls"             | Quando o módulo necessita de argumentos.  |
| -b                  | Become - Se não for usuário root, mas deve executar com Elevação (sudo) |
| -K                  | Solicitar a senha do usuário que tem permissão ao Sudo. |

### Opções Avançadas linha de comando
| Opções | Descrição |
|--------|-----------|
|  --extra-vars "variavel=valor"  | Informa o valor de uma variável na execução |
| --list-hosts | Mostra os hosts que será aplicado para conferência |
| --limit=grupo/host | Aplica o playbook somente para 1 grupo ou 1 host |
| --list-tasks | Mostra as Tasks que será aplicado para conferência |
| --check | Simulação do playbook | 
| --sintax-check | Validação da Sintaxe do playbook |
| --start-at-task="Task xpto" | Execução a partir de uma determinada Task |

### Informando um arquivo de variável na linha de comando
Serve para Playbook Simples ou Playbook com Roles.
```
ansible-playbook main.yaml --extra-vars "@fileVars.yaml"
```

### Configuração para ignorar checagem de Host.

/etc/ansible/ansible.cfg
```
[defaults]
host_key_checking=False
interpreter_python=auto_legacy_silent
```


### Example playbook: xpto.yaml
```
- name: Playbook example
  hosts: all
  become: yes
  tasks:
    - name: Task de um playbook
      ansible.builtin.debug:
        msg: "Este é uma task de um playbook {{ variavel }}"
```
### Example role: main.yaml
```
- name: Playbook with roles
  hosts: manager
  roles:
    - role1
  hosts: worker
    - role2
```
### Example task: role1/tasks/main.yaml
```
---
  - name: Executando role
    ansible.builtin.debug:
      msg: "Esta é uma role {{ variavel }}"
```

