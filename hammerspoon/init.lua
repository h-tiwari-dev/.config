hs = hs
hs.loadSpoon("AClock")

hs.hotkey.bind({ "cmd", "alt" }, "C", function()
	spoon.AClock:toggleShow()
end)

-- Define the keyboard shortcut (Cmd + Alt + G)
hs.hotkey.bind({ "cmd", "alt" }, "g", function()
	local ghostty = hs.application.find("Ghostty")

	if ghostty then
		-- If Ghostty is already running, create a new window
		ghostty:selectMenuItem({ "Shell", "New Window" })
	else
		-- Launch Ghostty if it's not running
		hs.application.launchOrFocus("Ghostty")
	end
end)
