golang-download:
  cmd.run:
    - name: wget https://dl.google.com/go/go1.11.linux-armv6l.tar.gz
    - creates: /root/go1.11.linux-armv6l.tar.gz

golang-extracted:
  archive.extracted:
    - name: /opt/
    - source: /root/go1.11.linux-armv6l.tar.gz
    - if_missing: /opt/go
    - require:
      - cmd: golang-download
