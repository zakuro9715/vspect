module main

import cli { Command }
import os { system }
import v.vmod

fn v(cmd string) int {
	return system('VCOLORS=always ' + @VEXE + ' $cmd')
}

fn vv(cmd string) int {
	return system('vv $cmd')
}

fn setup_app(mut app Command) {
	mut ci := Command{
		name: 'ci'
		description: 'Run ci tests'
	}
	ci.add_commands([
		Command{
			name: 'all'
			description: 'test-fixed'
			execute: fn (cmd Command) ? {
				exit(vv('ci cleancode') + vv('ci fixed') + vv('ci fmt') + vv('ci examples'))
			}
		},
		Command{
			name: 'fmt'
			description: 'test-fmt'
			execute: fn (cmd Command) ? {
				exit(v('test-fmt'))
			}
		},
		Command{
			name: 'cleancode'
			description: 'test-cleancode'
			execute: fn (cmd Command) ? {
				exit(v('test-cleancode'))
			}
		},
		Command{
			name: 'fixed'
			description: 'test-fixed'
			execute: fn (cmd Command) ? {
				exit(v('test-fixed'))
			}
		},
		Command{
			name: 'examples'
			description: 'build-examples'
			execute: fn (cmd Command) ? {
				exit(v('build-examples'))
			}
		},
	])
	app.add_commands([ci])
}

fn main() {
	mod := vmod.decode(@VMOD_FILE) or { panic(err) }
	mut app := Command{
		name: mod.name
		description: mod.description
		version: mod.version
		disable_flags: true
	}
	setup_app(mut app)
	app.parse(os.args)
}
