FROM ubuntu:22.04

WORKDIR /root

COPY ./conf /conf

RUN apt-get -y update && \
    apt-get install -y supervisor vim jq ca-certificates btrfs-progs e2fsprogs iptables openssl uidmap xfsprogs xz-utils pigz fuse-overlayfs wget openssh-server && \
    # sshd
    echo 'root:qwe123456' | chpasswd && \
    mkdir -p /var/run/sshd && \ 
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    # docker
    mkdir -p /etc/docker && \
    cp /conf/daemon.json /etc/docker/daemon.json && \
    wget https://download.docker.com/linux/static/stable/x86_64/docker-26.1.4.tgz -O ./docker.tgz && \
    tar -zxvf /root/docker.tgz -C . && \
    cp ./docker/* /usr/bin/ && \
    groupadd docker && \
    # supervisor
    mkdir -p /var/log/supervisord && \
    cp /conf/supervisord.conf /etc/supervisord.conf && \
    rm -rf /conf ./docker*

EXPOSE 22

ENTRYPOINT ["/usr/bin/supervisord"]

