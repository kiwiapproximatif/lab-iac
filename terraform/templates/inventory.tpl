all:
  vars:
    ansible_user: ansible
    ansible_ssh_private_key_file: ~/.ssh/id_ed25519
  children:
    _master:
      hosts:
        master:
          ansible_host: ${master_ip}
    _minion:
      hosts:
        minion1:
          ansible_host: ${minion1_ip}
        minion2:
          ansible_host: ${minion2_ip}