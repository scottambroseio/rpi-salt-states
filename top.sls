base:
  '*':
    - vim-package
    - scott-user
    - root-user
    - pi-user
    - sshd_config
    - golang-install
  'rpi3[abc]':
    - hosts
    - git-package
    - etcd-service
    - zookeeper-service
    - kafka-service
