local obj = {
    is = false,
    curobj = 0,
    curobjdata = nil,
    currot = {x = 0.0, y = 0.0, z = 0.0},
    currotamt = 1.0,

    deleting = false,
    deleteHighlightEnt = nil
}
distMult = 55.0
nudgeOffsets = {x = 0.00, y = 0.00, z = 0.00}
nudgeMult = 0.01

local myObjs = {}

Citizen.CreateThread(function()
    DecorRegister("SDOP_Placed", 3)
    AddTextEntry("SDOP_OBJECTPLACER", "~s~~y~"..SDC.Lang.ObjPlace1.."~w~:~n~~"..SDC.PlaceKeys.SwitchMode.Input.."~ "..SDC.Lang.ObjPlace2..": (~b~"..SDC.Lang.ObjPlace3.."~w~)~n~~"..SDC.PlaceKeys.SwitchObj1.Input.."~ | ~"..SDC.PlaceKeys.SwitchObj2.Input.."~ "..SDC.Lang.ObjPlace6..": (~o~~a~".."~w~)~n~~"..SDC.PlaceKeys.RotObj1.Input.."~ | ~"..SDC.PlaceKeys.RotObj2.Input.."~ "..SDC.Lang.ObjPlace8.."~n~~"..SDC.PlaceKeys.ChangeRotAmt1.Input.."~ | ~"..SDC.PlaceKeys.ChangeRotAmt2.Input.."~ "..SDC.Lang.ObjPlace9..": (~p~~1~~w~)~n~~"..SDC.PlaceKeys.PlaceObj.Input.."~ ~g~"..SDC.Lang.ObjPlace3.."~w~~n~~"..SDC.PlaceKeys.Cancel.Input.."~ ~r~"..SDC.Lang.ObjPlace7)
    AddTextEntry("SDOP_OBJECTPLACER2", "~s~~y~"..SDC.Lang.ObjPlace1.."~w~:~n~~"..SDC.PlaceKeys.SwitchMode.Input.."~ "..SDC.Lang.ObjPlace2..": (~b~"..SDC.Lang.ObjPlace4.."~w~)~n~~"..SDC.PlaceKeys.RemoveObj.Input.."~ ~g~"..SDC.Lang.ObjPlace5.."~w~~n~~"..SDC.PlaceKeys.Cancel.Input.."~ ~r~"..SDC.Lang.ObjPlace7)
end)

if SDC.Keybind then
	RegisterKeyMapping(SDC.OpenCommand..":"..SDC.Keybind, 'Open Job Object Placer', 'keyboard', SDC.Keybind)
	RegisterCommand(SDC.OpenCommand..":"..SDC.Keybind, function(source, args, rawCommand)
		local playerjob = GetCurrentJob()
	
		if SDC.ObjJobs[playerjob] then
			if obj.is then
				obj.is = false
				if obj.curobjdata then
					DeleteEntity(obj.curobjdata)
				end
				obj.curobj = 0
				obj.currot = {x = 0.0, y = 0.0, z = 0.0}
				obj.deleting = false
			else
				local myGrade = GetCurrentJobGrade()
				local myObjs2 = {}
				for i=1, #SDC.ObjJobs[playerjob].Objects do
					if myGrade >= SDC.ObjJobs[playerjob].Objects[i].ReqGrade then
						table.insert(myObjs2, SDC.ObjJobs[playerjob].Objects[i])
					end
				end
				myObjs = myObjs2
				TriggerEvent("SDOP:StartPlacing")
			end
		end
	end, false)
else
	RegisterCommand(SDC.OpenCommand, function(source, args, rawCommand)
		local playerjob = GetCurrentJob()
	
		if SDC.ObjJobs[playerjob] then
			if obj.is then
				obj.is = false
				if obj.curobjdata then
					DeleteEntity(obj.curobjdata)
				end
				obj.curobj = 0
				obj.currot = {x = 0.0, y = 0.0, z = 0.0}
				obj.deleting = false
			else
				local myGrade = GetCurrentJobGrade()
				local myObjs2 = {}
				for i=1, #SDC.ObjJobs[playerjob].Objects do
					if myGrade >= SDC.ObjJobs[playerjob].Objects[i].ReqGrade then
						table.insert(myObjs, SDC.ObjJobs[playerjob].Objects[i])
					end
				end
				myObjs = myObjs2
				TriggerEvent("SDOP:StartPlacing")
			end
		end
	end, false)
