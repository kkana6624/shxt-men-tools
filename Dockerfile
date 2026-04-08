FROM elixir:latest

# Phoenix(LiveView), DB接続, GleamDL用ツールのインストール
RUN apt-get update && apt-get install -y \
    postgresql-client \
    inotify-tools \
    git \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# アーキテクチャに合わせて最新のGleamをインストール
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
      TARGET="x86_64-unknown-linux-musl"; \
    elif [ "$ARCH" = "aarch64" ]; then \
      TARGET="aarch64-unknown-linux-musl"; \
    else \
      echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    LATEST_VERSION=$(curl -sI https://github.com/gleam-lang/gleam/releases/latest | grep -i location | awk -F '/' '{print $NF}' | tr -d '\r') && \
    curl -fL -o gleam.tar.gz "https://github.com/gleam-lang/gleam/releases/download/${LATEST_VERSION}/gleam-${LATEST_VERSION}-${TARGET}.tar.gz" && \
    tar -xzf gleam.tar.gz && \
    mv gleam /usr/local/bin/ && \
    rm gleam.tar.gz

# ルートレスの一般ユーザ(developer)を作成（既存のUID/GIDとの衝突を回避）
ARG UID=1000
ARG GID=1000
RUN if ! getent group ${GID}; then groupadd -g ${GID} developer; fi && \
    if ! getent passwd ${UID}; then useradd -u ${UID} -g ${GID} -m -s /bin/bash developer; fi

# 作成した開発用ユーザに切り替え
USER ${UID}:${GID}
WORKDIR /app

# Hex, Rebar, Phoenixジェネレータのインストール
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new --force

ENV MIX_ENV=dev
ENV PORT=4000

# 開発用コンテナとして起動し続けるためにsleepを利用
CMD ["sleep", "infinity"]
