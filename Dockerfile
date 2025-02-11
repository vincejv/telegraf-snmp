FROM telegraf:1.33.2

RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list && \
	apt-get update &&  apt-get -y install snmp-mibs-downloader curl && \
	sed -i "s/^\(mibs *:\).*/#\1/" /etc/snmp/snmp.conf && \
	curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
	apt-get -y install speedtest && mkdir -p /root/.config/ookla && \
	mkdir -p /etc/telegraf/.config/ookla && chown telegraf:telegraf -R /etc/telegraf/.config/ && \
  rm -rf /var/lib/apt/lists/*

COPY NAS.mib PowerNet436.mib /usr/share/snmp/mibs/
COPY --chown=telegraf speedtest-cli.json /etc/telegraf/.config/ookla
COPY speedtest-cli.json /root/.config/ookla
