module main

import cli { Command }
import os
import v.vmod

fn setup_app(mut app Command) {
	mut ci := Command{
		name: 'ci'
		description: 'Run ci tests'
	}
	ci.add_commands([
		Command{
			name: 'cleancode'
			description: 'test-cleancode'
			execute: fn (cmd Command) ? {
				exit(os.system('VCOLORS=always v test-cleancode'))
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
