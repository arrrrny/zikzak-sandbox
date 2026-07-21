FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"
ENV CHROME_EXECUTABLE=/usr/bin/chromium-browser

# ── System dependencies ──────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Flutter Linux desktop build deps
    bash curl file git unzip xz-utils zip \
    clang cmake ninja-build pkg-config \
    libgtk-3-dev liblzma-dev libstdc++-12-dev \
    # Headless testing
    xvfb \
    # Web / headless browser
    chromium-browser \
    # Node.js prereqs
    ca-certificates gnupg \
    # Utilities
    wget jq \
    && rm -rf /var/lib/apt/lists/*

# ── Node.js 20 (for Docusaurus website) ──────────────────────────────
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
      gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
      > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# ── Flutter SDK (latest stable) ──────────────────────────────────────
RUN git clone https://github.com/flutter/flutter.git \
      --depth 1 -b stable /opt/flutter

# ── Daytona user ─────────────────────────────────────────────────────
RUN useradd -m -s /bin/bash daytona && \
    mkdir -p /workspace && \
    chown -R daytona:daytona /workspace /opt/flutter

USER daytona
ENV PATH="/opt/flutter/bin:${PATH}"
WORKDIR /workspace

RUN flutter precache --linux --web --no-android
RUN flutter config --no-analytics
RUN dart --disable-analytics

# ── Entrypoint script ────────────────────────────────────────────────
COPY --chown=daytona:daytona entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sleep", "infinity"]
