FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 安装基本工具和库
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

# 安装 pyenv 依赖
RUN apt-get update && apt-get install -y \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libffi-dev \
    liblzma-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

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

# 安装 JDK 21 和 25
RUN apt-get update && apt-get install -y openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*

# 安装 JDK 25 (从 Oracle 或其他源)
RUN wget https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.tar.gz \
    && mkdir -p /usr/lib/jvm \
    && tar -xzf jdk-25_linux-x64_bin.tar.gz -C /usr/lib/jvm \
    && rm jdk-25_linux-x64_bin.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/jdk-21
ENV PATH=$JAVA_HOME/bin:$PATH

# 安装 Maven
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz \
    && tar -xzf apache-maven-3.9.9-bin.tar.gz -C /opt \
    && ln -s /opt/apache-maven-3.9.9 /opt/maven \
    && rm apache-maven-3.9.9-bin.tar.gz

ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

# 安装 Go 
ENV GO_VERSION=1.25.1
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

ENV PATH=/usr/local/go/bin:$PATH
ENV GOPATH=/root/go
ENV PATH=$GOPATH/bin:$PATH

# 显示版本信息
RUN echo "=== Environment Setup Complete ===" \
    && neofetch \
    && echo "\nNode Version:" && node --version \
    && echo "\nNPM Version:" && npm --version \
    && echo "\nYarn Version:" && yarn --version \
    && echo "\nPnpm Version:" && pnpm --version \
    && echo "\nBun Version:" && bun --version \
    && echo "\nPython Version:" && python --version \
    && echo "\nJava Version:" && java -version \
    && echo "\nMaven Version:" && mvn -version \
    && echo "\nGo Version:" && go version

WORKDIR /workspace

CMD ["/bin/bash"]
