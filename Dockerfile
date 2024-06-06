FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

# Install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    curl \
    git \
    neovim \
    sudo \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev \
    zsh \ 
    fontconfig \
    unzip \
    python3-openssl \
    && rm -rf /var/lib/apt/lists/*


# Install Starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Set Zsh as the default shell
RUN chsh -s /bin/zsh

# Create a non-root user and add it to the sudo group
RUN useradd -m -s /bin/zsh -G sudo devops

# Configure sudo to allow the devops user to run commands without a password
RUN echo 'devops ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER devops

WORKDIR /home/devops

# Install Inconsolata Nerd Font
RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Inconsolata.zip \
    && mkdir -p ~/.local/share/fonts \
    && unzip Inconsolata.zip -d ~/.local/share/fonts \
    && fc-cache -fv \
    && rm -rf Inconsolata.zip


RUN curl https://pyenv.run | bash

RUN mkdir -p .config
# Copy dotfiles
COPY --chown=devops:devops zshrc ./.zshrc
COPY --chown=devops:devops zsh_plugins.txt ./.zsh_plugins.txt
COPY --chown=devops:devops starship.toml ./.starship.toml
COPY --chown=devops:devops jay.starship ./.config/starship.toml

# Set the entrypoint to Zsh
ENTRYPOINT ["/bin/zsh"]
