all: clean prepare test
	
doc:
	apigen generate --source src --destination doc --title "pohoda XML" --charset "UTF-8" --access-levels public --access-levels protected --php --tree

prepare:
	composer install
	  
test:
	vendor/bin/php-cs-fixer fix --config=.php_cs.dist --verbose --diff --dry-run
	vendor/bin/phpstan analyse -c phpstan.neon --level max src
	vendor/bin/phpspec run --config=phpspec.yml

clean:
	rm -rfv vendor/* doc/*
	
	