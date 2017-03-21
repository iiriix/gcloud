FROM alpine:latest
MAINTAINER Iiriix Esmaeeli <iiriix@gmail.com>
ENV ENV=/etc/profile.d/cloud-sdk

RUN apk add --no-cache curl python docker \
  \
  # Installing Google Cloud SDK
  && curl https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz | tar xz \
  && /google-cloud-sdk/install.sh --usage-reporting=false \
       --path-update=false --bash-completion=false \
       --additional-components kubectl \
  \
  # Updating the PATH
  && echo "export PATH=/google-cloud-sdk/bin:$PATH" > ${ENV}

COPY init.sh /init.sh
ENTRYPOINT ["/init.sh"]
