scott:
  user.present:
    - shell: /bin/bash
    - home: /home/scott
    - groups:
      - sudo
    - password: {{ pillar['scott_password'] }}
