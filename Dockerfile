FROM osrf/ros:humble-desktop-full

RUN apt-get update \
    && apt-get install -y \
    nano \
    vim \
    bash-completion \
    python3-argcomplete \
    ros-humble-gazebo-ros-pkgs \
    && rm -rf /var/lib/apt/lists/*

COPY config/ /site_config

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# Programs for testing devices
RUN apt-get update \
    && apt-get install -y \
    evtest \
    jstest-gtk \
    python3-serial \
    && rm -rf /var/lib/apt/lists/*

# Set up sudo
RUN apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*


# USER ros
# # Any instruction below will be issued as that user


# USER root
# # Any instruction below will be issued as root again

COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/$USERNAME/.bashrc

ENTRYPOINT ["bin/bash", "/entrypoint.sh"]

#  We just added bash for now to have a working terminal
CMD ["bash"]