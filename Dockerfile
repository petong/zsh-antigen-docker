FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    sudo \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev \
    zsh

# Install Starship prompt
RUN sudo curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Set Zsh as the default shell
RUN chsh -s /bin/zsh

# Create a non-root user
RUN useradd -m -s /bin/zsh devops
USER devops
WORKDIR /home/devops

# Install pyenv
RUN curl https://pyenv.run | bash


# Copy dotfiles
COPY --chown=devops:devops zshrc .zshrc
COPY --chown=devops:devops zsh_plugins.txt .zsh_plugins.txt

# Set the entrypoint to Zsh
ENTRYPOINT ["/bin/zsh"]
