FROM golang:1.14.2-alpine3.11 as build-stage

WORKDIR /app

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go/vendor
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o grpc-service

FROM alpine:latest
COPY --from=build-stage /app/grpc-service /usr/local/bin/grpc-service
RUN chmod +x /usr/local/bin/grpc-service
ENTRYPOINT ["grpc-service"]
