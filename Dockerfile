FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    git \
    cmake \
    python3 \
    python3-pip \
    build-essential \
    libdbus-1-3 \
    libpulse-mainloop-glib0 \
    libxcb-xinerama0 \
    libxkbcommon-x11-0 \
    libfontconfig1 \
    wget \
    libfuse2 \
    libgnutls30 \
    libgnutls28-dev \
    libgl1-mesa-dev \
    mesa-common-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install aqtinstall

RUN aqt install-qt linux desktop 6.7.3 linux_gcc_64 -O /opt/Qt

ENV PATH="/opt/Qt/6.7.3/gcc_64/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/Qt/6.7.3/gcc_64/lib:$LD_LIBRARY_PATH"

WORKDIR /workspace/web3-pi-imager

RUN wget https://github.com/TheAssassin/appimagecraft/releases/download/continuous/appimagecraft-x86_64.AppImage && \
    chmod +x appimagecraft-x86_64.AppImage

CMD ["/bin/bash"]