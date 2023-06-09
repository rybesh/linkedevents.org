PYTHON := ./venv/bin/python
LATEST := 2020-10-31
.DEFAULT_GOAL := release

$(PYTHON): requirements.txt
	python3 -m venv venv
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install wheel
	$(PYTHON) -m pip install -r requirements.txt

.PHONY: clean release deploy

clean:
	rm -rf venv

release: | $(PYTHON)
	./release.py

deploy:
	rm -rf site
	mkdir site
	cp -R ontology style.css site/
	ln -s $(LATEST)/index.ttl site/ontology/
	ln -s $(LATEST)/index.rdf site/ontology/
	ln -s $(LATEST)/index.html site/ontology/
	flyctl deploy
