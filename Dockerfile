FROM ubuntu:16.04

WORKDIR /unity

RUN apt update

RUN apt install -y wget xz-utils cpio zip

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
	&& xar -xf mac-support.pkg \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/MacStandaloneSupport \
	&& cd /unity/Editor/Data/PlaybackEngines/MacStandaloneSupport \
	&& cat /tmp/TargetSupport.pkg.tmp/Payload | gunzip -dc | cpio -i \
	&& rm -r /tmp/*
	
# windows build support
RUN cd /tmp \
	&& wget https://download.unity3d.com/download_unity/2285c3239188/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-2020.1.1f1.pkg -O windows-support.pkg \
	&& xar -xf windows-support.pkg \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/WindowsStandaloneSupport \
	&& cd /unity/Editor/Data/PlaybackEngines/WindowsStandaloneSupport \
	&& cat /tmp/TargetSupport.pkg.tmp/Payload | gunzip -dc | cpio -i \
	&& rm -r /tmp/*

# android build support
RUN cd /tmp \
	&& wget https://download.unity3d.com/download_unity/2285c3239188/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-2020.1.1f1.pkg -O android-support.pkg \
	&& xar -xf android-support.pkg \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/AndroidPlayer \
	&& cd /unity/Editor/Data/PlaybackEngines/AndroidPlayer \
	&& cat /tmp/TargetSupport.pkg.tmp/Payload | gunzip -dc | cpio -i \
	&& rm -r /tmp/*

# android open jdk
RUN cd /tmp \
	&& wget http://download.unity3d.com/download_unity/open-jdk/open-jdk-linux-x64/jdk8u172-b11_4be8440cc514099cfe1b50cbc74128f6955cd90fd5afe15ea7be60f832de67b4.zip -O android-jdk.zip \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/AndroidPlayer/OpenJDK \
	&& cd /unity/Editor/Data/PlaybackEngines/AndroidPlayer/OpenJDK \
	&& unzip /tmp/android-jdk.zip \
	&& rm -r /tmp/*

# android ndk tools
RUN cd /tmp \
	&& wget https://dl.google.com/android/repository/android-ndk-r19-linux-x86_64.zip -O android-ndk.zip \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/AndroidPlayer/NDK/android-ndk-r19 \
	&& cd /unity/Editor/Data/PlaybackEngines/AndroidPlayer/NDK/android-ndk-r19 \
	&& unzip /tmp/android-ndk.zip \
	&& rm -r /tmp/*

# android sdk platforms
RUN cd /tmp \
	&& wget https://dl.google.com/android/repository/platform-28_r06.zip -O android-sdk-platforms.zip \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/platforms \
	&& cd /unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/platforms \
	&& unzip /tmp/android-sdk-platforms.zip \
	&& mv android-9 android-28 \
	&& rm -r /tmp/*

# android sdk build tools
RUN cd /tmp \
	&& wget https://dl.google.com/android/repository/build-tools_r28.0.3-linux.zip -O android-sdk-build-tools.zip \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/build-tools \
	&& cd /unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/build-tools \
	&& unzip /tmp/android-sdk-build-tools.zip \
	&& mv android-9 28.0.3 \
	&& rm -r /tmp/*

# android sdk platform tools
RUN cd /tmp \
	&& wget https://dl.google.com/android/repository/build-tools_r28.0.3-linux.zip -O android-sdk-platform-tools.zip \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK \
	&& cd /unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK \
	&& unzip /tmp/android-sdk-platform-tools.zip \
	&& rm -r /tmp/*
	
# android sdk ndk tools
RUN cd /tmp \
	&& wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android-sdk-ndk-tools.zip \
	&& mkdir -p /unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK \
	&& cd /unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK \
	&& unzip /tmp/android-sdk-ndk-tools.zip \
	&& rm -r /tmp/*
	
# ios build support
RUN cd /tmp \
	&& wget https://download.unity3d.com/download_unity/2285c3239188/LinuxEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-2020.1.1f1.tar.xz -O ios-support.tar.xz \
	&& xz -d ios-support.tar.xz \
	&& cd /unity \
	&& tar -xf /tmp/ios-support.tar \
	&& rm -r /tmp/*

# above is not required
RUN apt install -y python-software-properties software-properties-common

RUN add-apt-repository ppa:git-core/ppa -y

RUN apt update

RUN apt install -y ssh zip curl git

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt install -y git-lfs

RUN git lfs install
