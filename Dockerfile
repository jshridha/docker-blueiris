FROM ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV WINEPREFIX /root/prefix
ENV DISPLAY :0
ENV BLUEIRIS_VERSION=5
ENV RESOLUTION=1024x768x24

ADD blueiris.sh /root/blueiris.sh
ADD service.reg /root/service.reg
ADD launch_blueiris.sh /root/launch_blueiris.sh
ADD check_process.sh /root/check_process.sh
ADD service.sh /root/service.sh
ADD supervisord-normal.conf /etc/supervisor/conf.d/supervisord-normal.conf
ADD supervisord-service.conf /etc/supervisor/conf.d/supervisord-service.conf
ADD menu /root/menu
ADD get_latest_ui3.sh /root/get_latest_ui3.sh
ADD http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86_64.msi /root/
ADD http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.msi /root/
ADD https://dl.winehq.org/wine/wine-mono/5.1.0/wine-mono-5.1.0-x86.msi /root/

WORKDIR /root/
RUN apt-get update && \
    apt-get install -y wget gnupg software-properties-common winbind python cifs-utils unzip jq curl && \
    dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/ && \
    apt-get update && apt-get -y install xvfb x11vnc xdotool wget tar supervisor winehq-devel net-tools fluxbox cabextract && \
    wget -O - https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.2.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html && \
    wget -O - https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.9.0 /root/novnc/utils/websockify && \
    # Configure user nobody to match unRAID's settings && \
    usermod -u 99 nobody && \
    usermod -g 100 nobody && \
    usermod -d /config nobody && \
    chown -R nobody:users /home && \
    cd /usr/bin/ && \
    wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    sh winetricks win10 && \
    sh winetricks -q corefonts wininet && \
    chmod +x /root/blueiris.sh /root/launch_blueiris.sh /root/check_process.sh /root/service.sh /root/get_latest_ui3.sh && \
    mv /root/prefix /root/prefix_original && \
    mkdir -p /root/prefix /usr/share/wine/mono /usr/share/wine/gecko && \
    mv /root/*gecko*.msi /usr/share/wine/gecko/ && mv /root/*mono*.msi /usr/share/wine/mono/ && \
    mkdir -p /root/.fluxbox && \
    ln -s /root/menu /root/.fluxbox/menu && \
    rm -rf /var/lib/apt/lists/*

# Expose Port
EXPOSE 8080

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/conf.d/supervisord-normal.conf"]
