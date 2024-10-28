FROM ubuntu:noble

RUN export DEBIAN_FRONTEND noninteractive && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y net-tools tar unzip curl xz-utils gnupg2 software-properties-common xvfb libc6:i386 locales ca-certificates && \
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen && \
    curl -s https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    apt-add-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ noble main' && \
    apt-get install -y wine-staging wine-staging-i386 wine-staging-amd64 winetricks && \
    userdel -r ubuntu && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s '/home/user/Steam/steamapps/common/Gas Guzzlers Combat Carnage/' /server && \
    useradd -m user

USER user
ENV HOME /home/user
WORKDIR /home/user
VOLUME /home/user/Steam

RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar xz

# Get's killed at the end
RUN ./steamcmd.sh +login anonymous +quit || :
USER root
RUN mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

# Turn off Fixme warnings
ENV WINEDEBUG=fixme-all

# check server info every 30 seconds
HEALTHCHECK --interval=30s --timeout=5s --retries=5 CMD if [ -z "$(netstat -tunlp | grep ${CHECK_PORT})" ]; then exit 1; else exit 0; fi
    
EXPOSE 3555/udp
EXPOSE 3555/tcp
ADD entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]