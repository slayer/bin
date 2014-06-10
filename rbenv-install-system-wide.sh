#!/bin/bash -e

# forked from https://gist.github.com/1256593

# Update, upgrade and install development tools:
apt-get update
apt-get -y upgrade
apt-get -y install build-essential libssl-dev git-core

DIR=/usr/local/rbenv

# Install rbenv
git clone git://github.com/sstephenson/rbenv.git $DIR

# rbenv plugins
mkdir -p ${DIR}/plugins
git clone https://github.com/sstephenson/rbenv-default-gems.git ${DIR}/plugins/rbenv-default-gems
echo "bundler" > ${DIR}/default-gems
# git clone https://github.com/ianheggie/rbenv-binstubs.git  ${DIR}/plugins/rbenv-binstubs

# Add rbenv to the path:
if [ ! -f /etc/profile.d/rbenv.sh ]; then
	echo '# rbenv setup' > /etc/profile.d/rbenv.sh
	echo "export RBENV_ROOT=${DIR}" >> /etc/profile.d/rbenv.sh
	echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
	echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
fi

chmod +x /etc/profile.d/rbenv.sh
source /etc/profile.d/rbenv.sh

grep CFLAGS /etc/environment || (
  echo export CFLAGS=\"-march=native -O3 -pipe -fomit-frame-pointer\" >>/etc/environment
	# echo "######################################"
  # echo export RUBY_GC_HEAP_INIT_SLOTS=600000 >>/etc/environment
  # echo export RUBY_GC_HEAP_FREE_SLOTS=600000 >>/etc/environment
  # echo export RUBY_GC_HEAP_GROWTH_FACTOR=1.25 >>/etc/environment
  # echo export RUBY_GC_HEAP_GROWTH_MAX_SLOTS=300000 >>/etc/environment

)

# Install ruby-build:
pushd /tmp
	rm -rf ruby-build
	git clone git://github.com/sstephenson/ruby-build.git
	cd ruby-build
	./install.sh
popd

export CFLAGS="-march=native -O3 -pipe -fomit-frame-pointer"

# Install Ruby
rbenv install 2.1.2
rbenv global 2.1.2

if [ -d ${DIR}/../bin ]; then
	pushd ${DIR}/../bin
		ln -sf ../rbenv/shims/ruby
		ln -sf ../rbenv/shims/gem
		ln -sf ../rbenv/shims/bundle
	popd
fi

# Rehash:
rbenv rehash
gem install bundler
rbenv rehash



# echo "You can install 1.9.3-p327-perf by copypasting"
# echo 'curl https://raw.github.com/gist/1688857/rbenv.sh | sh ; rbenv global 1.9.3-p327-perf'


