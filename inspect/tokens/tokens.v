module tokens

import v.pref { Preferences }
import v.scanner

pub fn inspect_tokens(paths []string, prefs &pref.Preferences) {
	for path in paths {
		mut scanner := scanner.new_scanner_file(path, .parse_comments, prefs)
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
