kafka-user:
  user.present:
    - name: kafka
    - shell: /bin/bash
    - createhome: False

/var/lib/kafka:
  file.directory:
    - mode: 755
    - user: kafka
    - group: kafka
    - requires:
      - user: kakfa-user

/opt/kafka_2.11-2.0.0:
  file.directory:
    - mode: 755
    - user: kafka
    - group: kafka
    - recurse:
      - user
      - group
    - require:
      - user: kafka-user
      - archive: kafka-extracted

kafka-download:
  cmd.run:
    - name: wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/kafka/2.0.0/kafka_2.11-2.0.0.tgz
    - creates: /root/kafka_2.11-2.0.0.tgz

kafka-extracted:
  archive.extracted:
    - name: /opt
    - source: /root/kafka_2.11-2.0.0.tgz
    - if_missing: /opt/kafka_2.11-2.0.0
    - require:
      - cmd: kafka-download

/opt/kafka_2.11-2.0.0/config/server.properties:
  file.managed:
    - source: salt://kafka-service/server.properties
    - template: jinja
    - mode: 755
    - user: kafka
    - group: kafka
    - require:
      - user: kafka-user
      - archive: kafka-extracted

/opt/kafka_2.11-2.0.0/bin/kafka-server-start.sh:
  file.managed:
    - source: salt://kafka-service/kafka-server-start.sh
    - mode: 755
    - user: kafka
    - group: kafka
    - require:
      - user: kafka-user
      - archive: kafka-extracted

/opt/kafka_2.11-2.0.0/bin/kafka-run-class.sh:
  file.managed:
    - source: salt://kafka-service/kafka-run-class.sh
    - mode: 755
    - user: kafka
    - group: kafka
    - require:
      - user: kafka-user
      - archive: kafka-extracted

/etc/systemd/system/kafka.service:
  file.managed:
    - source: salt://kafka-service/kafka.service
    - mode: 755
    - user: root
    - group: root
    - require:
      - user: kafka-user
      - archive: kafka-extracted
