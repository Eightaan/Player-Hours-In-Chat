local close_person_joining_original = MenuManager.close_person_joining

function MenuManager:close_person_joining(id, ...)
    local show_hidden_hours = true --Change this to false to disable the hidden hour message
	if managers.chat and managers.system_menu:is_active_by_id("user_dropin" .. id) then
		local peer = managers.network:session() and managers.network:session():peer(id)
		if peer then
		    Steam:http_request('http://steamcommunity.com/profiles/'..peer:user_id()..'/games/?tab=recent', function(success, body)
	            if success then
					local hour = 'hours'
	                local played = 'has played'
					local hidden = 'has hours hidden'
					local name = peer:name() or ""
	                local s1, e1 = string.find(body, 'PAYDAY 2')
	                if e1 then
		                local s2, e2 = string.find(body, 'hours_forever', e1)
			            if e2 then
			                local hours = ''
			                local i = e2+4
				            while true do
			                    local ch = string.sub(body, i, i)
				                if tonumber(ch) then
					                hours = hours..ch
					                i = i + 1
				                elseif ch == ',' then
					                 i = i + 1
				                else
				                    break
			                    end
		                    end
                            local hrs = tonumber(hours)
	                        if hrs and hrs > 0 then 								
					            managers.chat:feed_system_message(ChatManager.GAME, string.format("%s %s %s %s", name, played, hrs, hour))
					        end			   
			            end
					elseif show_hidden_hours then
                        managers.chat:feed_system_message(ChatManager.GAME, string.format("%s %s", name, hidden))					
		            end
	            end
            end)
		end
    end
	close_person_joining_original(self, id, ...)
end