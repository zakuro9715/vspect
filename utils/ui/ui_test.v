module ui

fn test_divider() {
	assert divider('-x-', 4) == '--x-'
	assert divider('-x-', 5) == '--x--'
	assert divider('- x -', 9) == '--- x ---'
}
