FROM ubuntu:22.04

WORKDIR /root

COPY ./conf /root/conf

RUN apt-get -y update && \
    apt-get install -y supervisor vim jq ca-certificates btrfs-progs e2fsprogs iptables openssl uidmap xfsprogs xz-utils pigz fuse-overlayfs wget && \
    mkdir /etc/docker /var/log/supervisord && \
    wget https://download.docker.com/linux/static/stable/x86_64/docker-26.1.4.tgz -O ./docker.tgz && \
    tar -zxvf /root/docker.tgz -C . && \
    cp ./docker/* /usr/bin/ && \
    cp /root/conf/daemon.json /etc/docker/daemon.json && \
    cp /root/conf/supervisord.conf /etc/supervisord.conf && \
    rm -rf /root/conf ./docker* && \
    groupadd docker

ENTRYPOINT ["/usr/bin/supervisord"]
