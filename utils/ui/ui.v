module ui

pub fn divider(s string, width int) string {
	repeat_n := width / s.len
	tail_n := width % s.len
	return s.repeat(repeat_n) + s[..tail_n]
}
