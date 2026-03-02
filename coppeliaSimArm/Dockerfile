FROM murilomarinho/sas:jazzy
SHELL ["/bin/bash", "-c"]
ENV BASH_ENV="/etc/bash_env"

RUN sudo apt-get update -q  \
    && sudo apt-get upgrade -y  \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/*

RUN sudo apt-get update -q
RUN sudo apt-get install -y lua5.3 liblua5.3-dev
RUN sudo apt-get install -y libqscintilla2-qt5-dev

# [START] Install CoppeliaSim x64
ARG COPPELIASIM_RELEASE=V4_10_0_rev0
ARG UBUNTU_VERSION=Ubuntu24_04
ARG BRANCH=main

ENV COPPELIASIM_RELEASE=$COPPELIASIM_RELEASE
ENV UBUNTU_VERSION=$UBUNTU_VERSION
ARG COPPELIASIM_FILE="CoppeliaSim_Edu_${COPPELIASIM_RELEASE}_${UBUNTU_VERSION}.tar.xz"
ENV COPPELIASIM_FILE=$COPPELIASIM_FILE

RUN apt-get install -y curl
RUN mkdir -p ~/sas_install/coppelia_install/ \
&& cd ~/sas_install/coppelia_install/ \
&& curl -OL "https://raw.githubusercontent.com/SmartArmStack/docker-coppeliasim/refs/heads/${BRANCH}/scripts/setup_coppeliasim.sh" \
&& chmod +x setup_coppeliasim.sh \
&& bash -c "./setup_coppeliasim.sh"
# [END] Install CoppeliaSim x64

# [START] CoppeliaSim arm64 build
ARG COPPELIASIM_TAG=coppeliasim-v4.10.0-rev0
ARG COPPELIASIM_BUILD_FOLDER=/root/sas_install/coppelia_build

COPY coppeliasim.repos "$COPPELIASIM_BUILD_FOLDER"/
RUN cd "$COPPELIASIM_BUILD_FOLDER" && sed -i -e "s/COPPELIASIM_TAG/$COPPELIASIM_TAG/g" coppeliasim.repos
RUN mkdir -p "$COPPELIASIM_BUILD_FOLDER/src"
RUN cd "$COPPELIASIM_BUILD_FOLDER" && vcs import src < coppeliasim.repos

RUN mkdir -p "$COPPELIASIM_BUILD_FOLDER/src/programming"
RUN cd $COPPELIASIM_BUILD_FOLDER/src && mv include programming/include

RUN cd $COPPELIASIM_BUILD_FOLDER && colcon build --packages-select coppeliaSim --cmake-args \
-DCMAKE_BUILD_TYPE=Release \
-DINSTALL_DIR=$COPPELIASIM_PATH \
-DLUA_LIBRARIES=/usr/lib/aarch64-linux-gnu/liblua5.3.so \
-DLUA_INCLUDE_DIR=/usr/include/lua5.3 \
-DQSCINTILLA_DIR=/usr/include/aarch64-linux-gnu/qt5/Qsci \
-DQSCINTILLA_LIBRARY=/usr/lib/aarch64-linux-gnu/libqscintilla2_qt5.so

RUN rm -r $COPPELIASIM_PATH/programming
RUN cd $COPPELIASIM_BUILD_FOLDER && colcon build --packages-select simClientApplication --cmake-args \
-DCOPPELIASIM_INCLUDE_DIR="$COPPELIASIM_BUILD_FOLDER/src/programming/include" \
-DCMAKE_BUILD_TYPE=Release \
-DINSTALL_DIR=$COPPELIASIM_PATH \
-DCOPPELIASIM_LIBRARY=$COPPELIASIM_PATH

RUN sudo apt-get update -q && sudo apt-get install -y xsltproc
COPY SciLexer.h "$COPPELIASIM_BUILD_FOLDER/src/programming/include"
RUN cd $COPPELIASIM_BUILD_FOLDER && colcon build --packages-select simCodeEditor --cmake-args \
-DCOPPELIASIM_INCLUDE_DIR="$COPPELIASIM_BUILD_FOLDER/src/programming/include" \
-DCMAKE_BUILD_TYPE=Release \
-DQSCINTILLA_DIR=/usr/include/aarch64-linux-gnu/qt5/Qsci \
-DQSCINTILLA_LIBRARY=/usr/lib/aarch64-linux-gnu/libqscintilla2_qt5.so

#RUN cd $COPPELIASIM_BUILD_FOLDER && colcon build --packages-select simCmd --cmake-args \
#-DCOPPELIASIM_INCLUDE_DIR="$COPPELIASIM_BUILD_FOLDER/src/programming/include" \
#-DCMAKE_BUILD_TYPE=Release \
#-DQSCINTILLA_DIR=/usr/include/aarch64-linux-gnu/qt5/Qsci \
#-DQSCINTILLA_LIBRARY=/usr/lib/aarch64-linux-gnu/libqscintilla2_qt5.so

RUN sudo apt-get update -q && sudo apt install -y luarocks
RUN rm -r $COPPELIASIM_PATH/luar && mkdir -p $COPPELIASIM_PATH/luar
RUN luarocks --tree $COPPELIASIM_PATH/luar install lpeg
RUN luarocks --tree $COPPELIASIM_PATH/luar install lpeglabel
RUN luarocks --tree $COPPELIASIM_PATH/luar install lua-parser
RUN luarocks --tree $COPPELIASIM_PATH/luar install luasocket
RUN luarocks --tree $COPPELIASIM_PATH/luar install org.conman.cbor

#RUN cd $COPPELIASIM_BUILD_FOLDER && colcon build --packages-select BULLET_PHYSICS --cmake-args \
#    -DCMAKE_CXX_FLAGS="-Wno-narrowing"

#COPY simDyn/CMakeLists.txt "$COPPELIASIM_BUILD_FOLDER/src/simExtDyn"
#RUN cd $COPPELIASIM_BUILD_FOLDER && colcon build --packages-select simDyn --cmake-args \
#    -DCOPPELIASIM_INCLUDE_DIR="$COPPELIASIM_BUILD_FOLDER/src/programming/include" \
#    -DCMAKE_BUILD_TYPE=Release
