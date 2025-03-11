FROM pengzhile/new-api:latest
RUN apk update && apk add --no-cache redis
ENV REDIS_CONN_STRING=redis://default:redispw@localhost:49153
CMD redis-server --bind 0.0.0.0 ::1 --port 49153 --requirepass redispw & newapi