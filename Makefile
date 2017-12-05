all: clean prepare test
	
doc:
	apigen generate --source src --destination doc --title "pohoda XML" --charset "UTF-8" --access-levels public --access-levels protected --php --tree

prepare:
	composer install
	  
test:
	vendor/bin/phpspec run --config=phpspec.yml

clean:
	rm -rfv vendor/* doc/*
	
	