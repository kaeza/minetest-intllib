
-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS, SS, SNS = dofile(MP.."/intllib.lua")

local use_count = 0

minetest.log("action", S("Hello, world!"))

minetest.register_craftitem("intltest:test", {
	-- Example use of replacements.
	-- Translators: @1 is color, @2 is object.
	description = S("Test: @1 @2", S("Blue"), S("Car")),

	inventory_image = "default_sand.png",

	on_use = function(stack, user, pt)
		use_count = use_count + 1
		-- Example use of `ngettext` function.
		-- First `use_count` is `n` for ngettext;
		-- Second one is actual replacement.
		-- Translators: @1 is use count.
		local message = NS("Item has been used @1 time.",
				"Item has been used @1 times.",
				use_count, use_count)
		minetest.chat_send_player(user:get_player_name(), message)
	end,
})

minetest.log("action", "Testing SS method")
for _,lang in ipairs({nil, "es", "pt", "de"}) do
	minetest.log("action", "("..dump(lang)..")"..SS(lang, "Test: @1 @2", SS(lang, "Green"), SS(lang, "Car")))
end

minetest.log("action", "Testing SNS method")
for n=1, 2 do
	minetest.log("action", "(nil)"..SNS(nil, "Hello, @1 world!", "Hello, @1 worlds!", n, n))
end
for _,lang in ipairs({"es", "pt", "de"}) do
	for n=1, 2 do
		minetest.log("action", "("..lang..")"..SNS(lang, "Hello, @1 world!", "Hello, @1 worlds!", n, n))
	end
end
