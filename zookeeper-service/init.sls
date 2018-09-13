zookeeper-user:
  user.present:
    - name: zookeeper
    - shell: /bin/bash
    - createhome: False

oracle-java8-jdk-package:
  pkg.installed:
    - name: oracle-java8-jdk

/var/lib/zookeeper:
  file.directory:
    - mode: 755
    - user: zookeeper
    - group: zookeeper
    - requires:
      - user: zookeeper-user

/var/lib/zookeeper/myid:
  file.managed:
    - mode: 644
    - user: zookeeper
    - group: zookeeper
    - contents_grains: zookeeper_id
    - requires:
      - user: zookeeper-user
      - file: /var/lib/zookeeper

/opt/zookeeper-3.4.12:
  file.directory:
    - mode: 755
    - user: zookeeper
    - group: zookeeper
    - recurse:
      - user
      - group
    - require:
      - user: zookeeper-user
      - archive: zookeeper-extracted

zookeeper-download:
  cmd.run:
    - name: wget http://mirror.ox.ac.uk/sites/rsync.apache.org/zookeeper/stable/zookeeper-3.4.12.tar.gz
    - creates: /root/zookeeper-3.4.12.tar.gz
    - requires:
      - pkg: oracle-java8-jdk-package

zookeeper-extracted:
  archive.extracted:
    - name: /opt/
    - source: /root/zookeeper-3.4.12.tar.gz
    - if_missing: /opt/zookeeper-3.4.12
    - require:
      - cmd: zookeeper-download

/opt/zookeeper-3.4.12/conf/zoo.cfg:
  file.managed:
    - source: salt://zookeeper-service/zoo.cfg
    - mode: 755
    - user: zookeeper
    - group: zookeeper
    - require:
      - user: zookeeper-user
      - archive: zookeeper-extracted

/etc/systemd/system/zookeeper.service:
  file.managed:
    - source: salt://zookeeper-service/zookeeper.service
    - mode: 755
    - user: root
    - group: root
    - require:
      - user: zookeeper-user
      - archive: zookeeper-extracted
