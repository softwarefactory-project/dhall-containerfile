all: freeze doc

freeze:
	dhall freeze --all --inplace package.dhall

doc:
	@python3 scripts/doc.py
