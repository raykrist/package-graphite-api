NAME=graphite-api
VERSION=1.1.3
PACKAGE_VERSION=1
DESCRIPTION=Graphite-api with influxgraph
URL=https://graphite-api.readthedocs.io
MAINTAINER=github.com/raykrist
RELVERSION=7

.PHONY: default
default: deps build rpm
package: rpm

.PHONY: clean
clean:
	rm -fr /installdir
	rm -f $(NAME)-$(VERSION)-*.rpm
	rm -Rf vendor/

.PHONY: deps
deps:
	yum install -y gcc ruby-devel rpm-build
	gem install -N fpm
	yum install -y python-virtualenv libffi-devel cairo-devel

.PHONY: build
build:
	mkdir -p /installdir/opt/graphite-api
	virtualenv /installdir/opt/graphite-api
	/installdir/opt/graphite-api/bin/pip install --upgrade pip
	/installdir/opt/graphite-api/bin/pip install --upgrade setuptools
	/installdir/opt/graphite-api/bin/pip install graphite-api
	/installdir/opt/graphite-api/bin/pip install influxgraph

.PHONY: rpm
rpm:
	/usr/local/bin/fpm -s dir -t rpm \
		-n $(NAME) \
		-v $(VERSION) \
		--iteration "$(PACKAGE_VERSION).el$(RELVERSION)" \
		--description "$(DESCRIPTION)" \
		--url "$(URL)" \
		--maintainer "$(MAINTAINER)" \
		-d cairo \
		-C /installdir/ \
