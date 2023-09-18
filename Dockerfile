FROM telegraf:latest

RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list && \
	apt-get update &&  apt-get -y install snmp-mibs-downloader curl && \
	sed -i "s/^\(mibs *:\).*/#\1/" /etc/snmp/snmp.conf && \
  curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
  apt-get -y install speedtest

COPY NAS.mib PowerNet436.mib /usr/share/snmp/mibs/
COPY speedtest-cli.json /speedtest-cli.json