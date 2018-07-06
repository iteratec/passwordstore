FROM golang:1.10
LABEL maintainer="nils.kuhn@iteratec.de"

RUN apt-get update && \
    yes | apt-get install gnupg2

RUN mkdir /root/.gnupg && chmod 700 /root/.gnupg
RUN go get github.com/gopasspw/gopass

ADD gpg.conf /root/.gnupg/gpg.conf
ADD gpg-agent.conf /root/.gnupg/gpg-agent.conf
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]