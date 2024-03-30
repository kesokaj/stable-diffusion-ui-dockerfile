FROM debian:stable-slim

ENV LOCAL_USER="user"
ENV WORKSPACE="/workspace"
ENV SD_INSTALL_DIR="/usr/local/stable-diffusion"

RUN apt-get update && apt-get install -y \
    wget \
    git \
    python3 \
    python3-venv \
    libgl1 \
    libglib2.0-0 \
    python-is-python3 \
    google-perftools

RUN mkdir -p ${WORKSPACE}
RUN mkdir -p ${SD_INSTALL_DIR}

RUN useradd -rm -d /home/${LOCAL_USER} -s /bin/bash -G sudo -u 666 ${LOCAL_USER}
RUN echo "${LOCAL_USER} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN chgrp -R ${LOCAL_USER} ${WORKSPACE} && chmod -R 755 ${WORKSPACE} && chown -R ${LOCAL_USER}:sudo ${WORKSPACE}
RUN chgrp -R ${LOCAL_USER} ${SD_INSTALL_DIR} && chmod -R 755 ${SD_INSTALL_DIR} && chown -R ${LOCAL_USER}:sudo ${SD_INSTALL_DIR}

USER ${LOCAL_USER}
WORKDIR /usr/local/stable-diffusion
RUN wget -q https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh
RUN chmod a+x webui.sh
RUN ./webui.sh --skip-torch-cuda-test --precision full --no-half --share --listen

WORKDIR ${WORKSPACE}
#CMD [ "executable" ]