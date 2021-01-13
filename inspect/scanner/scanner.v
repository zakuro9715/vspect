module scanner

import v.pref { Preferences }
import v.scanner
import v.token

import cli { Command }

type Scanner = scanner.Scanner

pub fn new(path string, prefs &pref.Preferences) &Scanner {
	return scanner.new_scanner_file(path, .parse_comments, prefs)
}

type TokenFn = fn(token.Token)?
pub fn (mut s Scanner) each_token(f TokenFn) ? {
	for {
		t := s.scan()
		f(t) ?
		if t.kind == .eof {
			return
		}
	}
}
