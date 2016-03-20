FROM debian:jessie-backports
MAINTAINER Voob of Doom <voobscout@gmail.com>

COPY start.sh /
ADD http://winswitch.org/gpg.asc /tmp/winswitch.gpg.key

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    cat /tmp/winswitch.gpg.key | apt-key add - && \
    echo "deb http://winswitch.org/ jessie main" > /etc/apt/sources.list.d/winswitch.list && \
    apt-get -qq update && \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections && \

    apt-get install -t jessie-backports -qqyf \
    openssl \
    gnutls-bin \
    ca-certificates \
    curl \
    locales \
    wget \
    inotify-tools \
    sudo \
    lsb-release \
    kmod \
    augeas-tools \
    cython \
    python-pyopencl \
    websockify \
    libx264-142 \
    x264 \
    libvpx1 \
    vpx-tools \
    winswitch \
    vim \
    vlc \
    xfce4 \
    xfce4-goodies \
    # ruby \
    # ruby-augeas \
    git-core && \

    apt-get -qqfy dist-upgrade && \

    # mkdir -p /etc/skel/.ssh && \
    # echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUKXJgShJMrBFi6VvKCsCJO9c1wLA3ugL3LAJGsRO9KXdZGmLC74/s0KVw4uaWHoTz91qLPdnplSdLU3KDK7loIdKRBR8E4KJ1MiZKGIj7F9NsniiNetQkKvUazrhRx8nFOAYSPD4znkhrh53nXnsI2WDACt0CGNYX33hV3J/kblWYit/wcIEtJg1ivFmBrljtAMZpS2mBpAK0kySCY2BP+Ph8x+6EuCkH1w2J4Moa0fYkibF3K7O4cmcWAtD53eyr8YN4JKvAwTe+uXVsdFDUNkZvCdOLTDDRd7t7C+qL3nbJMv5jVoED0bBBfn7NfEfyqLOzXHmE4bfuMo7KBlH7 vod@agrajag.0.njk.li" > /etc/skel/.ssh/authorized_keys && \
    # chmod 0600 /etc/skel/.ssh/authorized_keys && \

    useradd viptela -m -s /bin/bash && \
    echo "viptela ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins && \

    curl -sL -o /tmp/dumb-init_1.0.0_amd64.deb https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64.deb && \
    dpkg -i /tmp/dumb-init_1.0.0_amd64.deb && \

    apt-get autoremove -y && \
    apt-get clean autoclean && \

    curl -sL -o /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 && \
    chmod 0755 /usr/local/bin/gosu && \

    chmod +x /start.sh && \

    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
# xpra start :200 --bind-tcp=0.0.0.0:10000 --html=on --start-child="startxfce4"
