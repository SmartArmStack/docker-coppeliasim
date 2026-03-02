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

# Download and run sas coppeliasim install script
ARG COPPELIASIM_TAG=coppeliasim-v4.10.0-rev0
ARG COPPELIASIM_INSTALL_FOLDER=/root/sas_install/coppelia_install
RUN mkdir -p "$COPPELIASIM_INSTALL_FOLDER"
RUN cd "$COPPELIASIM_INSTALL_FOLDER" && git clone --depth 1 --branch "$COPPELIASIM_TAG" https://github.com/CoppeliaRobotics/coppeliaSimLib.git
RUN mkdir -p "$COPPELIASIM_INSTALL_FOLDER/programming"
RUN cd "$COPPELIASIM_INSTALL_FOLDER/programming" && git clone --depth 1 --branch "$COPPELIASIM_TAG" https://github.com/CoppeliaRobotics/include.git

RUN mkdir -p "$COPPELIASIM_INSTALL_FOLDER/coppeliaSimLib/build"
RUN cd "$COPPELIASIM_INSTALL_FOLDER/coppeliaSimLib/build" && cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DQSCINTILLA_DIR=/usr/include/aarch64-linux-gnu/qt5/Qsci \
    -DQSCINTILLA_LIBRARY=/usr/lib/aarch64-linux-gnu/libqscintilla2_qt5.so
RUN cd "$COPPELIASIM_INSTALL_FOLDER/coppeliaSimLib/build" && cmake --install .