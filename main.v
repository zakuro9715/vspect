module main

import cli { Command }
import os { system, dir }
import v.vmod

const self_cmd = Command{
		name: 'bootstrap'
		description: 'make V'
		execute: fn (cmd Command) ? {
			exit(system('cd ${dir(@VEXE)} && make'))
		}
	}

const bootstrap_cmd = Command{
		name: 'self'
		description: 'self compilation'
		execute: fn (cmd Command) ? {
			mut code := v('self')
			println('Compiling vv...')
			code += v(dir(@FILE))
			exit(code)
		}
	}

fn new_app() Command {
	mod := vmod.decode(@VMOD_FILE) or { panic(err) }
	mut app := Command{
		name: mod.name
		description: mod.description
		version: mod.version
		disable_flags: true
		commands: [self_cmd, bootstrap_cmd, inspect_cmd]
	}
	app.setup()
	return app
}

fn main() {
	mut app := new_app()
	app.parse(os.args)
}