end


RegisterNetEvent("SDOP:StartPlacing")
AddEventHandler("SDOP:StartPlacing", function()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    
    obj.curobj = 1
    obj.currot = {x = 0.0, y = 0.0, z = 0.0}
    obj.deleting = false

	LoadPropDict(myObjs[obj.curobj].model)
    obj.curobjdata = CreateObject(myObjs[obj.curobj].model, pcoords.x, pcoords.y, pcoords.z + 1, true, true, true)
	SetEntityRotation(obj.curobjdata, obj.currot.x, obj.currot.y, obj.currot.z, 0, false)
	SetEntityAlpha(obj.curobjdata, 153, false)
	SetEntityAsMissionEntity(obj.curobjdata)
	FreezeEntityPosition(obj.curobjdata, true)
	SetModelAsNoLongerNeeded(myObjs[obj.curobj].model)

    obj.is = true
    while obj.is do
        if not obj.deleting then
            local start,fin               = getCoordsInFrontOfCam(0,5000)
            local ray                     = StartShapeTestRay(start.x,start.y,start.z, fin.x,fin.y,fin.z, 1, (obj.curobjdata or PlayerPedId()), 5000)
            local oRay                    = StartShapeTestRay(start.x,start.y,start.z, fin.x,fin.y,fin.z, 16, (obj.curobjdata or PlayerPedId()), 5000)
            local r,hit,pos,norm,ent      = GetShapeTestResult(ray)
            local oR,oHit,oPos,oNorm,oEnt = GetShapeTestResult(oRay)
      
            if oHit > 0 then r,hit,pos,norm,ent = oR,oHit,oPos,oNorm,oEnt; end
    
            local min,max =  GetModelDimensions(GetEntityModel(obj.curobjdata))
            local minOff  = -GetOffsetFromEntityGivenWorldCoords(obj.curobjdata, min.x, min.y, min.z)
            local maxOff  = -GetOffsetFromEntityGivenWorldCoords(obj.curobjdata, max.x, max.y, max.z)
            local off     =  maxOff - minOff
    
            local p = GetEntityCoords(obj.curobjdata)
            p = vector3(p.x, p.y, p.z + (max.z/2)) 
    
            local x,y,z = 0,0,0
            local targetPos
            local dist = Vdist(start.x, start.y, start.z, pos)
    
            if dist < distMult + 0.5 then
              if norm.x >  0.5  then x = x + max.x; end
              if norm.x < -0.5  then x = x + min.x; end
              if norm.y >  0.5  then y = y + max.y; end
              if norm.y < -0.5  then y = y + min.y; end
              if norm.z >  0.5  then z = z - min.z; end
              if norm.z < -0.5  then z = z - max.z; end
    
              targetPos = vector3(pos.x + x,pos.y + y,pos.z + z)
            else
              local dir = pos - start
              local clamped = clampVecLength(dir, distMult)
              targetPos = start + clamped
            end
    
            SetEntityCoordsNoOffset(
                obj.curobjdata, 
                targetPos.x + nudgeOffsets.x, 
                targetPos.y + nudgeOffsets.y, 
                targetPos.z + nudgeOffsets.z  
            )
            SetEntityCollision(obj.curobjdata, false, true)

            BeginTextCommandDisplayHelp("SDOP_OBJECTPLACER")
            AddTextComponentSubstringPlayerName(myObjs[obj.curobj].label)
            AddTextComponentFloat(obj.currotamt+0.0, 1)
            EndTextCommandDisplayHelp(false, false, false, -1) 

            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.SwitchMode.InputNum) then
                obj.deleting = true
            end

            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.SwitchObj1.InputNum) then
                local newobjNum = 0
                if obj.curobj ~= 1 then
                    newobjNum = obj.curobj - 1
                else
                    newobjNum = #myObjs
                end
                
                LoadPropDict(myObjs[newobjNum].model)
                DeleteEntity(obj.curobjdata)
                obj.curobjdata = CreateObject(myObjs[newobjNum].model, pcoords.x, pcoords.y, pcoords.z + 1, true, true, true)
                obj.curobj = newobjNum
                SetEntityRotation(obj.curobjdata, obj.currot.x, obj.currot.y, obj.currot.z, 0, false)
                SetEntityAlpha(obj.curobjdata, 153, false)
                SetEntityAsMissionEntity(obj.curobjdata)
                FreezeEntityPosition(obj.curobjdata, true)
                SetModelAsNoLongerNeeded(myObjs[newobjNum].model)
            end
            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.SwitchObj2.InputNum) then
                local newobjNum = 0
                if obj.curobj ~= #myObjs then
                    newobjNum = obj.curobj + 1
                else
                    newobjNum = 1
                end
                
                LoadPropDict(myObjs[newobjNum].model)
                DeleteEntity(obj.curobjdata)
                obj.curobjdata = CreateObject(myObjs[newobjNum].model, pcoords.x, pcoords.y, pcoords.z + 1, true, true, true)
                obj.curobj = newobjNum
                SetEntityRotation(obj.curobjdata, obj.currot.x, obj.currot.y, obj.currot.z, 0, false)
                SetEntityAlpha(obj.curobjdata, 153, false)
                SetEntityAsMissionEntity(obj.curobjdata)
                FreezeEntityPosition(obj.curobjdata, true)
                SetModelAsNoLongerNeeded(myObjs[newobjNum].model)
            end

            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.RotObj1.InputNum) then
                if (obj.currot.z + obj.currotamt) > 359.0 then
                    obj.currot.z = (obj.currot.z + obj.currotamt) - 360.0
                else
                    obj.currot.z = (obj.currot.z + obj.currotamt)
                end

                SetEntityRotation(obj.curobjdata, obj.currot.x, obj.currot.y, obj.currot.z, 0, false)
            end
            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.RotObj2.InputNum) then
                if (obj.currot.z - obj.currotamt) < 0.0 then
                    obj.currot.z = (obj.currot.z - obj.currotamt) - 360.0
                else
                    obj.currot.z = (obj.currot.z - obj.currotamt)
                end

                SetEntityRotation(obj.curobjdata, obj.currot.x, obj.currot.y, obj.currot.z, 0, false)
            end

            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.ChangeRotAmt1.InputNum) then
                if (obj.currotamt + 1.0) <= SDC.MaxRotAmt then
                    obj.currotamt = obj.currotamt + 1.0
                end
            end
            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.ChangeRotAmt2.InputNum) then
                if (obj.currotamt - 1.0) >= 1.0 then
                    obj.currotamt = obj.currotamt - 1.0
                end
            end


            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.PlaceObj.InputNum) then
                if Vdist(pcoords.x, pcoords.y, pcoords.z, GetEntityCoords(obj.curobjdata)) <= 15 then
                    local objc = nil
                    local objr = nil
                    objc = GetEntityCoords(obj.curobjdata)
                    objr = obj.currot
                    LoadPropDict(myObjs[obj.curobj].model)
                    SetEntityCoordsNoOffset(
                        obj.curobjdata, 
                        objc.x + 2.0, 
                        objc.y + 2.0, 
                        objc.z + 2.0  
                    )
                    local newP = CreateObject(myObjs[obj.curobj].model, objc.x, objc.y, objc.z, true, true, true)
                    DecorSetInt(newP, "SDOP_Placed", 1)
                    SetEntityRotation(newP, obj.currot.x, obj.currot.y, obj.currot.z, 0, false)
                    SetEntityAsMissionEntity(newP)
                    PlaceObjectOnGroundProperly(newP)
                    if myObjs[obj.curobj].freeze then
                        FreezeEntityPosition(newP, true)
                    end
                    SetModelAsNoLongerNeeded(myObjs[obj.curobj].model)
                else
                    TriggerEvent("SDOP:Client:Notification", SDC.Lang.NotCloseEnough, 'error')
                end
            end
            
            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.Cancel.InputNum) then
                obj.is = false
                if obj.curobjdata then
                    DeleteEntity(obj.curobjdata)
                end
                obj.curobj = 0
                obj.currot = {x = 0.0, y = 0.0, z = 0.0}
                obj.deleting = false
            end
        else
            BeginTextCommandDisplayHelp("SDOP_OBJECTPLACER2")
            EndTextCommandDisplayHelp(false, false, false, -1)  

            EnableCrosshairThisFrame()
			ShowHudComponentThisFrame(14)
			DisablePlayerFiring(PlayerId(), true)

            if obj.curobjdata then
                DeleteEntity(obj.curobjdata)
                obj.curobjdata = nil
            end

            local isEnt, curEnt = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if isEnt and DecorExistOn(curEnt, "SDOP_Placed") then
                if not obj.deleteHighlightEnt then
                    obj.deleteHighlightEnt = curEnt
                    SetEntityDrawOutline(curEnt, true)
                    SetEntityDrawOutlineColor(255, 0, 0, 200)
                elseif obj.deleteHighlightEnt ~= curEnt then
                    if DoesEntityExist(obj.deleteHighlightEnt) then
                        SetEntityDrawOutline(obj.deleteHighlightEnt, false)
                    end
                    obj.deleteHighlightEnt = curEnt
                    SetEntityDrawOutline(curEnt, true)
                    SetEntityDrawOutlineColor(255, 0, 0, 200)
                end

                if IsDisabledControlJustReleased(0, SDC.PlaceKeys.RemoveObj.InputNum) then
                    local daEnt = nil
                    daEnt = curEnt
                    TriggerServerEvent("SDOP:Server:DeleteObject", NetworkGetNetworkIdFromEntity(daEnt))
                end
            elseif obj.deleteHighlightEnt then
                if DoesEntityExist(obj.deleteHighlightEnt) then
                    SetEntityDrawOutline(obj.deleteHighlightEnt, false)
                end
                obj.deleteHighlightEnt = nil
            end



            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.SwitchMode.InputNum) then
                LoadPropDict(myObjs[obj.curobj].model)
                obj.curobjdata = CreateObject(myObjs[obj.curobj].model, pcoords.x, pcoords.y, pcoords.z + 1, true, true, true)
                SetEntityRotation(obj.curobjdata, obj.currot.x, obj.currot.y, obj.currot.z, 0, false)
                SetEntityAlpha(obj.curobjdata, 153, false)
                SetEntityAsMissionEntity(obj.curobjdata)
                FreezeEntityPosition(obj.curobjdata, true)
                SetModelAsNoLongerNeeded(myObjs[obj.curobj].model)
                obj.deleting = false
            end




            if IsDisabledControlJustReleased(0, SDC.PlaceKeys.Cancel.InputNum) then
                obj.is = false
                if obj.curobjdata then
                    DeleteEntity(obj.curobjdata)
                end
                obj.curobj = 0
                obj.currot = {x = 0.0, y = 0.0, z = 0.0}
                obj.deleting = false
                if DoesEntityExist(obj.deleteHighlightEnt) then
                    SetEntityDrawOutline(obj.deleteHighlightEnt, false)
                end
                obj.deleteHighlightEnt = nil
            end
        end

        DisableControlAction(0,  SDC.PlaceKeys.SwitchMode.InputNum, true)
		DisableControlAction(0,  SDC.PlaceKeys.SwitchObj1.InputNum, true)
        DisableControlAction(0,  SDC.PlaceKeys.SwitchObj2.InputNum, true)
        DisableControlAction(0,  SDC.PlaceKeys.RotObj1.InputNum, true)
        DisableControlAction(0,  SDC.PlaceKeys.RotObj2.InputNum, true)
        DisableControlAction(0,  SDC.PlaceKeys.ChangeRotAmt1.InputNum, true)
        DisableControlAction(0,  SDC.PlaceKeys.ChangeRotAmt2.InputNum, true)
        DisableControlAction(0,  SDC.PlaceKeys.PlaceObj.InputNum, true)
        DisableControlAction(0,  SDC.PlaceKeys.RemoveObj.InputNum, true)
        DisableControlAction(0,  SDC.PlaceKeys.Cancel.InputNum, true)

		    -- All controls related to [F] key
		DisableControlAction(0,  23, true)
		DisableControlAction(0,  75, true)
		DisableControlAction(0, 144, true)
		DisableControlAction(0, 145, true)
		DisableControlAction(0, 185, true)
		DisableControlAction(0, 251, true)
		
			-- Left click
			--DisableControlAction(0,  18, true)
		DisableControlAction(0,  24, true)
		DisableControlAction(0,  69, true)
		DisableControlAction(0,  92, true)
		DisableControlAction(0, 106, true)
		DisableControlAction(0, 122, true)
		DisableControlAction(0, 135, true)
		DisableControlAction(0, 142, true)
		DisableControlAction(0, 144, true)
			--DisableControlAction(0, 176, true)
		DisableControlAction(0, 223, true)
		DisableControlAction(0, 229, true)
		DisableControlAction(0, 237, true)
		DisableControlAction(0, 257, true)
		DisableControlAction(0, 329, true)
		DisableControlAction(0, 346, true)
		
			-- Right Click
		DisableControlAction(0,  25, true)
		DisableControlAction(0,  68, true)
		DisableControlAction(0,  70, true)
		DisableControlAction(0,  91, true)
		DisableControlAction(0, 114, true)
		   -- DisableControlAction(0, 177, true)
		DisableControlAction(0, 222, true)
		DisableControlAction(0, 225, true)
		DisableControlAction(0, 238, true)
		DisableControlAction(0, 330, true)
		DisableControlAction(0, 331, true)
		DisableControlAction(0, 347, true)
		
			-- Numpad -
		DisableControlAction(0,  96, true)
		DisableControlAction(0,  97, true)
		DisableControlAction(0, 107, true)
		DisableControlAction(0, 108, true)
		DisableControlAction(0, 109, true)
		DisableControlAction(0, 110, true)
		DisableControlAction(0, 111, true)
		DisableControlAction(0, 112, true)
		DisableControlAction(0, 117, true)
		DisableControlAction(0, 118, true)
		DisableControlAction(0, 123, true)
		DisableControlAction(0, 124, true)
		DisableControlAction(0, 125, true)
		DisableControlAction(0, 126, true)
		DisableControlAction(0, 127, true)
		DisableControlAction(0, 128, true)
		DisableControlAction(0, 314, true)
		DisableControlAction(0, 315, true)
			-- Scroll
		DisableControlAction(0, 261, true)
		DisableControlAction(0, 262, true)
		DisableControlAction(0, 14, true)
		DisableControlAction(0, 15, true)
		DisableControlAction(0, 16, true)
		DisableControlAction(0, 17, true)
  
        Wait(0)
    end
