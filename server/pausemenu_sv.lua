----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

-- Event to collect (data) from nui callback
RegisterNetEvent('boii-pausemenu:SendReport')
AddEventHandler('boii-pausemenu:SendReport', function(data)
	local ids = ExtractIdentifiers(source)
	local NewReport = {
		playerid = source,
		fname = data.fname,
        lname = data.lname,
        reporttype = data.reporttype,
		subject = data.subject,
		description = data.description,
		discord = '<@'..ids.discord:gsub('discord:', '')..'>',
        license = ids.license:gsub('license2:', '')
	}
	SendWebhook(NewReport)
end)
-- Function to send (data) through webhook
function SendWebhook(data)
    local footertext = Config.Discord.BotData.Footer.Text
    local icon = Config.Discord.BotData.Footer.Icon
    local botname = Config.Discord.BotData.Name
    local botlogo = Config.Discord.BotData.Logo
	local report = {
		{
            ['title'] = '**Type:** '..data.reporttype,
			['color'] = Config.Discord.Colour,
			['footer'] = {
                ['text'] = footertext..os.date('%c'),
                ['icon_url'] = icon,
            },
            ['description'] = '**First name:** '..data.fname..'\n**Last name:** '..data.lname..'\n**Subject:** '..data.subject..'\n**Description:** '..data.description..'\n**ID:** '..data.playerid..'\n**Discord:** '..data.discord..'\n**License:** ||'..data.license..'||',
		}
	}
	PerformHttpRequest(Config.Discord.Webhook, function(err, text, headers) end, 'POST', json.encode({username = botname, embeds = report, avatar_url = botlogo}), {['Content-Type'] = 'application/json'})
end
-- Event to drop player
RegisterServerEvent('boii-pausemenu:DropPlayer')
AddEventHandler('boii-pausemenu:DropPlayer', function()
	DropPlayer(source, 'You disconnected from the server.')
end)
-- Function to grab indentifiers; borrowed from BADGER-ANTICHEAT <3
function ExtractIdentifiers(id)
    local identifiers = {
        steam = '',
        ip = '',
        discord = '',
        license = '',
        xbl = '',
        live = ''
    }
    for i = 0, GetNumPlayerIdentifiers(id) - 1 do
        local playerID = GetPlayerIdentifier(id, i)
        if string.find(playerID, 'steam') then
            identifiers.steam = playerID
        elseif string.find(playerID, 'ip') then
            identifiers.ip = playerID
        elseif string.find(playerID, 'discord') then
            identifiers.discord = playerID
        elseif string.find(playerID, 'license') then
            identifiers.license = playerID
        elseif string.find(playerID, 'xbl') then
            identifiers.xbl = playerID
        elseif string.find(playerID, 'live') then
            identifiers.live = playerID
        end
    end
    return identifiers
end
