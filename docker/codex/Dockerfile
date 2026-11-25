# Codex CLI (OpenAI), isolated. Runs as user chatgpt.
# No access to the host's home folder, vault, ~/.claude or SSH keys. Only ./work is mounted.
FROM node:22-bookworm-slim
ARG CODEX_VERSION=0.163.0
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates git bash \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g @openai/codex@${CODEX_VERSION} && npm cache clean --force
RUN useradd -m -u 2002 -s /bin/bash chatgpt && mkdir -p /work && chown chatgpt:chatgpt /work
COPY --chown=chatgpt:chatgpt config.toml /etc/codex-seed/config.toml
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh
USER chatgpt
WORKDIR /work
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["codex", "--help"]
