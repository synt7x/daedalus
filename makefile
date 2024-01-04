release/daedalus.lua:
	bin/clamp main.lua -o release/daedalus.lua

PHONY: clean build publish

clean:
	del release\daedalus.lua

build: clean release/daedalus.lua