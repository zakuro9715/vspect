module scanner

import v.pref { Preferences }
import v.scanner

type Scanner = scanner.Scanner

pub fn new(path string, prefs &pref.Preferences) &Scanner {
	return scanner.new_scanner_file(path, .parse_comments, prefs)
}
