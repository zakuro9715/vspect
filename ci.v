module main

import cli { Command }
import os { dir }

const (
	ci_command = Command{
		name: 'ci'
		description: 'Run ci tests'
		commands: [
			Command{
				name: 'all'
				description: 'test-fixed'
				execute: fn (cmd Command) ? {
					exit(vv('ci cleancode') + vv('ci fixed') + vv('ci fmt') + vv('ci examples') +
						vv('ci tools') + vv('ci md'))
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
				name: 'md'
				description: 'check-md'
				execute: fn (cmd Command) ? {
					exit(v('run ${dir(@VEXE)}/cmd/tools/check-md.v -all'))
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
			Command{
				name: 'tools'
				description: 'build-tools'
				execute: fn (cmd Command) ? {
					exit(v('build-tools'))
				}
			},
		]
	}
)
