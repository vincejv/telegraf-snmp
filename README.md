# Telegraf Docker image for scraping SNMP from QNAP and APC devices

Building upon work in https://gitlab.com/artkrz/telegraf-qnap and https://github.com/n1koo/qnap-telegraf

Example configuration improved so that it can be sanely used with Grafana (e.g. using device identifiers, names and tags, preferring integers for values instead of strings, etc).

## Running

```
docker run -d --name qnap-snmp-telegraf \
           -v /your_host_location/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf \
           qnap-snmp-telegraf --config /etc/telegraf/telegraf.conf
```

# Worth noting

Based on `snmpwalk` it seems that Qnap doesn't publish eg. memory metrics (cache, buffers) so this config just uses the very basic free/total values from their own OIDs.

Didn't add SSD cache metrics as I don't use that feature

# Automated release

GitHub Action detects new versions at <https://github.com/influxdata/telegraf/releases>.
If new version detected:
* build new Docker image with latest version
* push it to Docker Hub at <https://hub.docker.com/repository/docker/pidity/telegraf-snmp>