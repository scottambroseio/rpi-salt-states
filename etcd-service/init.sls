include:
  - ..golang-install

etcd-user:
  user.present:
    - name: etcd
    - shell: /bin/bash
    - createhome: False

/var/lib/etcd:
  file.directory:
    - mode: 755
    - user: etcd
    - group: etcd
    - require:
      - user: etcd-user

/opt/etcd:
  file.directory:
    - mode: 755
    - user: etcd
    - group: etcd
    - require:
      - user: etcd-user

etcd-source:
  cmd.run:
    - name: GOPATH=/root/go /opt/go/bin/go get github.com/coreos/etcd
    - creates: /root/go/src/github.com/coreos/etcd
    - require:
      - archive: golang-extracted

etcd-checkout:
  cmd.run:
    - cwd: /root/go/src/github.com/coreos/etcd
    - name: git checkout v3.3.9
    - require:
      - cmd: etcd-source

etcd-build:
  cmd.run:
    - cwd: /root/go/src/github.com/coreos/etcd
    - name: PATH=$PATH:/opt/go/bin ./build
    - creates: /root/go/src/github.com/coreos/etcd/bin
    - require:
      - archive: golang-extracted
      - cmd: etcd-checkout

/opt/etcd/etcd:
  file.managed:
    - source: /root/go/src/github.com/coreos/etcd/bin/etcd
    - mode: 755
    - user: etcd
    - group: etcd
    - require:
      - cmd: etcd-build
      - file: /opt/etcd
      - user: etcd-user

/etc/systemd/system/etcd.service:
  file.managed:
    - source: salt://etcd-service/etcd.service
    - template: jinja
    - mode: 755
    - user: root
    - group: root
    - require:
      - user: etcd-user
      - file: /opt/etcd/etcd 
