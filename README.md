Vous devez installer les outils suivants :
- [Incus](https://linuxcontainers.org/incus/docs/main/installing/)
- [Terraform](https://developer.hashicorp.com/terraform/install#linux)
- [Ansible](https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html)

Installation du plugin `community.general` pour en partie utiliser le plugin `incus` :
```bash
ansible-galaxy collection install community.general --upgrade
```

Ajouter le dépôt `cloud-init` pour les images `incus` :
```bash
incus remote add ubuntu https://cloud-images.ubuntu.com/releases --protocol=simplestreams --public
```

Si vous utilisez WSL2, Il faut forward le réseau vers la machine hôte pour avoir accès à l'extérieur :
```bash
incus network set incusbr0 raw.dnsmasq "dhcp-option=6,8.8.8.8,1.1.1.1"
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -I FORWARD -i incusbr0 -j ACCEPT
sudo iptables -I FORWARD -o incusbr0 -j ACCEPT
sudo iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
```

Un peu bourrin mais cela fonctionne. Vive windows...

Lorsque vous exécutez un playbook ansible ne pas oublier d'utiliser l'argument `--ask-become-pass`/`-K` ou d'ajouter `incus-admin` au groupe d'administration à l'aide de cette commande :

```bash
sudo usermod -aG incus-admin $USER
```