end)




















--Placing Functions
function clampVecLength(v, maxLength)
	if vecSqMagnitude(v) > (maxLength * maxLength) then
		v = vecSetNormalize(v)
		v = vecMulti(v, maxLength)
	end
	return v
end
function vecSqMagnitude(v)
	return ((v.x * v.x) + (v.y * v.y) + (v.z * v.z))
end
function vecSetNormalize(v)
	local num = vecLength(v)
	if num == 1 then
		return v
	elseif num > 1e-5 then
		return vecDiv(v, num)
	else
		return vector3(0, 0, 0)
	end
end
function vecDiv(v, d)
	local x = v.x / d
	local y = v.y / d
	local z = v.z / d
	return vector3(x, y, z)
end
function vecMulti(v, q)
	local x, y, z
	local retVec
	if type(q) == "number" then
		x = v.x * q
		y = v.y * q
		z = v.z * q
		retVec = vector3(x, y, z)
	end
	return retVec
end
function vecLength(v)
	return math.sqrt((v.x * v.x) + (v.y * v.y) + (v.z * v.z))
end

function getCoordsInFrontOfCam(...)
	local unpack = table.unpack
	local coords, direction = GetGameplayCamCoord(), rotationToDirection()
	local inTable = {...}
	local retTable = {}
	if (#inTable == 0) or (inTable[1] < 0.000001) then
		inTable[1] = 0.000001
	end
	for k, distance in pairs(inTable) do
		if (type(distance) == "number") then
			if (distance == 0) then
				retTable[k] = coords
			else
				retTable[k] =
					vector3(
					coords.x + (distance * direction.x),
					coords.y + (distance * direction.y),
					coords.z + (distance * direction.z)
				)
			end
		end
	end
	return unpack(retTable)
 end

function rotationToDirection(rot)
	if (rot == nil) then
		rot = GetGameplayCamRot(2)
	end
	local rotZ = rot.z * (3.141593 / 180.0)
	local rotX = rot.x * (3.141593 / 180.0)
	local c = math.cos(rotX)
	local multXY = math.abs(c)
	local res = vector3((math.sin(rotZ) * -1) * multXY, math.cos(rotZ) * multXY, math.sin(rotX))
	return res
end

function LoadPropDict(model)
	while not HasModelLoaded(model) do
	  RequestModel(model)
	  Wait(10)
	end
end

function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
	  RequestAnimDict(dict)
	  Wait(10)
	end
end