# Devops - AWS/Terraform/Ansible

## Terraform

### Testing Env
```
$ cd terraform/testing
$ terraform init
$ terraform apply
```

### Production Env
```
$ cd terraform/production
$ terraform init
$ terraform apply
```

---

## Ansible

### Testing Env
```
$ cd ansible

$ ansible-playbook playbooks/base.yml --diff

$ ansible-playbook playbooks/web.yml --diff
```

### Production Env
```
$ cd ansible
$ export ANSIBLE_CONFIG=production.cfg

$ ansible-playbook playbooks/base.yml --diff

$ ansible-playbook playbooks/web.yml --diff
```
