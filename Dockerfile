FROM ubuntu:16.04

WORKDIR /unity

RUN apt update

RUN apt install -y wget xz-utils cpio

RUN wget "https://download.unity3d.com/download_unity/2285c3239188/LinuxEditorInstaller/Unity.tar.xz" \
	&& xz -d Unity.tar.xz \
	&& tar xf Unity.tar \
	&& rm Unity.tar

RUN apt install -y libgl-dev libxcursor1 libxrandr-dev libgtk-3-dev

# build xar
RUN apt install -y build-essential libxml2-dev libssl-dev zlib1g-dev

RUN wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/xar/xar-1.5.2.tar.gz \
	&& tar -zxvf xar-1.5.2.tar.gz \
	&& cd xar-1.5.2 \
	&& ./configure \
	&& make \
	&& make install
	
# mac build support
RUN cd /tmp \
	&& wget https://download.unity3d.com/download_unity/2285c3239188/MacEditorTargetInstaller/UnitySetup-Mac-Mono-Support-for-Editor-2020.1.1f1.pkg -O mac-support.pkg \
	&& ls \
	&& xar -xf mac-support.pkg \
	&& ls \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/MacStandaloneSupport \
	&& cd /unity/Editor/Data/PlaybackEngines/MacStandaloneSupport \
	&& cat /tmp/TargetSupport.pkg.tmp/Payload | gunzip -dc | cpio -i \
	&& ls \
	&& rm -r /tmp/*
	
# windows build support
RUN cd /tmp \
	&& wget https://download.unity3d.com/download_unity/2285c3239188/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-2020.1.1f1.pkg -O windows-support.pkg \
	&& ls \
	&& xar -xf windows-support.pkg \
	&& ls \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/WindowsStandaloneSupport \
	&& cd /unity/Editor/Data/PlaybackEngines/WindowsStandaloneSupport \
	&& cat /tmp/TargetSupport.pkg.tmp/Payload | gunzip -dc | cpio -i \
	&& ls \
	&& rm -r /tmp/*

# android build support
RUN cd /tmp \
	&& wget https://download.unity3d.com/download_unity/2285c3239188/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-2020.1.1f1.pkg -O android-support.pkg \
	&& ls \
	&& xar -xf android-support.pkg \
	&& ls \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/AndroidPlayer \
	&& cd /unity/Editor/Data/PlaybackEngines/AndroidPlayer \
	&& cat /tmp/TargetSupport.pkg.tmp/Payload | gunzip -dc | cpio -i \
	&& ls \
	&& rm -r /tmp/*
	
# ios build support
RUN cd /tmp \
	&& wget https://download.unity3d.com/download_unity/2285c3239188/LinuxEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-2020.1.1f1.tar.xz -O ios-support.tar.xz \
	&& ls \
	&& xz -d ios-support.tar.xz
	&& ls \
	&& cd /unity/Editor/Data/PlaybackEngines \
	&& tar -xf /tmp/ios-support.tar
	&& ls \
	&& rm -r /tmp/*

# above is not required
RUN apt install -y python-software-properties software-properties-common

RUN add-apt-repository ppa:git-core/ppa -y

RUN apt update

RUN apt install -y ssh zip curl git

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt install -y git-lfs

RUN git lfs install
