FROM ghcr.io/actions-runner-controller/actions-runner-controller/actions-runner:v2.321.0-ubuntu-20.04  

ARG TARGETPLATFORM
ARG TFENV_VERSION = v3.0.0
ARG TERRAFORM_VERSION=1.8.5
ARG HELM_VERSION=3.16.3

USER root

RUN test -n "$TARGETPLATFORM" || (echo "TARGETPLATFORM must be set" && false)

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:git-core/ppa \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    dnsutils \
    ftp \
    git \
    iproute2 \
    iputils-ping \
    jq \
    libunwind8 \
    locales \
    netcat \
    openssh-client \
    parallel \
    python3-pip \
    rsync \
    shellcheck \
    sudo \
    telnet \
    time \
    tzdata \
    unzip \
    upx \
    wget \
    zip \
    zstd \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    && rm -rf /var/lib/apt/lists/*


    #Install Azure CLI
    RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
        && apt-get update \
        && apt-get install -y azure-cli \
        && rm -rf /var/lib/apt/lists/*

    # Install tfenv and terraform
    ENV PATH="/home/runner/.tfenv/bin:${PATH}"
    RUN git clone -b ${TFENV_VERSION} --depth 1 https://github.com/tfutils/tfenv.git /home/runner/.tfenv && \
        tfenv install ${TERRAFORM_VERSION} && tfenv use ${TERRAFORM_VERSION}

    RUN chown -R runner /home/runner/.azure 

    RUN echo PATH=$PATH >> /runnertmp/.env

    USER runner
