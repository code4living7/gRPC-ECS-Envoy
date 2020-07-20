# envoy-proxy

Motivation from [here](https://fulcrum.rocks/blog/load-balancer-grpc-aws)

The [image](https://github.com/code4living7/gRPC-ECS-Envoy/blob/master/envoy-proxy/Dockerfile) expects three input:

LISTEN_PORT: Port which sidecar envoy will expose.

SERVICE DISCOVERY ADDRESS: As the application service address

SERVICE DISCOVERY PORT: Application port exposed eg- 50051.
