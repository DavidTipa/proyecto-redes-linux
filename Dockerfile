FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    openssh-server sudo curl wget \
    net-tools iproute2 vim cron \
    rsyslog quota e2fsprogs && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

RUN groupadd proyecto && \
    useradd -m -s /bin/bash -G sudo adminuser && \
    useradd -m -s /bin/bash normaluser && \
    useradd -m -s /bin/sh restricteduser && \
    usermod -aG proyecto adminuser && \
    usermod -aG proyecto normaluser

RUN echo "root:Admin123" | chpasswd && \
    echo "adminuser:Admin123" | chpasswd && \
    echo "normaluser:Admin123" | chpasswd && \
    echo "restricteduser:Admin123" | chpasswd

RUN sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs && \
    sed -i 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS   5/' /etc/login.defs && \
    sed -i 's/PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs

RUN chage -M 90 -W 7 normaluser && \
    chage -M 90 -W 7 restricteduser

RUN mkdir -p /home/proyecto-shared /home/admin-only && \
    chown root:proyecto /home/proyecto-shared && \
    chmod 770 /home/proyecto-shared && \
    chown adminuser:adminuser /home/admin-only && \
    chmod 700 /home/admin-only

RUN echo "normaluser       hard    fsize   102400" >> /etc/security/limits.conf && \
    echo "restricteduser   hard    fsize   51200" >> /etc/security/limits.conf

COPY respaldo.sh /usr/local/bin/respaldo.sh
COPY respaldo_incremental.sh /usr/local/bin/respaldo_incremental.sh
COPY respaldo_diferencial.sh /usr/local/bin/respaldo_diferencial.sh
COPY monitor.sh /usr/local/bin/monitor.sh
RUN chmod +x /usr/local/bin/respaldo.sh \
             /usr/local/bin/respaldo_incremental.sh \
             /usr/local/bin/respaldo_diferencial.sh \
             /usr/local/bin/monitor.sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22
CMD ["/start.sh"]
