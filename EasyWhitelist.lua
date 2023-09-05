-- Do not edit anything here unless you know what you are doing!
-- The configuration can be found in the module located inside this script instance!

local Players = game:GetService("Players")
local config = require(script.WhitelistModule)
local logPlayers = config.LogPlayers

Players.PlayerAdded:Connect(function(Player)
	local whitelisted = config:CheckPlayer(Player)
	
	if whitelisted ~= true then
		Player:Kick(config.KickMessage)
		if logPlayers then
			print("EasyWhitelist | Successfully kicked", Player.Name, "due to not being whitelisted!")
		end
	end
end)
