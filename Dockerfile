FROM golang:buster as app

LABEL "com.mogenius.vendor"="Mogenius"
LABEL version="1.0"
LABEL description="TYopass - Share Secrets Securely \
Yopass is a project for sharing secrets in a quick and secure manner*. \
The sole purpose of Yopass is to minimize the amount of passwords floating \
around in ticket management systems, Slack messages and emails. The message \
is encrypted/decrypted locally in the browser and then sent to yopass without \
the decryption key which is only visible once during encryption, yopass then \
returns a one-time URL with specified expiry date. \
There is no perfect way of sharing secrets online and there is a trade off \
in every implementation. Yopass is designed to be as simple and "dumb" as \
possible without compromising on security. There's no mapping between the \
generated UUID and the user that submitted the encrypted message. It's always \
best send all the context except password over another channel."

RUN mkdir -p /yopass
WORKDIR /yopass
COPY . .

# RUN go mod download
RUN go get
RUN go build ./cmd/yopass && go build ./cmd/yopass-server

FROM node:16 as website
COPY website /website
WORKDIR /website
RUN yarn install && yarn build

FROM gcr.io/distroless/base
COPY --from=app /yopass/yopass /yopass/yopass-server /
COPY --from=website /website/build /public
EXPOSE 1337
ENTRYPOINT ["/yopass-server"]
