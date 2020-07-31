all: freeze doc

freeze:
	@dhall freeze --all --inplace package.dhall

doc:
	@python3 scripts/doc.py

update-doc: all
	@dhall-docs --input . --package-name dhall-zuul --output-link result --ascii

publish: update-doc
	@rsync --delete -r result/ docs/
	@find docs/ -type d -exec chmod 0755 {} +
	@find docs/ -type f -exec chmod 0644 {} +
	@rsync --exclude .zuul.yaml --exclude .gitreview --exclude _build --exclude .git --delete -avi ./docs/ pagesuser@www.softwarefactory-project.io:/var/www/pages/docs.softwarefactory-project.io/dhall-containerfile/
