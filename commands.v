module main

import cli { Command, Flag }
import v.pref { Preferences }
import ast
import tokens

fn new_prefs() &Preferences {
	mut prefs := &Preferences{}
	prefs.fill_with_defaults()
	prefs.is_fmt = true
	return prefs
}

fn get_opts(cmd Command) ast.InspectOpts {
	return ast.InspectOpts{
		func: cmd.flags.get_string('fn') or { '' }
		use_checker: cmd.flags.get_bool('use-checker') or { panic(err) }
		short_ident: cmd.flags.get_bool('short-ident') or { panic(err) }
		short_expr: cmd.flags.get_bool('short-expr') or { panic(err) }
		short_stmt: cmd.flags.get_bool('short-stmt') or { panic(err) }
		short_fn: cmd.flags.get_bool('short-fn') or { panic(err) }
	}
}

const (
	commands = [
		Command{
			name: 'ast'
			description: 'print AST'
			flags: [
				Flag{
					flag: .string
					name: 'fn'
					abbrev: 'f'
					description: 'Show only specified function'
				},
				Flag{
					flag: .bool
					name: 'short-ident'
					description: 'Omit ident details'
				},
				Flag{
					flag: .bool
					name: 'short-expr'
					description: 'Omit expr details'
				},
				Flag{
					flag: .bool
					name: 'short-stmt'
					description: 'Omit stmt details'
				},
				Flag{
					flag: .bool
					name: 'short-fn'
					description: 'Omit fn details'
				},
				Flag{
					flag: .bool
					name: 'use-checker'
					abbrev: 'c'
					description: 'Use checker'
				},
			]
			execute: fn (cmd Command) ? {
				paths := cmd.args
				prefs := new_prefs()
				ast.inspect(paths, prefs, get_opts(cmd))
				return
			}
		},
		Command{
			name: 'tokens'
			description: 'print tokens'
			execute: fn (cmd Command) ? {
				paths := cmd.args
				prefs := new_prefs()
				tokens.inspect_tokens(paths, prefs)
				return
			}
		},
	]
)
