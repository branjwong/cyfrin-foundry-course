FROM mcr.microsoft.com/devcontainers/base:debian-10

RUN <<EOT bash
    apt update
    apt install curl

    curl -L https://foundry.paradigm.xyz | bash
    source /root/.bashrc
    foundryup
EOT
