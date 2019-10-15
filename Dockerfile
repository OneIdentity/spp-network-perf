FROM alpine
MAINTAINER support@oneidentity.com

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
        iperf3 \
    && rm /usr/bin/vi \
    && ln -s /usr/bin/vim /usr/bin/vi \
    && groupadd -r safeguard \
    && useradd -r -g safeguard -s /bin/bash safeguard \
    && mkdir -p /home/safeguard \
    && chown -R safeguard:safeguard /home/safeguard

COPY .bashrc /home/safeguard/
COPY scripts/ /scripts/
COPY keys/ /keys/
COPY service/ /service/

RUN mkdir -p /etc/tinc/hosts \
    && chown -R safeguard:safeguard /etc/tinc \
    && chown -R safeguard:safeguard /home/safeguard \
    && chown -R safeguard:safeguard /scripts \
    && chown -R safeguard:safeguard /keys \
    && chown -R safeguard:safeguard /service \
    && cd /service && npm install

USER safeguard
WORKDIR /home/safeguard

ENTRYPOINT ["/bin/bash"]
CMD ["-c","exec /bin/bash --rcfile <(echo '. /home/safeguard/.bashrc; /scripts/start.sh')"]

