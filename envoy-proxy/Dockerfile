FROM envoyproxy/envoy:v1.14.1


COPY start-envoy.sh /start-envoy.sh
COPY envoy.yml /tmpl/envoy.yml

RUN chmod +x /start-envoy.sh
RUN apt-get update && \
    apt-get install gettext -y

ENTRYPOINT ["/start-envoy.sh"]
