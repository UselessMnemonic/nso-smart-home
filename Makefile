PACKAGE_NAME = nso-smart-home
NCS_TEST_DIR = test/ncs

NCS_VERSION=$(shell ncs --version)
NCS_PACKAGES=$(NCS_TEST_DIR)/packages

ARCHIVE_FILENAME = ncs-$(NCS_VERSION)-$(PACKAGE_NAME).tar.gz
ARCHIVE_INCLUDE = load-dir private-jar shared-jar package-meta-data.xml

build:
	make -C src
	tar -C .. -czf $(ARCHIVE_FILENAME) $(addprefix $(PACKAGE_NAME)/,$(ARCHIVE_INCLUDE))

clean:
	rm -f $(ARCHIVE_FILENAME)
	rm -rf $(NCS_TEST_DIR)
	make -C src clean

test: build $(NCS_TEST_DIR)
	cp -f $(ARCHIVE_FILENAME) $(NCS_PACKAGES)
	make -C test test

clean-test:
	make -C test clean

run-ncs: build $(NCS_TEST_DIR)
	cp -f $(ARCHIVE_FILENAME) $(NCS_PACKAGES)
	ncs --cd $(NCS_TEST_DIR) --with-package-reload

$(NCS_TEST_DIR):
	ncs-setup --dest $(NCS_TEST_DIR) --no-netsim

.PHONY: build clean test clean-test run-ncs
