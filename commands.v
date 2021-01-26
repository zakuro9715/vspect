module main

import cli { Command, Flag }
import v.pref { Preferences }
import ast
import tokens

fn new_prefs() pref.Preferences {
	mut prefs := Preferences{}
	prefs.fill_with_defaults()
	prefs.is_fmt = true
	return prefs
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
					name: 'use-checker'
					abbrev: 'c'
					description: 'Use checker'
					init: true
					value: ['true']
				},
			]
			execute: fn (cmd Command) ? {
				paths := cmd.args
				prefs := new_prefs()
				func := cmd.flags.get_string('fn') or { '' }
				use_checker := cmd.flags.get_bool('use-checker') or { true }
				short_ident := cmd.flags.get_bool('short-ident') or { false }
				short_expr := cmd.flags.get_bool('short-expr') or { false }
				opts := ast.InspectOpts{
					func: func
					use_checker: use_checker
					short_ident: short_ident
					short_expr: short_expr
				}
				ast.inspect(paths, prefs, opts)
				return
			}
		},
		Command{
			name: 'tokens'
			description: 'print tokens'
			execute: fn (cmd Command) ? {
				paths := cmd.args
				prefs := new_prefs()
				tokens.inspect_tokens(paths, &prefs)
				return
			}
		},
	]
)
