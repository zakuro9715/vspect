module main

import cli { Command }
import os { system }
import v.vmod

fn setup_app(mut app Command) {
	mut ci := Command{
		name: 'ci'
		description: 'Run ci tests'
		execute: fn (cmd Command) ? {
			exit(system('vv ci cleancode') + system('vv ci fixed'))
		}
	}
	ci.add_commands([
		Command{
			name: 'cleancode'
			description: 'test-cleancode'
			execute: fn (cmd Command) ? {
				exit(system('VCOLORS=always v test-cleancode'))
			}
		},
		Command{
			name: 'fixed'
			description: 'test-fixed'
			execute: fn (cmd Command) ? {
				exit(system('VCOLORS=always v test-fixed'))
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
