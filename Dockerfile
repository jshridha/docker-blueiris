FROM ubuntu:focal

ENV HOME /home/wineuser
ENV WINEPREFIX /home/wineuser/prefix
WORKDIR /home/wineuser
VOLUME /home/wineuser/prefix

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DISPLAY :0
ENV BLUEIRIS_VERSION=5
ENV RESOLUTION=1024x768x24
ENV USRWINE=/usr/share/wine

EXPOSE 8081
EXPOSE 8080

RUN mkdir -p /usr/share/wine/mono /usr/share/wine/gecko
ADD http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86_64.msi $USRWINE/gecko
ADD http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.msi $USRWINE/gecko
ADD https://dl.winehq.org/wine/wine-mono/5.1.0/wine-mono-5.1.0-x86.msi $USRWINE/mono

RUN apt-get update && \
    apt-get install -y wget gnupg software-properties-common winbind python python-numpy unzip jq curl && \
    dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/ && \
    apt-get update && apt-get -y install xvfb x11vnc xdotool wget tar supervisor winehq-devel net-tools fluxbox cabextract && \
    wget -O - https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar -xzv -C $HOME && mv $HOME/noVNC-1.2.0 $HOME/novnc && \
    wget -O - https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar -xzv -C $HOME && mv $HOME/websockify-0.9.0 $HOME/novnc/utils/websockify && \
    wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/bin/winetricks && \
    chmod +x /usr/bin/winetricks && \
    rm -rf /var/lib/apt/lists/*

ADD https://blueirissoftware.com/blueiris.exe blueiris_5.exe
ADD https://blueirissoftware.com/BlueIris_48603.exe blueiris_4.exe
ADD blueiris.sh $HOME/blueiris.sh
ADD service.reg $HOME/service.reg
ADD launch_blueiris.sh $HOME/launch_blueiris.sh
ADD check_process.sh $HOME/check_process.sh
ADD service.sh $HOME/service.sh
ADD supervisord-normal.conf /etc/supervisor/conf.d/supervisord-normal.conf
ADD supervisord-service.conf /etc/supervisor/conf.d/supervisord-service.conf
ADD menu $HOME/menu
ADD get_latest_ui3.sh $HOME/get_latest_ui3.sh

RUN chmod +x $HOME/*.sh && \
    mkdir -p $HOME/.fluxbox && \
    groupadd wineuser && \
    useradd -m -g wineuser wineuser && \
    ln -s $HOME/menu $HOME/.fluxbox/menu && \
    ln -s $HOME/novnc/vnc_lite.html $HOME/novnc/index.html && \
    mkdir -p $HOME/prefix && \
    chown -R wineuser:wineuser $HOME


RUN apt update && \
    apt install -y vainfo vdpauinfo && \
    apt install -y libva-drm2 libva2 i965-va-driver vainfo intel-media-va-driver && \
    apt install -y xserver-xorg-video-dummy x11-apps && \
    apt install -y winehq-staging=5.11~focal wine-staging=5.11~focal wine-staging-i386=5.11~focal wine-staging-amd64=5.11~focal && \
    rm -rf /var/lib/apt/lists/*

RUN usermod -aG video wineuser && usermod -aG render wineuser
RUN rm /etc/localtime
COPY xorg.conf /etc/X11/xorg.conf

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/conf.d/supervisord-normal.conf"]
