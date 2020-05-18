ARG ARROW_VERSION="0.17.0"

FROM python:3.8-slim as builder
ARG ARROW_VERSION

RUN pip install --no-cache pyarrow=="${ARROW_VERSION}"

FROM debian:stable-slim
ARG ARROW_VERSION

COPY --from=builder /usr/local/lib/python3.8/site-packages/pyarrow/libarrow.so.* /usr/lib/
COPY --from=builder /usr/local/lib/python3.8/site-packages/pyarrow/libplasma.so.* /usr/lib/
COPY --from=builder /usr/local/lib/python3.8/site-packages/pyarrow/plasma-store-server /usr/local/bin/

RUN useradd --create-home --home-dir /home/plasma plasma \
	&& chown -R plasma:plasma /home/plasma

USER plasma

ENTRYPOINT ["/usr/local/bin/plasma-store-server"]
