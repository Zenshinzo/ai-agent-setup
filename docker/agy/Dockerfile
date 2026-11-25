# Antigravity CLI (agy, Google Gemini), isolated. Runs as user gemini.
# No access to the host's home folder, vault, ~/.claude or SSH keys. Only ./work is mounted.
# Binary: install agy with Google's official installer, then copy the agy binary into this folder
# before building (it is not included in this repo).
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates bash git \
    && rm -rf /var/lib/apt/lists/*
COPY --chmod=0755 agy /usr/local/bin/agy
RUN userdel -r ubuntu 2>/dev/null || true; useradd -m -u 2003 -s /bin/bash gemini && mkdir -p /work && chown gemini:gemini /work
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh
USER gemini
WORKDIR /work
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["agy", "--help"]
