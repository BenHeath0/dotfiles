# Linux Notes

Most of these notes are from my time at MITRE and dealing with ECE VMs, but i cant bring myself to delete the notes because if i do then next week I’ll need help setting up linux environments

## General Notes

### How to restart docker via CLI

```
sudo systemctl restart docker
```

### How to run an ansible playbook

```
ansible-playbook playbooks/<name_of_playbook.yml>
```

### How to set up passwordless sudo

- Need to put file in `/etc/sudoers.d/<sui>`. dont remember what content needs to be in there if any

### Passwordless SSH

For passwordless ssh: - “ssh-copy-id <VM>” - Put public RSA key from macbook into /.ssh/authorized_keys on VM - .ssh needs chmod 700 - .ssh/authorized_keys needs 600

The permissions required change by OS distro. RHEL/CENTOS requires CHMOD 600 permissions on authorized_keys, but Ubuntu doesnt care

### Add user to docker group

```
sudo usermod -aG docker $USER
```

and if you need to create the docker group

```
sudo groupadd docker
```

### Setting up VM for Bamboo Deployment

This is probably such a MITRE thing... but if i delete it then i'll need it next week

1. Create deployer account (adduser deployer)
   1. It will ask for a Kerberos password. Just spam enter its fine
2. Give passwordless sudo (bc theres no password)
3. Become user deployer (sudo su deployer)
4. Fix permissions for deployer’s .ssh directory
   1. sudo chmod 700 .ssh
   2. sudo chown deployer .ssh
   3. sudo chown -R deployer:deployer .ssh
5. Add deployer to docker group
6. Create ssh key
7. Create authorized_keys file with the same public key. Make sure permissions are good (i didnt have to do anything)
8. Put private key into bamboo
