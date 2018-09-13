raspberrypi-host:
  host.absent:
    - ip: 127.0.1.1
    - name: raspberrypi

rpi3a-host:
  host.present:
    - ip: 192.168.0.103
    - name: rpi3a

rpi3b-host:
  host.present:
    - ip: 192.168.0.106
    - name: rpi3b

rpi3c-host:
  host.present:
    - ip: 192.168.0.102
    - name: rpi3c

/etc/hostname:
  file.managed:
    - contents_grains: hostname

    
