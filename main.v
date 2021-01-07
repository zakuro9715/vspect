module main

import cli { Command }
import os { system, dir }
import v.vmod

fn v(cmd string) int {
	return system('VCOLORS=always ' + @VEXE + ' $cmd')
}

fn vv(cmd string) int {
	return system('vv $cmd')
}

fn new_app() Command {
	mod := vmod.decode(@VMOD_FILE) or { panic(err) }
	mut app := Command{
		name: mod.name
		description: mod.description
		version: mod.version
		disable_flags: true
		commands: [
			Command{
				name: 'bootstrap'
				description: 'make V'
				execute: fn (cmd Command) ? {
					exit(system('cd ${dir(@VEXE)} && make'))
				}
			},
			Command{
				name: 'self'
				description: 'self compilation'
				execute: fn (cmd Command) ? {
					mut code := v('self')
					println('Compiling vv...')
					code += v(dir(@FILE))
					exit(code)
				}
			},
			ci_command,
			inspect_command,
		]
	}
	app.setup()
	return app
}

fn main() {
	mut app := new_app()
	app.parse(os.args)
}
