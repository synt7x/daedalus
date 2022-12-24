release/daedalus.lua:
	clamp main.lua -o release/daedalus.lua

PHONY: clean build

clean:
	del release\daedalus.lua

build: clean release/daedalus.lua