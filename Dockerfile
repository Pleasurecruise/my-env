FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 安装系统依赖需求
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    neofetch \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    git \
    curl \
    wget \
    vim \
    nano \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    zip \
    unzip \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libffi-dev \
    liblzma-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 NVM 
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=24
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION.0.0/bin:$PATH

# 安装 Node.js 包管理器 (通过 corepack)
RUN . "$NVM_DIR/nvm.sh" \
    && corepack enable \
    && corepack prepare pnpm@latest --activate \
    && corepack prepare yarn@stable --activate \
    && npm install -g bun

# 安装 pyenv
ENV PYENV_ROOT=/root/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN curl https://pyenv.run | bash \
    && pyenv install 3.13 \
    && pyenv global 3.13

# 安装 Miniconda
ENV CONDA_DIR=/opt/conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p $CONDA_DIR \
    && rm /tmp/miniconda.sh \
    && $CONDA_DIR/bin/conda init bash

ENV PATH=$CONDA_DIR/bin:$PATH

# 安装 Python 开发工具
RUN pip install --no-cache-dir \
    jupyter \
    notebook \
    jupyterlab \
    ipython \
    numpy \
    pandas \
    matplotlib \
    scipy \
    scikit-learn \
    requests

# Install SDKMAN! and manage multiple JDK versions
ENV SDKMAN_DIR=/root/.sdkman
ENV JAVA21_VERSION=21.0.5-tem
ENV JAVA24_VERSION=24-open
RUN curl -s "https://get.sdkman.io" | bash \
    && bash -c "source $SDKMAN_DIR/bin/sdkman-init.sh \
        && sdk install java ${JAVA21_VERSION} \
        && sdk install java ${JAVA24_VERSION} \
        && sdk default java ${JAVA21_VERSION}"

ENV JAVA_HOME=$SDKMAN_DIR/candidates/java/current
ENV PATH=$JAVA_HOME/bin:$PATH

# 安装 Maven
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz \
    && tar -xzf apache-maven-3.9.11-bin.tar.gz -C /opt \
    && ln -s /opt/apache-maven-3.9.11 /opt/maven \
    && rm apache-maven-3.9.11-bin.tar.gz

ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

# 安装 Go
ENV GO_VERSION=1.23.5
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

ENV PATH=/usr/local/go/bin:$PATH
ENV GOPATH=/root/go
ENV PATH=$GOPATH/bin:$PATH

# 将环境变量写入 .bashrc
RUN echo '' >> /root/.bashrc \
    && echo '# NVM configuration' >> /root/.bashrc \
    && echo 'export NVM_DIR="/root/.nvm"' >> /root/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc \
    && echo '' >> /root/.bashrc \
    && echo '# Pyenv configuration' >> /root/.bashrc \
    && echo 'export PYENV_ROOT="/root/.pyenv"' >> /root/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> /root/.bashrc \
    && echo '' >> /root/.bashrc \
    && echo '# Conda configuration' >> /root/.bashrc \
    && echo 'export CONDA_DIR="/opt/conda"' >> /root/.bashrc \
    && echo 'export PATH="$CONDA_DIR/bin:$PATH"' >> /root/.bashrc \
    && echo '' >> /root/.bashrc \
    && echo '# SDKMAN configuration' >> /root/.bashrc \
    && echo 'export SDKMAN_DIR="/root/.sdkman"' >> /root/.bashrc \
    && echo '[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"' >> /root/.bashrc \
    && echo 'export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"' >> /root/.bashrc \
    && echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /root/.bashrc \
    && echo '' >> /root/.bashrc \
    && echo '# Maven configuration' >> /root/.bashrc \
    && echo 'export MAVEN_HOME="/opt/maven"' >> /root/.bashrc \
    && echo 'export PATH="$MAVEN_HOME/bin:$PATH"' >> /root/.bashrc \
    && echo '' >> /root/.bashrc \
    && echo '# Go configuration' >> /root/.bashrc \
    && echo 'export GOPATH="/root/go"' >> /root/.bashrc \
    && echo 'export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"' >> /root/.bashrc

# 显示版本信息
RUN echo "=== Environment Setup Complete ===" \
    && neofetch \
    && echo "\nPython Version:" && python --version \
    && echo "\nConda Version:" && conda --version \
    && echo "\nNode Version:" && . "$NVM_DIR/nvm.sh" && node --version \
    && echo "\nNPM Version:" && . "$NVM_DIR/nvm.sh" && npm --version \
    && echo "\nYarn Version:" && . "$NVM_DIR/nvm.sh" && yarn --version \
    && echo "\nPnpm Version:" && . "$NVM_DIR/nvm.sh" && pnpm --version \
    && echo "\nBun Version:" && . "$NVM_DIR/nvm.sh" && bun --version \
    && echo "\nPython Version:" && python --version \
    && echo "\nJava Version:" && java -version \
    && echo "\nMaven Version:" && mvn -version \
    && echo "\nGo Version:" && go version

WORKDIR /workspace

CMD ["/bin/bash"]
