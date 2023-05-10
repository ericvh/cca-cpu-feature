FROM ubuntu:22.04

RUN mkdir -p /opt/fvp
WORKDIR /opt/fvp
RUN --mount=type=cache,target=/var/cache/apt \
	--mount=type=cache,target=/var/lib/apt/lists \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
	apt-get update && \
	apt-get install -yqq --no-install-recommends \
    ca-certificates \
    libatomic1 \
    iptables \
    screen \
    telnet \
    kmod \
    wget
RUN if [ `uname -m` = "aarch64" ] ; then wget https://developer.arm.com/-/media/Files/downloads/ecosystem-models/FVP_Base_RevC-2xAEMvA_11.21_15_Linux64_armv8l.tgz ; \
                                    else wget https://developer.arm.com/-/media/Files/downloads/ecosystem-models/FVP_Base_RevC-2xAEMvA_11.21_15_Linux64.tgz ; fi \
    && tar xf F*.tgz && rm *.tgz
RUN mkdir -p /opt/cca
WORKDIR /opt/cca
RUN wget -O Image https://github.com/ericvh/cca-cpu/releases/latest/download/Image
RUN	wget -O Image.guest https://github.com/ericvh/cca-cpu/releases/latest/download/Image.guest
RUN	wget -O initramfs.cpio https://github.com/ericvh/cca-cpu/releases/latest/download/initramfs.cpio
RUN	wget -O rmm.img https://github.com/ericvh/cca-cpu/releases/latest/download/rmm.img
RUN	wget -O bl1-linux.bin https://github.com/ericvh/cca-cpu/releases/latest/download/bl1-linux.bin
RUN	wget -O fip-linux.bin https://github.com/ericvh/cca-cpu/releases/latest/download/fip-linux.bin
RUN mkdir -p /usr/local/bin
WORKDIR /usr/local/bin
RUN ln -s /opt/fvp/Base_RevC_AEMvA_pkg/models/Linux64*/FVP_Base_RevC-2xAEMvA fvp
RUN	wget -O cpu https://github.com/ericvh/cca-cpu/releases/latest/download/cpu
RUN wget -O cpud https://github.com/ericvh/cca-cpu/releases/latest/download/cpud
RUN wget -O lkvm https://github.com/ericvh/cca-cpu/releases/latest/download/lkvm
RUN chmod ugo+x lkvm cpu cpud
