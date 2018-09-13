/etc/ssh/sshd_config:
  file.managed:
    - source: salt://sshd_config
