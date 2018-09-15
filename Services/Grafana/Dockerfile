FROM grafana/grafana:latest

LABEL maintainer="Ignacio Cabrera <cabrerabywaters@gmail.com>"

USER grafana

ADD datasources /etc/grafana/provisioning/datasources
ADD dashboards /etc/grafana/provisioning/dashboards

EXPOSE 3000
