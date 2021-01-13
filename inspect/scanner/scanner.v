module scanner

import v.pref { Preferences }
import v.scanner
import v.token
import cli { Command }

type Scanner = Scanner

pub fn new(path string, prefs &pref.Preferences) &Scanner {
	return scanner.new_scanner_file(path, .parse_comments, prefs)
}

type TokenFn = fn (token.Token) ?

pub fn (mut s Scanner) each_token(f TokenFn) ? {
	for {
		t := s.scan()
		f(t) ?
		if t.kind == .eof {
			return
		}
	}
}

pub fn inspect_tokens(paths []string, prefs &pref.Preferences) {
	for path in paths {
		mut scanner := new(path, prefs)
		println('===== $path =====')
		for {
			tok := scanner.scan()
			line, col := tok.line_nr, tok.pos - scanner.last_nl_pos
			println("$line, $col: $tok.kind '$tok.lit'")
			if tok.kind == .eof {
				break
			}
		}
		println('===== END =====')
	}
}
