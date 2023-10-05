# Telegraf Docker image for scraping SNMP from QNAP and APC devices

A fork of https://github.com/pheetr/telegraf-snmp, as the image is broken due to apt sources dead links and it doesn't support ARM platforms, would push a PR to that release, but the issues tab is not available

Example configuration improved so that it can be sanely used with Grafana (e.g. using device identifiers, names and tags, preferring integers for values instead of strings, etc).

## Running
Docker Pull
```
docker pull vincejv/telegraf-snmp:latest
```
Docker Run
```sh
docker run -d \
  --name telegraf-snmp \
  -v /your_host_location/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf \
  --restart unless-stopped \
  vincejv/telegraf-snmp:latest
```
Docker Compose
```yaml
version: '3'

services:
  telegraf:
    image: vincejv/telegraf-snmp:latest
    container_name: telegraf
    user: root # run only as root if you have CAP_RAW issues
    volumes:
      # Mount for telegraf config
      - your_host_location/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro
    restart: unless-stopped
```

# Worth noting

* Based on `snmpwalk` it seems that Qnap doesn't publish eg. memory metrics (cache, buffers) so this config just uses the very basic free/total values from their own OIDs.

* Didn't add SSD cache metrics as I don't use that feature

* `speedtest-cli` by Ookla is installed and can be used using the input configuration below, EULA is accepted by default, use Grafana Dashboard Id `12428` to visualize the data
  ```
  #
  # speedtest-cli by Ookla
  #

  [[inputs.exec]]
  commands = ["/usr/bin/speedtest -f json"]
  name_override = "speedtest"
  timeout = "4m"
  interval = "20m"
  data_format = "json"
  json_string_fields = [ "interface_externalIp",
                        "server_name",
                        "server_location",
                        "server_host",
                        "server_ip",
                        "result_url" ]
  ```

* Added support for `linux/amd64`,`linux/arm64`,`linux/386`,`linux/arm/v7`,`linux/arm/v6`

# Automated release

GitHub Action detects new versions at <https://github.com/influxdata/telegraf/releases>.
If new version detected:
* build new Docker image with latest version
* push it to Docker Hub at <https://hub.docker.com/repository/docker/pidity/telegraf-snmp>