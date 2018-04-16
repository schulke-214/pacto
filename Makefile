.PHONY:  docs validate tests coverage build build_sem build_umd build_min


docs:
	node_modules/.bin/doxdox \
		'src/**/*.js' \
		--layout markdown \
		--output DOCUMENTATION.md

	node_modules/.bin/doctoc \
		./README.md


validate:
	eslint \
		. \
		--ext .js


tests:
	jest \
		src \
		--coverage \
		--verbose


coverage:
	node_modules/.bin/codecov

	cat \
		./coverage/lcov.info \
		| node_modules/.bin/coveralls


build: build_esm build_umd build_min
	jest \
		tests \
		--verbose


build_esm:
	node_modules/.bin/rollup \
		src/index.js \
		--format es \
		--file dist/pacto.esm.js


build_umd:
	node_modules/.bin/rollup \
		src/index.js \
		--format umd \
		--name 'pacto' \
		--file dist/pacto.umd.js

	# @TODO: enable "modules = false" in preset env to bundle umd correctly
	node_modules/.bin/babel \
		dist/pacto.umd.js \
		--out-file dist/pacto.umd.js


build_min:
	node_modules/.bin/rollup \
		src/index.js \
		--format umd \
		--name 'pacto' \
		--file dist/pacto.min.js

	# @TODO: enable "modules = false" in preset env to bundle umd correctly
	node_modules/.bin/babel \
		dist/pacto.min.js \
		--out-file dist/pacto.min.js

	node_modules/.bin/uglifyjs \
		dist/pacto.min.js \
		--compress \
		--mangle \
		--output dist/pacto.min.js
