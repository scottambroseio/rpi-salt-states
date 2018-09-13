root:
  user.present:
    - password: {{ pillar['root_password'] }}
