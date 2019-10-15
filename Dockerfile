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
    && export PAGER=less \
    && rm /usr/bin/vi \
    && ln -s /usr/bin/vim /usr/bin/vi \
    && groupadd -r safeguard \
    && useradd -r -g safeguard -s /bin/bash safeguard \
    && mkdir -p /home/safeguard \
    && chown -R safeguard:safeguard /home/safeguard

COPY .bashrc /home/safeguard/
COPY scripts/ /scripts/
COPY service/ /service/

RUN cd /service && npm install

USER safeguard
WORKDIR /home/safeguard

ENTRYPOINT ["/bin/bash"]
CMD ["-c","exec /bin/bash --rcfile <(echo '. /home/safeguard/.bashrc; /scripts/start.sh')"]

