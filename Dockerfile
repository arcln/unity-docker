FROM ubuntu:16.04

WORKDIR /unity

RUN apt update

RUN apt install -y wget xz-utils

RUN wget "https://download.unity3d.com/download_unity/2285c3239188/LinuxEditorInstaller/Unity.tar.xz" \
	&& xz -d Unity.tar.xz \
	&& tar xf Unity.tar \
	&& rm Unity.tar

RUN apt install -y libgl-dev libxcursor1 libxrandr-dev libgtk-3-dev

# mac build support
RUN wget https://download.unity3d.com/download_unity/2285c3239188/MacEditorTargetInstaller/UnitySetup-Mac-Mono-Support-for-Editor-2020.1.1f1.pkg
	&& xar -xf UnitySetup-Mac-Mono-Support-for-Editor-2020.1.1f1.pkg -C Editor/Data/PlaybackEngines/MacStandaloneSupport
	&& rm UnitySetup-Mac-Mono-Support-for-Editor-2020.1.1f1.pkg

# above is not required
RUN apt install -y python-software-properties software-properties-common

RUN add-apt-repository ppa:git-core/ppa -y

RUN apt update

RUN apt install -y ssh zip curl git

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt install -y git-lfs

RUN git lfs install
