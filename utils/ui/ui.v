module ui

pub fn divider(template string, width int) string {
	fill_n := width - template.len
	if fill_n <= 0 || template.len == 0 {
		return template
	}
	left_n := fill_n / 2 + (if fill_n % 2 == 0 { 0 } else { 1 })
	right_n := fill_n / 2
	left := template.left(1).repeat(left_n)
	right := template.right(template.len - 1).repeat(right_n)
	return left + template + right
}
