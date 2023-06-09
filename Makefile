PYTHON := ./venv/bin/python
.DEFAULT_GOAL := release

$(PYTHON): requirements.txt
	python3 -m venv venv
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install wheel
	$(PYTHON) -m pip install -r requirements.txt

.PHONY: clean release

clean:
	rm -rf venv

release: | $(PYTHON)
	./release.py
