PYTHON := ./venv/bin/python
.DEFAULT_GOAL := run

$(PYTHON): requirements.txt
	python3 -m venv venv
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install wheel
	$(PYTHON) -m pip install -r requirements.txt

.PHONY: run clean

run: | $(PYTHON)
	./release.py

clean:
	rm -rf venv
