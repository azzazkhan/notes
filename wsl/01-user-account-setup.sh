#!/bin/bash

apt-get update && apt upgrade -y \
    && adduser ubuntu \
    && usermod -aG sudo ubuntu \
    && passwd -d ubuntu \
    && mkdir /home/ubuntu/.ssh \
    && cp /root/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys \
    && chown -R ubuntu:root /home/ubuntu/.ssh
