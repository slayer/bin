#!/bin/bash -e

# forked from https://gist.github.com/1256593

# Update, upgrade and install development tools:
apt-get update
apt-get -y upgrade
apt-get -y install build-essential
apt-get -y install git-core

# Install rbenv
git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv

# Add rbenv to the path:
echo '# rbenv setup' > /etc/profile.d/rbenv.sh
echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

chmod +x /etc/profile.d/rbenv.sh
source /etc/profile.d/rbenv.sh

grep CFLAGS /etc/environment || (
  echo export CFLAGS="-march=native -O3 -pipe -fomit-frame-pointer" >>/etc/environment
  echo export RUBY_GC_MALLOC_LIMIT=60000000 >>/etc/environment
  echo export RUBY_FREE_MIN=200000 >>/etc/environment
)

# Install ruby-build:
pushd /tmp
	rm -rf ruby-build
	git clone git://github.com/sstephenson/ruby-build.git
	cd ruby-build
	./install.sh
popd

# Install Ruby 1.9.2-p290:
# rbenv install 1.9.2-p290
# rbenv global 1.9.2-p290

# Rehash:
rbenv rehash
gem install bundler
rbenv rehash

pushd /usr/local/bin
  ln -sf ../rbenv/shims/gem
  ln -sf ../rbenv/shims/bundle
popd

echo "You can install 1.9.3-p327-perf by copypasting"
echo 'curl https://raw.github.com/gist/1688857/rbenv.sh | sh ; rbenv global 1.9.3-p327-perf'


