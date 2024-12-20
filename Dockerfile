FROM alpine

RUN apk add --no-cache git openssh-client

ADD *.sh /

RUN chmod +x /*.sh

ENTRYPOINT ["/entrypoint.sh"]
