SDC = {}

---------------------------------------------------------------------------------
-------------------------------Important Configs---------------------------------
---------------------------------------------------------------------------------
SDC.Framework = "qb-core" --Either "qb-core" or "esx"
SDC.NotificationSystem = "framework" -- ['mythic_old', 'mythic_new', 'tnotify', 'okoknotify', 'print', 'framework', 'none'] --Notification system you prefer to use


SDC.OpenCommand = "jobobjectplacer" --Put the command to open the menu here
SDC.Keybind = "O" --Keybind for object placer, if you don't want a keybind set it to false/nil

SDC.MaxRotAmt = 15 --The maximam rotation amount for each rotation interval
---------------------------------------------------------------------------------
-------------------------------Job Configs---------------------------------------
---------------------------------------------------------------------------------
--This is where you will add all your jobs you wish to have access to placing objects
SDC.ObjJobs = {
    --[[
        Example Below:
        
        ["JOB_NAME"] = {
            Label = "JOB_LABEL",
            Objects = {
                --ReqGrade = Grade needed to place this object!
                --label = Label for the object in placer
                --model = The model of the prop,
                --freeze = if you want it to freeze the object in place
                {ReqGrade = 0, label = "Cone", model = `prop_roadcone02a`, freeze = false},
            }
        },
    ]]

    ["police"] = {
        Label = "LSPD",
        Objects = {
            {ReqGrade = 0, label = "Cone", model = `prop_roadcone02a`, freeze = false},
            {ReqGrade = 0, label = "Road Pole", model = `prop_roadpole_01a`, freeze = false},
            {ReqGrade = 0, label = "Barrier", model = `prop_barrier_work06a`, freeze = true},
            {ReqGrade = 0, label = "Road Barrier", model = `prop_mp_barrier_02b`, freeze = true},
            {ReqGrade = 0, label = "Work Light", model = `prop_worklight_02a`, freeze = true},
            {ReqGrade = 0, label = "Light", model = `prop_worklight_03b`, freeze = true},  
            {ReqGrade = 0, label = "Road Sign", model = `prop_sign_road_01b`, freeze = true},
            {ReqGrade = 0, label = "Tent", model = `prop_gazebo_03`, freeze = true},
            {ReqGrade = 0, label = "Folding Table", model = `prop_ven_market_table1`, freeze = true}, 
        }
    },
    ["firefighter"] = {
        Label = "SAFD",
        Objects = {
            {ReqGrade = 0, label = "Cone", model = `prop_roadcone02a`, freeze = false},
            {ReqGrade = 0, label = "Road Pole", model = `prop_roadpole_01a`, freeze = false},
            {ReqGrade = 0, label = "Barrier", model = `prop_barrier_work06a`, freeze = true},
            {ReqGrade = 0, label = "Road Barrier", model = `prop_mp_barrier_02b`, freeze = true},
            {ReqGrade = 0, label = "Work Light", model = `prop_worklight_02a`, freeze = true},
            {ReqGrade = 0, label = "Light", model = `prop_worklight_03b`, freeze = true},  
            {ReqGrade = 0, label = "Road Sign", model = `prop_sign_road_01b`, freeze = true},
            {ReqGrade = 0, label = "Tent", model = `prop_gazebo_03`, freeze = true},
            {ReqGrade = 0, label = "Folding Table", model = `prop_ven_market_table1`, freeze = true}, 
        }
    }
}

---------------------------------------------------------------------------------
-------------------------------Placing Configs-----------------------------------
---------------------------------------------------------------------------------
SDC.PlaceKeys = {
    SwitchMode = {Input = "INPUT_PICKUP", InputNum = 38},
    SwitchObj1 = {Input = "INPUT_FRONTEND_LEFT", InputNum = 189},
    SwitchObj2 = {Input = "INPUT_FRONTEND_RIGHT", InputNum = 190},
    RotObj1 = {Input = "INPUT_WEAPON_WHEEL_PREV", InputNum = 15},
    RotObj2 = {Input = "INPUT_WEAPON_WHEEL_NEXT", InputNum = 14},
    ChangeRotAmt1 = {Input = "INPUT_FRONTEND_UP", InputNum = 188},
    ChangeRotAmt2 = {Input = "INPUT_FRONTEND_DOWN", InputNum = 187},
    PlaceObj = {Input = "INPUT_ATTACK", InputNum = 24},
    RemoveObj = {Input = "INPUT_ATTACK", InputNum = 24},
    Cancel = {Input = "INPUT_DETONATE", InputNum = 47}
}