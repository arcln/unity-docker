FROM ubuntu:16.04

WORKDIR /unity

RUN apt update

RUN apt install -y wget xz-utils libgl-dev

RUN wget "https://download.unity3d.com/download_unity/2285c3239188/LinuxEditorInstaller/Unity.tar.xz" \
	&& xz -d Unity.tar.xz \
	&& tar xf Unity.tar \
	&& rm Unity.tar
