FROM ubuntu:16.04

WORKDIR /unity

RUN apt update

RUN apt install -y wget xz-utils libgl-dev
#fuse libglib2.0-dev libnss3-dev libgdk-pixbuf2.0-0 libgtk-3-dev

RUN wget "https://download.unity3d.com/download_unity/2285c3239188/LinuxEditorInstaller/Unity.tar.xz"

RUN xz -d Unity.tar.xz

RUN rm Unity.tar.xz

RUN tar xf Unity.tar

RUN rm Unity.tar
