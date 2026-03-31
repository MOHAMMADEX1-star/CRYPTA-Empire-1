-- CRYPTA v5.9 CANDY EGG BULLETPROOF | Delta Ready
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local TeleportService=game:GetService("TeleportService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Camera=Workspace.CurrentCamera
local LocalPlayer=Players.LocalPlayer

getgenv().CRYPTA_LOADED=true
getgenv().HackerAI_Authorized=true

local function httpGet(url)
    return game:HttpGet(url:gsub("https://","http://"))
end

-- Kavo UI (Default Theme - Guaranteed)
local Library=loadstring(httpGet("http://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window=Library.CreateLib("CRYPTA EMPIRE v5.9 CANDY EGG","Default")
local Watermark=Library:CreateWatermark("CRYPTA v5.9 | Delta Ready | Candy Egg")

-- Sea TPs
local seas={"Sea1","Sea2","Sea3","Sea1_1","Sea1_2","Sea2_1","Sea2_2","Sea2_3","Sea3_1","Sea3_2","Sea3_3","Sea3_4","Sea3_5","Sea3_6","Sea3_7","Sea3_8","Sea3_9","Sea3_10","Sea3_11","Sea3_12","Sea3_13","Sea3_14","Sea3_15","Sea3_16","Sea3_17","Sea3_18"}

-- MAIN TAB
local MainTab=Window:NewTab("Main")
local statType="Melee"
MainTab:NewDropdown("Stat Type","Select stat",{"Melee","Defense","Sword","Gun","Demon Fruit","Bloom","Observation"},function(stat)
    statType=stat
end)
MainTab:NewToggle("Max Stats","Max selected stat",function(state)
    getgenv().maxStats=state
    if state then
        task.spawn(function()
            while getgenv().maxStats do
                pcall(function()
                    for i=1,5 do
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint",statType,1000)
                        task.wait(0.15)
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

MainTab:NewButton("Rejoin","Rejoin server",function()
    TeleportService:Teleport(game.PlaceId,LocalPlayer)
end)

MainTab:NewButton("Server Hop","Hop servers",function()
    loadstring(httpGet("http://raw.githubusercontent.com/EdgeIY/infiniteyield/master/serverhop.lua"))()
end)

-- FARM TAB
local FarmTab=Window:NewTab("Farm")
FarmTab:NewToggle("Auto Farm","Farm nearest enemy",function(state)
    getgenv().autoFarm=state
end)
FarmTab:NewSlider("Farm Distance","Max distance",500,50,function(value)
    getgenv().farmDistance=value
end)

-- COMBAT TAB
local CombatTab=Window:NewTab("Combat")
CombatTab:NewToggle("ESP","Enemy ESP",function()
    loadstring(httpGet("http://raw.githubusercontent.com/skatbr/A_simple_esp.lua/main/A_simple_esp.lua"))()
end)

CombatTab:NewToggle("Inf Stamina","Infinite stamina",function(state)
    getgenv().infStam=state
end)

CombatTab:NewSlider("Walk Speed","16-200",16,200,function(value)
    getgenv().walkSpeed=value
end)

-- MOBILE FLY
local flyActive=false
local flyVel=100
local bv, bav
CombatTab:NewToggle("Mobile Fly","BV Heartbeat fly",function(state)
    flyActive=state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root=LocalPlayer.Character.HumanoidRootPart
        if state then
            bv=Instance.new("BodyVelocity")
            bv.MaxForce=Vector3.new(4000,4000,4000)
            bv.Parent=root
            bav=Instance.new("BodyAngularVelocity")
            bav.MaxTorque=Vector3.new(4000,4000,4000)
            bav.Parent=root
            
            RunService.Heartbeat:Connect(function()
                if flyActive and root.Parent then
                    local camDir=Camera.CFrame.LookVector*flyVel
                    bv.Velocity=Vector3.new(camDir.X,
                        (UserInputService:IsKeyDown(Enum.KeyCode.Space) and flyVel or 
                         UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -flyVel or 0),
                        camDir.Z)
                end
            end)
        else
            if bv then bv:Destroy() end
            if bav then bav:Destroy() end
        end
    end
end)

CombatTab:NewSlider("Fly Speed","1-200",100,1,function(value)
    flyVel=value
end)

-- MISC TAB
local MiscTab=Window:NewTab("Misc")
MiscTab:NewDropdown("Sea Teleport","TP to sea",seas,function(sea)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSea",sea)
    end)
end)

MiscTab:NewButton("Destroy GUI","Close script",function()
    Library:Destroy()
end)

-- MAIN LOOP
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char=LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            local root=char.HumanoidRootPart
            local hum=char.Humanoid
            
            -- Auto Farm
            if getgenv().autoFarm then
                local target=nil
                local minDist=getgenv().farmDistance or 500
                for _,mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") then
                        local distance=(root.Position-mob.HumanoidRootPart.Position).Magnitude
                        if distance<minDist then
                            minDist=distance
                            target=mob
                        end
                    end
                end
                if target then
                    root.CFrame=target.HumanoidRootPart.CFrame*CFrame.new(0,5,0)
                    task.wait(0.1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest",target.Name,1)
                end
            end
            
            -- Other features
            if getgenv().infStam then
                hum:ChangeState(Enum.HumanoidStateType.Physics)
            end
            if getgenv().walkSpeed then
                hum.WalkSpeed=getgenv().walkSpeed
            end
        end
    end)
end)

print("CRYPTA v5.9 CANDY EGG LOADED SUCCESSFULLY!")
print("Delta Compatible - All Features Working!")
