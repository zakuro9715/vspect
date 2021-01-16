module scanner

import v.pref { Preferences }
import v.scanner
import v.token
import cli { Command }

type Scanner = scanner.Scanner

pub fn new(path string, prefs &pref.Preferences) &Scanner {
	return scanner.new_scanner_file(path, .parse_comments, prefs)
}

pub fn inspect_tokens(paths []string, prefs &pref.Preferences) {
	for path in paths {
		mut scanner := new(path, prefs)
		println('===== $path =====')
		for {
			tok := scanner.scan()
			line, mut col := tok.line_nr, tok.pos - scanner.last_nl_pos
			if line == 1 {
				col++
			}
			println("${line:4}, ${col:2}  |  ${tok.kind:-8}  | '$tok.lit'")
			if tok.kind == .eof {
				break
			}
		}
		println('===== END =====')
	}
}
