#!/bin/bash -e

VERSION=2.7.3

# forked from https://gist.github.com/1256593

# Update, upgrade and install development tools:
sudo apt-get -y install build-essential libssl-dev git-core  libreadline-dev


DIR=/usr/local/rbenv

# Install rbenv
git clone git://github.com/rbenv/rbenv.git $DIR

# rbenv plugins
mkdir -p ${DIR}/plugins
git clone https://github.com/sstephenson/rbenv-default-gems.git ${DIR}/plugins/rbenv-default-gems
echo "bundler" > ${DIR}/default-gems
# git clone https://github.com/ianheggie/rbenv-binstubs.git  ${DIR}/plugins/rbenv-binstubs
git clone https://github.com/sstephenson/rbenv-gem-rehash.git ${DIR}/plugins/rbenv-gem-rehash

# Add rbenv to the path:
if [ ! -f /etc/profile.d/rbenv.sh ]; then
  echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
	echo '# rbenv setup' > /etc/profile.d/rbenv.sh
	echo "export RBENV_ROOT=${DIR}" >> /etc/profile.d/rbenv.sh
	echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
	echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
fi

sudo chmod +x /etc/profile.d/rbenv.sh
source /etc/profile.d/rbenv.sh

# Install ruby-build:
pushd /tmp
	rm -rf ruby-build
	git clone git://github.com/sstephenson/ruby-build.git
	cd ruby-build
	./install.sh
popd

# export CFLAGS="-march=native -O3 -pipe " #"-fomit-frame-pointer"

echo CFLAGS: $CFLAGS
# Install Ruby
CONFIGURE_OPTS="--disable-install-doc" rbenv install $VERSION
rbenv global $VERSION

if [ -d /usr/local/bin ]; then
	pushd /usr/local/bin
		ln -sf ${DIR}/shims/ruby
		ln -sf ${DIR}/shims/gem
		ln -sf ${DIR}/shims/bundle
	popd
fi

# Rehash:
rbenv rehash
gem install bundler
rbenv rehash



# echo "You can install 1.9.3-p327-perf by copypasting"
# echo 'curl https://raw.github.com/gist/1688857/rbenv.sh | sh ; rbenv global 1.9.3-p327-perf'


