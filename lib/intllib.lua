-- intllib.lua
-- should be copied from ../intllib/lib/intllib.lua   (2019-05-15)

-- Since 5.0.0 the MT function `minetest.get_translator` is provided.

-- Fallback functions for when `intllib` is not installed.
-- Code released under minetest-mods/intllib/LICENSE.md -- LGPLv2.1+

-- This is a Minetest Game Translation community effort.
-- Copyright (2017-18) Diego Martínez (kaeza).
-- Copyright (2019) snoopy (Zweihorn) & kaeza & MT Game Developers.


local gettext, ngettext

-- Check if `intllib` should be activated or not in the first place.
-- The MT function `minetest.get_translator` may be a better solution.
-- However, it is unclear when the MT 5 scheme will be truly in place.

local setactive = false
local i = minetest.settings:get("intllib")
if i and i ~= "" then
	if i == "true" or i == "TRUE" then
		setactive = true
	end
end

-- Use the MT function `minetest.get_translator` if `intllib` is off.

if not setactive and minetest.get_translator then

	gettext, ngettext = minetest.get_translator()

else

-- When possible use `make_gettext_pair` from `intllib` if installed.

    if minetest.get_modpath("intllib") then

		if intllib.make_gettext_pair then
			-- New method using gettext compliant to GNU gettext tool.
			gettext, ngettext = intllib.make_gettext_pair()
		else
			-- The poor old method using text files.
			gettext = intllib.Getter()
		end

    else

    -- Fallback to handle a `S("string")` enclosure if not installed.

		local function format(str, ...)
			local args = { ... }
			local function repl(escape, open, num, close)
				if escape == "" then
					local replacement = tostring(args[tonumber(num)])
					if open == "" then
						replacement = replacement..close
					end
					return replacement
				else
					return "@"..open..num..close
				end
			end
			return (str:gsub("(@?)@(%(?)(%d+)(%)?)", repl))
		end

	-- Fill in missing functions if `intllib` is not installed.

    	gettext = function(msgid, ...)
	    	return format(msgid, ...)
    	end

    	ngettext = function(msgid, msgid_plural, n, ...)
	    	return format(n==1 and msgid or msgid_plural, ...)
    	end
    end
end

return gettext, ngettext
