module inspect

import v.pref { Preferences }
import inspect.scanner
import cli { Command }

const (
	tokens_command = Command{
		name: 'tokens'
		description: 'print tokens'
		execute: fn (cmd Command) ? {
			println('he')
			paths := cmd.args
			prefs := new_prefs()
			scanner.inspect_tokens(paths, &prefs)
			return
		}
	}
)

