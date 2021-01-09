module main

import cli { Command }
import os { system, dir }
import v.vmod

const self_cmd = Command{
		name: 'self'
		description: 'self compilation'
		execute: fn (cmd Command) ? {
			println('Compiling vv...')
			exit(v(dir(@FILE)))
		}
	}

fn new_app() Command {
	mod := vmod.decode(@VMOD_FILE) or { panic(err) }
	mut app := Command{
		name: mod.name
		description: mod.description
		version: mod.version
		disable_flags: true
		commands: [self_cmd, inspect_cmd]
	}
	app.setup()
	return app
}

fn main() {
	mut app := new_app()
	app.parse(os.args)
}
