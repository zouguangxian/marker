#   /\_/\
#  ( o.o )
#   > ^ <
FROM debian:bullseye-slim AS builder
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        sudo curl wget git lsb-release \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY ./scripts/install/ghostscript_install.sh /app/scripts/install/

RUN export DEBIAN_FRONTEND=noninteractive \
    && find /app/scripts/install/ -iname '*.sh' -exec chmod +x {} \; \
    && /app/scripts/install/ghostscript_install.sh 

#   /\_/\
#  ( o.o )
#   > ^ <
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates gnupg \
        sudo curl wget git lsb-release \
        build-essential \
        vim-tiny \
        python3 python3-distutils python3-pip python3-dev \
    && update-alternatives --install /usr/bin/vim vim /usr/bin/vim.tiny 10 \        
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/ /opt/

COPY ./ /app/

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 82F409933771AC78 \
    && find /app/scripts/install/ -iname '*.sh' -exec chmod +x {} \; \
    && /app/scripts/install/tesseract_5_install.sh \
    && cat /app/scripts/install/apt-requirements.txt | xargs sudo apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 - \
    && PATH="/root/.local/bin:/opt/bin:$PATH" 

RUN TESSDATA_PREFIX=$(find / -iname 'tessdata' -type d) \
    && echo "TESSDATA_PREFIX=$TESSDATA_PREFIX" >> /app/local.env \
    && echo 'export PATH=/root/.local/bin:/opt/bin:$PATH' >> ~/.bashrc \
    && echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd' >> /etc/bash.bashrc \
    && echo '[ ! -z "$TERM" -a -r /etc/user-guide ] && cat /etc/user-guide' >> /etc/bash.bashrc

RUN cat <<EOF > /etc/user-guide

  /\_/\\
 ( o.o )
  > ^ <

https://github.com/VikParuchuri/marker

cd /app \
&& poetry lock \
&& poetry install \
&& poetry remove torch \
&& poetry run pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

EOF
