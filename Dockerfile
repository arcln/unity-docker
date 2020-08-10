FROM ubuntu:16.04

WORKDIR /unity

RUN apt update

RUN apt install -y wget xz-utils xar

RUN wget "https://download.unity3d.com/download_unity/2285c3239188/LinuxEditorInstaller/Unity.tar.xz" \
	&& xz -d Unity.tar.xz \
	&& tar xf Unity.tar \
	&& rm Unity.tar

RUN apt install -y libgl-dev libxcursor1 libxrandr-dev libgtk-3-dev

# build xar
RUN apt install -y build-essential libxml2-dev libssl1.0-dev zlib1g-dev

RUN wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/xar/xar-1.5.2.tar.gz \
	&& tar -zxvf xar-1.5.2.tar.gz \
	&& cd xar-1.5.2 \
	&& ./configure \
	&& make \
	&& make install

# mac build support
RUN wget https://download.unity3d.com/download_unity/2285c3239188/MacEditorTargetInstaller/UnitySetup-Mac-Mono-Support-for-Editor-2020.1.1f1.pkg \
	&& xar -xf UnitySetup-Mac-Mono-Support-for-Editor-2020.1.1f1.pkg -C Editor/Data/PlaybackEngines/MacStandaloneSupport \
	&& rm UnitySetup-Mac-Mono-Support-for-Editor-2020.1.1f1.pkg

# above is not required
RUN apt install -y python-software-properties software-properties-common

RUN add-apt-repository ppa:git-core/ppa -y

RUN apt update

RUN apt install -y ssh zip curl git

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt install -y git-lfs

RUN git lfs install
