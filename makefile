release/daedalus.lua:
	clamp main.lua -o release/daedalus.lua

release/client.lua:
	copy client.lua release\client.lua

PHONY: clean build

clean:
	del release\daedalus.lua
	del release\client.lua

build: clean release/daedalus.lua release/client.lua