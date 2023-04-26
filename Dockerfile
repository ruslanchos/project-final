FROM node:8

USER root


RUN mkdir /build
WORKDIR /build

COPY . .
RUN yarn install && yarn run build:prod


FROM nginx:1.14-alpine

LABEL maintainer="r.bituck@gmail.com"

COPY deploy/nginx.conf.template /etc/nginx/conf.d/nginx.conf.template

ARG app_name
ENV APP_NAME=${app_name}

COPY --from=0 "/build/dist/" /usr/share/nginx/html/

EXPOSE 80

CMD envsubst '\$APP_SERVER \$APP_HOST \$APP_SCHEMA' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/default.conf && nginx -g "daemon off;"
