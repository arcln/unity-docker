FROM ubuntu:16.04

WORKDIR /unity

RUN apt update

RUN apt install -y wget xz-utils

RUN wget "https://download.unity3d.com/download_unity/2285c3239188/LinuxEditorInstaller/Unity.tar.xz" \
	&& xz -d Unity.tar.xz \
	&& tar xf Unity.tar \
	&& rm Unity.tar

RUN apt install -y libgl-dev libxcursor1 libxrandr-dev libgtk-3-dev

# above is not required
RUN apt install -y ssh zip git curl

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt install -y git-lfs

RUN git lfs init
