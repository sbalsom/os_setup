echo "Starting setup"

# install xcode CLI
if test ! $(which xcode-select); then
    xcode-select —-install
fi

if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

PACKAGES=(
    ack
    asdf
    postgresql
    ffmpeg			
    pipenv
    chruby
    readline
    sbt
    scala
    git
    gh
    git-lfs
    hub
    wget
    imagemagick
    jq
    sqlite
    heroku
    node
    jenv
    yarn
    pyenv
)

brew install ${PACKAGES[@]}

brew link --force readline

echo "Installing Ruby gems"
RUBY_GEMS=(
    bundler
    byebug
    json
    rake
    rspec
)
sudo gem install ${RUBY_GEMS[@]}

echo "Installing cask..."
CASKS=(
    iterm2
    slack
    spotify
    visual-studio-code
    pgadmin4
    postman
    docker
    1password
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Configuring OS..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Linking dotfiles from https://github.com/sbalsom/dotfiles"

git clone git@github.com:sbalsom/dotfiles.git ~/code/dotfiles
rm ~/.rspec
ln -s code/dotfiles/.rspec ~/.rspec
rm ~/.aliases
ln -s code/dotfiles/.aliases ~/.aliases
rm ~/.gitconfig
ln -s code/dotfiles/.gitconfig ~/.gitconfig
rm ~/.irbrc
ln -s code/dotfiles/.irbrc ~/.irbrc
rm ~/.vimrc
ln -s code/dotfiles/.vimrc ~/.vimrc
rm ~/.zshrc
ln -s code/dotfiles/.zshrc ~/.zshrc

echo "Setting up git ssh key with your identity"
echo  "Which email do you use on github?"
read email
echo "Which name should appear on your commits?"
read name
git config --global user.email "$email"
git config --global user.name "$name"
mkdir -p ~/.ssh && ssh-keygen -t ed25519 -o -a 100 -f ~/.ssh/id_ed25519 -C "$email"
echo "Now copy the contents of ~/.ssh/id_ed25519.pub to GH: github.com/settings/ssh"
echo "Did you complete this step ? y/n"
read answer
if test "$answer" == "y" ; then
   gh auth login
fi

echo "User identity added to .gitconfig file located at ~/.gitconfig or ~/code/dotfiles/.gitconfig"
echo "To remove identifying info from git history in this directory, add #gitignore comment to these lines"
echo "Macbook setup completed!"
