local EasyWhitelist = {}
local MarketplaceService = game:GetService("MarketplaceService")

--[[
EasyWhitelist.WhitelistedUsers = {"InsertRobloxUser", "InsertRobloxUser", "InsertRobloxUser"}
EasyWhitelist.WhitelistedIDs = {UserID, UserID, UserID,UserID}
EasyWhitelist.WhitelistedGroups = {
	[groupId] = {
		GREATER OR EQUAL TO EXAMPLE:
		{Rank = RankId, Behavior = ">="}
		
		EQUAL TO EXAMPLE:
		{Rank = RankId, Behavior = "=="}
		
		LESS THAN OR EQUAL TO EXAMPLE:
		{Rank = RankId, Behavior = "<="}
		
		GREATER THAN EXAMPLE:
		{Rank = RankId, Behavior = ">"}
		
		LESS THAN EXAMPLE:
		{Rank = RankId, Behavior = "<"}
	},
}

EasyWhitelist.WhitelistedClothing = {clothingId, clothingId, clothingId, clothingId} 
EasyWhitelist.WhitelistedGamepasses = {gamepassId, gamepassId, gamepassId, } 
]]

EasyWhitelist.SystemActive = true -- Whether or not EasyWhitelist is active
EasyWhitelist.LogPlayers = true -- Logs in server console when player is kicked
EasyWhitelist.KickMessage = "EasyWhitelist | You are not whitelisted!" -- Kick message

EasyWhitelist.WhitelistedUsers = {} -- Whitelisted usernames
EasyWhitelist.WhitelistedIDs = {} -- Whitelisted UserIds
EasyWhitelist.WhitelistedGroups = {} -- Whitelisted group ranks
EasyWhitelist.WhitelistedClothing = {} -- Whitelisted clothing
EasyWhitelist.WhitelistedGamepasses = {} -- Whitelisted gamepasses

-- Do not edit anything below unless you know what you are doing!

function EasyWhitelist:CheckPlayer(Player:Player)
	if self.SystemActive == false then return true end
	if Player then
		if table.find(self.WhitelistedUsers, Player.Name) then return true end
		if table.find(self.WhitelistedIDs, Player.UserId) then return true end
		
		for groupId, data in pairs(self.WhitelistedGroups) do
			if Player:IsInGroup(groupId) then
				for _, package in pairs(data) do
					local rank = package.Rank
					local behavior = package.Behavior

					if rank and behavior then
						if behavior == "==" then
							if Player:GetRankInGroup(groupId) == rank then
								return true
							end
						elseif behavior == ">" then
							if Player:GetRankInGroup(groupId) > rank then
								return true
							end
						elseif behavior == "<" then
							if Player:GetRankInGroup(groupId) < rank then
								return true
							end
						elseif behavior == ">=" then
							if Player:GetRankInGroup(groupId) >= rank then
								return true
							end
						elseif behavior == "<=" then
							if Player:GetRankInGroup(groupId) <= rank then
								return true
							end
						end
					else
						warn("EasyWhitelist | A table has not been setup correctly [no rank / no behavior]", {groupId, data})
					end
				end
			end
		end
		

		for _, assetId in pairs(self.WhitelistedClothing) do
			if MarketplaceService:PlayerOwnsAsset(Player, assetId) then
				return true
			end
		end
		
		
		for _, assetId in pairs(self.WhitelistedGamepasses) do
			if MarketplaceService:UserOwnsGamePassAsync(Player.UserId, assetId) then
				return true
			end
		end

	else
		warn("EasyWhitelist | checkPlayer did not receieve a player argument!")
	end
end

return EasyWhitelist
