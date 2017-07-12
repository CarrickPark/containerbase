FROM debian:9.0

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        unzip \
        apt-utils \
    && rm -rf /var/lib/apt/lists/*

ENV CONSUL_VERSION 0.8.5
ENV CONSUL_SHA256 35dc317c80862c306ea5b1d9bc93709483287f992fd0797d214d1cc1848e7b62

ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip /tmp/consul.zip
RUN echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256 \
    && sha256sum -c /tmp/consul.sha256 \
    && cd /bin \
    && unzip /tmp/consul.zip \
    && chmod +x /bin/consul \
    && rm /tmp/consul.zip

ENV CONSUL_TEMPLATE_VERSION 0.19.0
ENV CONSUL_TEMPLATE_SHA256 31dda6ebc7bd7712598c6ac0337ce8fd8c533229887bd58e825757af879c5f9f

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
