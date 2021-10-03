FROM openjdk:12

# copied from lanrat/xpra-html5
RUN yum update -y && \
    rpm --import https://winswitch.org/gpg.asc && \
    cd /etc/yum.repos.d/ && \
    curl -O https://winswitch.org/downloads/CentOS/winswitch.repo && \
    yum update -y --enablerepo ol7_optional_latest && \
    yum install -y --enablerepo ol7_optional_latest xorg-x11-server-Xvfb.x86_64 xpra xterm && \
    yum clean -y all 

RUN yum install -y wget

RUN wget -O - https://s3.amazonaws.com/downloads.eviware/soapuios/5.6.0/SoapUI-5.6.0-linux-bin.tar.gz | tar -zx -C /opt/

RUN useradd -m soapui && chown soapui:soapui -R /home/soapui /opt/SoapUI-5.6.0
USER soapui
WORKDIR /home/soapui

EXPOSE 10001
ENV DISPLAY=:100
CMD xpra start --bind-tcp=0.0.0.0:10001 --html=on --start-child=/opt/SoapUI-5.6.0/bin/soapui.sh --exit-with-children --daemon=no --xvfb="/usr/bin/Xvfb +extension  Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no

