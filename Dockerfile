# Base image
FROM node:20.17.0

# Install system dependencies, including Zsh, curl, git, fonts utilities, and Ruby
RUN apt-get update && apt-get install -y \
  zsh \
  curl \
  git \
  vim \
  fonts-powerline \
  ruby-full \
  && gem install bundler \
  && rm -rf /var/lib/apt/lists/*

# Set Zsh as the default shell
RUN chsh -s $(which zsh)

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k theme into the correct directory
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set Powerlevel10k as the default theme in .zshrc
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

# Download MesloLGS Nerd Fonts for Powerlevel10k
RUN mkdir -p ~/.local/share/fonts && \
    curl -fLo ~/.local/share/fonts/MesloLGS_NF_Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf && \
    curl -fLo ~/.local/share/fonts/MesloLGS_NF_Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf && \
    curl -fLo ~/.local/share/fonts/MesloLGS_NF_Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf && \
    curl -fLo ~/.local/share/fonts/MesloLGS_NF_Bold_Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf && \
    fc-cache -fv

# Install Shopify CLI globally
RUN npm install -g @shopify/cli @shopify/theme

# Add Shopify CLI alias to .zshrc for easier usage
RUN echo 'alias dev="shopify theme dev --theme=\$SHOPIFY_FLAG_THEME_ID --store=\$SHOPIFY_FLAG_STORE --host=\$SHOPIFY_FLAG_HOST --port=\$SHOPIFY_FLAG_PORT"' >> ~/.zshrc

# Add Powerlevel10k configuration to .zshrc
RUN echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

# Set the working directory
WORKDIR /theme

# Set Zsh as the default shell when the container starts
CMD ["zsh"]
