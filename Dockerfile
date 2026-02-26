FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    default-jre-headless \
    clang-tidy \
    curl \
    ca-certificates \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages pylint

RUN curl -fsSL https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.21.1/checkstyle-10.21.1-all.jar \
    -o /opt/checkstyle.jar

COPY checkstyle-config.xml /opt/checkstyle-config.xml

ARG TARGETARCH
RUN curl -fsSL "https://go.dev/dl/go1.24.0.linux-${TARGETARCH}.tar.gz" | tar -xz -C /usr/local

ENV PATH="/usr/local/go/bin:${PATH}"

RUN mkdir -p /workspace

RUN useradd -m -s /bin/false linter

USER linter
