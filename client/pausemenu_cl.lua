----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

-- Thread to trigger menu on keypress
Citizen.CreateThread(function()
	while true do
	    Wait(1)
		SetPauseMenuActive(false)
	    if (IsControlJustPressed(0, 200)) then
            TransitionToBlurred(1000)
            SetNuiFocus(true, true)
            SendNUIMessage({
            open = true
            })
		end
	end
end)
-- Function to close menu
function ClosePause()
	TransitionFromBlurred(1000)
    SetNuiFocus(false, false)
    SendNUIMessage({
        open = false
    })
end
-- Close button; closes menu
RegisterNUICallback('Close', function(data)
    ClosePause()
end)
-- Settings button; sends to GTA options
RegisterNUICallback('Settings', function(data)
	ClosePause()
	ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'),0,-1)
end)
-- Disconnect button; drops player
RegisterNUICallback('DropPlayer', function(data)
    TriggerServerEvent('boii-pausemenu:DropPlayer')
end)
-- Submit button; submits a report as a discord webhook
RegisterNUICallback('NewReport', function(data)
    local NewReport = {fname = data.fname, lname = data.lname, reporttype = data.reporttype, subject = data.subject, description = data.description}
    TriggerServerEvent('boii-pausemenu:SendReport', NewReport)
end)

