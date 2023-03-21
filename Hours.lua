Hooks:Add('NetworkManagerOnPeerAdded', 'PlayerHoursInChat', function(peer, id)
	local show_hidden_hours = false --Change this to true/false to show/hide messages when a player has their hours hidden
	if managers.chat and peer then
		Steam:http_request('http://steamcommunity.com/profiles/'..peer:user_id()..'/games/?xml=1', function(success, page)
			if success then
				local _, gameStart = page:find("<appID>218620</appID>", 1, false)
				local name = peer:name() or ""
				local played = 'has played'
				local hour = 'hours'
				local hidden = 'has hours hidden'
				if gameStart then
					local _, hoursStart = page:find("<hoursOnRecord>", gameStart, false)
					local hoursEnd, _ = page:find("</hoursOnRecord>", hoursStart, false)
					if hoursStart and hoursEnd and ((hoursEnd - hoursStart) > 2) then
						local playtime = page:sub(hoursStart + 1, hoursEnd - 1)
						managers.chat:feed_system_message(ChatManager.GAME, string.format('%s %s %s %s', name, played, playtime, hour))
					end
				elseif show_hidden_hours then
					managers.chat:feed_system_message(ChatManager.GAME, string.format('%s %s', name, hidden))	
				end
			end
		end)
	end
end)