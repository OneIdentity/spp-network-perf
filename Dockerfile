FROM alpine
MAINTAINER support@oneidentity.com

COPY data/ /data/

RUN apk -U --no-cache add \
        man \
        man-pages \
        mdocml-apropos \
        less \
        less-doc \
        texinfo \
        shadow \
        vim \
        curl \
        jq \
        grep \
        sed \
        coreutils \
        util-linux \
        bash \
        openssl \
        openssh \
        tinc \
        tinc-doc \
        nodejs \
        npm \
        iproute2 \
        net-tools \
        iperf3 \
    && rm /usr/bin/vi \
    && ln -s /usr/bin/vim /usr/bin/vi \
    && mv /data/.bashrc /root \
    && mv /data/scripts /scripts \
    && mv /data/keys /keys \
    && mv /data/service /service \
    && rm -rf /data \
    && chmod 600 /keys/*.priv \
    && mkdir -p /etc/tinc/hosts \
    && cd /service && npm install

ENTRYPOINT ["/bin/bash"]
CMD ["-c","exec /bin/bash --rcfile <(echo '. /root/.bashrc; /scripts/start.sh')"]

