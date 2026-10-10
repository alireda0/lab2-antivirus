DIR = test_dir
MALICIOUS_DIR = quarantine
INTERVAL = 5

.PHONY: all prepare run restore clean

all: prepare
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

prepare:
	mkdir -p $(DIR)
	mkdir -p $(MALICIOUS_DIR)

run: prepare
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

restore: prepare
	./restore.sh $(DIR) $(MALICIOUS_DIR)

clean:
	rm -f directory-info.*
