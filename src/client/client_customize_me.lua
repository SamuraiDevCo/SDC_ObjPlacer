local QBCore = nil
local ESX = nil

if SDC.Framework == "qb-core" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif SDC.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
end


function GetCurrentJob()
    if SDC.Framework == "qb-core" then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if PlayerData and PlayerData.job and PlayerData.job.name then
            return PlayerData.job.name
        else
            return ""
        end
    elseif SDC.Framework == "esx" then
        local PlayerData = ESX.GetPlayerData()
        if PlayerData and PlayerData.job and PlayerData.job.name then
            return PlayerData.job.name
        else
            return ""
        end
    end
end

function GetCurrentJobGrade()
    if SDC.Framework == "qb-core" then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if PlayerData and PlayerData.job and PlayerData.job.grade then
            return PlayerData.job.grade.level
        else
            return 0
        end
    elseif SDC.Framework == "esx" then
        local PlayerData = ESX.GetPlayerData()
        if PlayerData and PlayerData.job and PlayerData.job.grade then
            return PlayerData.job.grade
        else
            return 0
        end
    end
end


RegisterNetEvent("SDOP:Client:Notification")
AddEventHandler("SDOP:Client:Notification", function(msg, extra)
	if SDC.NotificationSystem == 'tnotify' then
		exports['t-notify']:Alert({
			style = 'message', 
			message = msg
		})
	elseif SDC.NotificationSystem == 'mythic_old' then
		exports['mythic_notify']:DoHudText('inform', msg)
	elseif SDC.NotificationSystem == 'mythic_new' then
		exports['mythic_notify']:SendAlert('inform', msg)
	elseif SDC.NotificationSystem == 'okoknotify' then
		exports['okokNotify']:Alert(SDC.Lang.DealershipLabel, msg, 3000, 'neutral')
	elseif SDC.NotificationSystem == 'print' then
		print(msg)
	elseif SDC.NotificationSystem == 'framework' then
        if SDC.Framework == "qb-core" then
            QBCore.Functions.Notify(msg, extra)
        elseif SDC.Framework == "esx" then
            ESX.ShowNotification(msg)
        end
	end 
end)