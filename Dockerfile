FROM debian:8.7

RUN apt-get update && apt-get install -y --no-install-recommends \
        unzip \
    && rm -rf /var/lib/apt/lists/*

ENV CONSUL_VERSION 0.7.3
ENV CONSUL_SHA256 901a3796b645c3ce3853d5160080217a10ad8d9bd8356d0b73fcd6bc078b7f82

ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip /tmp/consul.zip
RUN echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256 \
    && sha256sum -c /tmp/consul.sha256 \
    && cd /bin \
    && unzip /tmp/consul.zip \
    && chmod +x /bin/consul \
    && rm /tmp/consul.zip

ENV CONSUL_TEMPLATE_VERSION 0.18.1
ENV CONSUL_TEMPLATE_SHA256 99dcee0ea187c74d762c5f8f6ceaa3825e1e1d4df6c0b0b5b38f9bcb0c80e5c8

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /tmp/consul-template.zip
RUN echo "${CONSUL_TEMPLATE_SHA256}  /tmp/consul-template.zip" > /tmp/consul-template.sha256 \
    && sha256sum -c /tmp/consul-template.sha256 \
    && cd /bin \
    && unzip /tmp/consul-template.zip \
    && chmod +x /bin/consul-template \
    && rm /tmp/consul-template.zip

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp
ENV DNS_RESOLVES consul
ENV DNS_PORT 8600

ADD ./config/agent.json /config/agent.json
ADD ./bin/entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
