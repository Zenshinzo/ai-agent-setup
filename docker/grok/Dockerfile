# Grok Build CLI, isolated.
# No access to the host's home folder, vault, ~/.claude or SSH keys. Only ./work is mounted.
FROM ubuntu:24.04
ARG GROK_VERSION=1.0.89
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl bash git \
    && rm -rf /var/lib/apt/lists/*
# Official installer, pinned version, into a throwaway HOME; keep only the binary.
RUN HOME=/tmp/gi bash -c 'curl -fsSL https://x.ai/cli/install.sh | bash -s ${GROK_VERSION}' \
    && install -m 0755 "$(readlink -f /tmp/gi/.grok/bin/grok)" /usr/local/bin/grok \
    && rm -rf /tmp/gi
RUN useradd -m -u 2001 -s /bin/bash grok && mkdir -p /work && chown grok:grok /work
COPY --chown=grok:grok config.toml /etc/grok-seed/config.toml
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh
USER grok
WORKDIR /work
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["grok", "--help"]
