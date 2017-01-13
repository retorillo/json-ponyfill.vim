pack:
	if [ ! -d dist ]; then mkdir dist; fi
	cd .. && zip -r json.vim/dist/json.vim.zip json.vim/autoload
	cd .. && unzip -l json.vim/dist/json.vim.zip
