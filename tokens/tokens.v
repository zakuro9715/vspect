module tokens

import v.pref { Preferences }
import v.scanner
import utils.ui

const divider_width = "xxxx, xx  | xxxxxxxx  | 'xxxxxxxxxx'".len

pub fn inspect_tokens(paths []string, prefs &pref.Preferences) {
	for path in paths {
		mut scanner := scanner.new_scanner_file(path, .parse_comments, prefs)
		println(ui.divider('= $path =', tokens.divider_width))
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
		println(ui.divider('=', tokens.divider_width))
	}
}
