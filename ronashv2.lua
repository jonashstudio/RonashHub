-- Ronash Hub — Safe merged (no aimbot, added safe exploit features)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

local Window = Library:Window({
    Title = "Ronash Hub",
    Desc  = "Ronash Hub — update",
    Icon  = 75875011299043,
    Theme = "Dark",
    Config = { Keybind = Enum.KeyCode.RightControl, Size = UDim2.new(0, 720, 0, 480) },
    CloseUIButton = { Enabled = true, Text = "Ronash" }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local ALLOW_DEMOS = RunService:IsStudio()
local hasDrawing = (type(Drawing) == "table" and type(Drawing.new) == "function")

local function notify(t,c,d) pcall(function() Window:Notify({Title=t or "Ronash", Desc=c or "", Time=d or 3}) end) end

-- Tabs
local MainTab    = Window:Tab({Title="Main", Icon="star"})
local PlayerTab  = Window:Tab({Title="Player", Icon="user"})
local VisualsTab = Window:Tab({Title="Visuals", Icon="eye"})
local TeleportTab= Window:Tab({Title="Teleport", Icon="map-pin"})
local MiscTab    = Window:Tab({Title="Misc", Icon="layers"})
local SettingsTab= Window:Tab({Title="Settings", Icon="wrench"})

-- MAIN
MainTab:Section({Title="Overview"})
MainTab:Button({Title="Copy Discord Invite", Callback=function() pcall(setclipboard,"https://discord.gg/pvywPyskHT"); notify("Discord","Invite copied",2) end})
MainTab:Button({Title="Spawn Local Demo Marker", Callback=function()
    local cam = Workspace.CurrentCamera
    if cam then
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.6,0.6,0.6); p.Anchored = true; p.CanCollide = false; p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(120,200,255); p.CFrame = cam.CFrame * CFrame.new(0,0,-6); p.Parent = Workspace
        notify("Demo","Local marker spawned (3s)",2)
        task.delay(3, function() if p and p.Parent then p:Destroy() end end)
    end
end})

-- PLAYER: Fly + WalkSpeed/JumpPower + Infinite Jump + Teleports
local pSection = PlayerTab:Section({Title="Player Utilities"})

-- Fly (embedded)
local flyVars = {}
flyVars.plr = Players.LocalPlayer
flyVars.mouse = flyVars.plr:GetMouse()
flyVars.torso = nil
flyVars.flying = false
flyVars.ctrl = {f=0,b=0,l=0,r=0}
flyVars.lastctrl = {f=0,b=0,l=0,r=0}
flyVars.maxspeed = 50
flyVars.speed = 0
flyVars.bg = nil
flyVars.bv = nil

local function initFlyVars()
    local c = flyVars.plr.Character
    if c then
        flyVars.torso = c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso") or c:FindFirstChild("HumanoidRootPart")
    end
end
initFlyVars()
flyVars.plr.CharacterAdded:Connect(function() task.wait(0.5); initFlyVars() end)

local function FlyFunc()
    if not flyVars.torso then return end
    flyVars.bg = Instance.new("BodyGyro", flyVars.torso); flyVars.bg.P = 9e4; flyVars.bg.maxTorque = Vector3.new(9e9,9e9,9e9)
    flyVars.bg.cframe = flyVars.torso.CFrame
    flyVars.bv = Instance.new("BodyVelocity", flyVars.torso); flyVars.bv.velocity = Vector3.new(0,0.1,0); flyVars.bv.maxForce = Vector3.new(9e9,9e9,9e9)
    repeat task.wait()
        local char = flyVars.plr.Character
        if char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.PlatformStand = true end
        if flyVars.ctrl.l + flyVars.ctrl.r ~= 0 or flyVars.ctrl.f + flyVars.ctrl.b ~= 0 then
            flyVars.speed = flyVars.speed + 0.5 + (flyVars.speed/flyVars.maxspeed)
            if flyVars.speed > flyVars.maxspeed then flyVars.speed = flyVars.maxspeed end
        elseif flyVars.speed ~= 0 then
            flyVars.speed = flyVars.speed - 1
            if flyVars.speed < 0 then flyVars.speed = 0 end
        end
        if (flyVars.ctrl.l + flyVars.ctrl.r) ~= 0 or (flyVars.ctrl.f + flyVars.ctrl.b) ~= 0 then
            flyVars.bv.velocity = ((Workspace.CurrentCamera.CFrame.LookVector * (flyVars.ctrl.f+flyVars.ctrl.b)) + ((Workspace.CurrentCamera.CFrame * CFrame.new(flyVars.ctrl.l+flyVars.ctrl.r,(flyVars.ctrl.f+flyVars.ctrl.b)*.2,0).p) - Workspace.CurrentCamera.CFrame.p))*flyVars.speed
            flyVars.lastctrl = {f = flyVars.ctrl.f, b = flyVars.ctrl.b, l = flyVars.ctrl.l, r = flyVars.ctrl.r}
        elseif (flyVars.ctrl.l + flyVars.ctrl.r) == 0 and (flyVars.ctrl.f + flyVars.ctrl.b) == 0 and flyVars.speed ~= 0 then
            flyVars.bv.velocity = ((Workspace.CurrentCamera.CFrame.LookVector * (flyVars.lastctrl.f+flyVars.lastctrl.b)) + ((Workspace.CurrentCamera.CFrame * CFrame.new(flyVars.lastctrl.l+flyVars.lastctrl.r,(flyVars.lastctrl.f+flyVars.lastctrl.b)*.2,0).p) - Workspace.CurrentCamera.CFrame.p))*flyVars.speed
        else
            flyVars.bv.velocity = Vector3.new(0,0.1,0)
        end
        flyVars.bg.cframe = Workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((flyVars.ctrl.f+flyVars.ctrl.b)*50*flyVars.speed/flyVars.maxspeed),0,0)
    until not flyVars.flying
    flyVars.ctrl = {f=0,b=0,l=0,r=0}; flyVars.lastctrl = {f=0,b=0,l=0,r=0}; flyVars.speed = 0
    if flyVars.bg then flyVars.bg:Destroy(); flyVars.bg = nil end
    if flyVars.bv then flyVars.bv:Destroy(); flyVars.bv = nil end
    local char = flyVars.plr.Character
    if char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.PlatformStand = false end
end

flyVars.mouse.KeyDown:Connect(function(k)
    k = tostring(k):lower()
    if k=="e" then flyVars.flying = not flyVars.flying if flyVars.flying then FlyFunc() end
    elseif k=="w" then flyVars.ctrl.f = 1
    elseif k=="s" then flyVars.ctrl.b = -1
    elseif k=="a" then flyVars.ctrl.l = -1
    elseif k=="d" then flyVars.ctrl.r = 1 end
end)
flyVars.mouse.KeyUp:Connect(function(k)
    k = tostring(k):lower()
    if k=="w" then flyVars.ctrl.f = 0
    elseif k=="s" then flyVars.ctrl.b = 0
    elseif k=="a" then flyVars.ctrl.l = 0
    elseif k=="d" then flyVars.ctrl.r = 0 end
end)

pSection:Button({Title="Toggle Fly (E)", Callback=function()
    flyVars.flying = not flyVars.flying
    if flyVars.flying then FlyFunc(); notify("Fly","Fly running (E toggles).",2) else notify("Fly","Fly stopped.",2) end
end})

-- WalkSpeed & JumpPower
local ws = 16
local jp = 50
pSection:Slider({Title="WalkSpeed", Min=8, Max=250, Value=ws, Callback=function(val)
    ws = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = ws end
end})
pSection:Slider({Title="JumpPower", Min=0, Max=300, Value=jp, Callback=function(val)
    jp = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = jp end
end})
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = ws; hum.JumpPower = jp end
end)

-- Infinite Jump
local infJumpEnabled = false
pSection:Toggle({Title="Infinite Jump", Value=false, Callback=function(v) infJumpEnabled = v; notify("Infinite Jump", v and "Enabled" or "Disabled", 2) end})
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Teleport to player (input) + Click TP
TeleportTab:Section({Title="Teleport"})
TeleportTab:Input({Title="Teleport to Player (local)", Placeholder="PlayerName", Callback=function(txt)
    local target = Players:FindFirstChild(txt)
    if target and target.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        notify("Teleport","Teleported to "..txt,3)
    else notify("Teleport","Player not found or not loaded",3) end
end})
local clickTPEnabled = false
TeleportTab:Toggle({Title="Click TP", Value=false, Callback=function(v) clickTPEnabled = v; notify("Click TP", v and "Enabled" or "Disabled", 2) end})
local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if clickTPEnabled and mouse.Target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
    end
end})

-- AntiAFK improved
local AntiAFK = {}
AntiAFK.running = false
AntiAFK.conn = nil
AntiAFK.vu = game:GetService("VirtualUser")
function AntiAFK.enable()
    if AntiAFK.running then return end
    AntiAFK.conn = LocalPlayer.Idled:Connect(function()
        pcall(function() AntiAFK.vu:CaptureController(); AntiAFK.vu:ClickButton2(Vector2.new(0,0)) end)
    end)
    AntiAFK.running = true; notify("AntiAFK","Enabled",2)
end
function AntiAFK.disable()
    if AntiAFK.conn then pcall(function() AntiAFK.conn:Disconnect() end) end
    AntiAFK.conn = nil; AntiAFK.running = false; notify("AntiAFK","Disabled",2)
end
AntiAFK.enable()
pSection:Toggle({Title="AntiAFK", Desc="Prevent idle kick", Value=true, Callback=function(v) if v then AntiAFK.enable() else AntiAFK.disable() end end})

-- VISUALS: ESP (WRD) integration (Studio + Drawing gated)
VisualsTab:Section({Title="ESP & Crosshair"})
_G.WRDESPEnabled = _G.WRDESPEnabled == nil and true or _G.WRDESPEnabled
_G.WRDESPBoxes = _G.WRDESPBoxes == nil and true or _G.WRDESPBoxes
_G.WRDESPTeamColors = _G.WRDESPTeamColors == nil and true or _G.WRDESPTeamColors
_G.WRDESPTracers = _G.WRDESPTracers == nil and false or _G.WRDESPTracers
_G.WRDESPNames = _G.WRDESPNames == nil and true or _G.WRDESPNames

VisualsTab:Toggle({Title="Enable ESP (Studio only)", Value=_G.WRDESPEnabled, Callback=function(v)
    if v and not ALLOW_DEMOS then notify("ESP","Studio only",3); return end
    _G.WRDESPEnabled = v; notify("ESP", v and "Enabled" or "Disabled",2)
end})
VisualsTab:Dropdown({Title="Crosshair", List={"None","Dot","Classic"}, Value="None", Callback=function(v) notify("Crosshair","Selected "..tostring(v),2) end})

do
    if ALLOW_DEMOS and hasDrawing then
        local ESP = { Enabled=false, Boxes=true, BoxShift=CFrame.new(0,-1.5,0), BoxSize=Vector3.new(4,6,0), Color=Color3.fromRGB(255,170,0), FaceCamera=false, Names=true, TeamColor=true, Thickness=2, AttachShift=1, TeamMates=true, Players=true, Objects=setmetatable({}, {__mode="kv"}), Overrides={} }
        local cam = Workspace.CurrentCamera
        local plrs = Players; local plr = LocalPlayer
        local function Draw(obj, props) local ok,new = pcall(function() return Drawing.new(obj) end) if not ok or not new then return nil end for i,v in pairs(props or {}) do new[i]=v end return new end
        local boxBase = {}; boxBase.__index = boxBase
        function boxBase:Remove() ESP.Objects[self.Object]=nil; for i,v in pairs(self.Components) do if v and v.Visible~=nil then v.Visible=false; pcall(function() v:Remove() end) end self.Components[i]=nil end end
        function boxBase:Update()
            if not self.PrimaryPart then return self:Remove() end
            local color = self.Color or ESP.Color
            local allow = true
            if self.Player and not ESP.TeamMates and (ESP:GetTeam(self.Player) == ESP:GetTeam(plr)) then allow = false end
            if self.Player and not ESP.Players then allow = false end
            if not workspace:IsAncestorOf(self.PrimaryPart) then allow = false end
            if not allow then for i,v in pairs(self.Components) do if v and v.Visible~=nil then v.Visible=false end end return end
            local cf = self.PrimaryPart.CFrame
            if ESP.FaceCamera then cf = CFrame.new(cf.p, cam.CFrame.p) end
            local size = self.Size
            local locs = { TopLeft = cf * ESP.BoxShift * CFrame.new(size.X/2,size.Y/2,0), TopRight = cf * ESP.BoxShift * CFrame.new(-size.X/2,size.Y/2,0), BottomLeft = cf * ESP.BoxShift * CFrame.new(size.X/2,-size.Y/2,0), BottomRight = cf * ESP.BoxShift * CFrame.new(-size.X/2,-size.Y/2,0), TagPos = cf * ESP.BoxShift * CFrame.new(0,size.Y/2,0), Torso = cf * ESP.BoxShift }
            if ESP.Boxes and self.Components.Quad then
                local TL,V1 = cam:WorldToViewportPoint(locs.TopLeft.p); local TR,V2 = cam:WorldToViewportPoint(locs.TopRight.p); local BL,V3 = cam:WorldToViewportPoint(locs.BottomLeft.p); local BR,V4 = cam:WorldToViewportPoint(locs.BottomRight.p)
                if V1 or V2 or V3 or V4 then self.Components.Quad.Visible=true; self.Components.Quad.PointA=Vector2.new(TR.X,TR.Y); self.Components.Quad.PointB=Vector2.new(TL.X,TL.Y); self.Components.Quad.PointC=Vector2.new(BL.X,BL.Y); self.Components.Quad.PointD=Vector2.new(BR.X,BR.Y); self.Components.Quad.Color=color else self.Components.Quad.Visible=false end
            elseif self.Components.Quad then self.Components.Quad.Visible=false end
            if ESP.Names and self.Components.Name then local TagPos,V5 = cam:WorldToViewportPoint(locs.TagPos.p) if V5 then self.Components.Name.Visible=true; self.Components.Name.Position=Vector2.new(TagPos.X,TagPos.Y); self.Components.Name.Text=self.Name; self.Components.Name.Color=color; self.Components.Distance.Visible=true; self.Components.Distance.Position=Vector2.new(TagPos.X,TagPos.Y+14); self.Components.Distance.Text = math.floor((cam.CFrame.p - cf.p).Magnitude).."m away"; self.Components.Distance.Color=color else self.Components.Name.Visible=false; self.Components.Distance.Visible=false end end
            if ESP.Tracers and self.Components.Tracer then local TorsoPos,V6 = cam:WorldToViewportPoint(locs.Torso.p) if V6 then self.Components.Tracer.Visible=true; self.Components.Tracer.From=Vector2.new(TorsoPos.X,TorsoPos.Y); self.Components.Tracer.To=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/ESP.AttachShift); self.Components.Tracer.Color=color else self.Components.Tracer.Visible=false end end
        end
        function ESP:Add(obj,options)
            if not obj.Parent and not options.RenderInNil then return end
            local box = setmetatable({ Name = options.Name or obj.Name, Type = "Box", Color = options.Color, Size = options.Size or ESP.BoxSize, Object = obj, Player = options.Player or Players:GetPlayerFromCharacter(obj), PrimaryPart = options.PrimaryPart or (obj.ClassName=="Model" and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart"))) or (obj:IsA("BasePart") and obj), Components = {}, IsEnabled = options.IsEnabled, Temporary = options.Temporary, ColorDynamic = options.ColorDynamic, RenderInNil = options.RenderInNil }, boxBase)
            if ESP:GetBox and ESP:GetBox(obj) then ESP:GetBox(obj):Remove() end
            box.Components["Quad"] = Draw("Quad",{Thickness=ESP.Thickness, Color=box.Color, Transparency=1, Filled=false, Visible=ESP.Enabled and ESP.Boxes})
            box.Components["Name"] = Draw("Text",{Text=box.Name, Color=box.Color, Center=true, Outline=true, Size=19, Visible=ESP.Enabled and ESP.Names})
            box.Components["Distance"] = Draw("Text",{Color=box.Color, Center=true, Outline=true, Size=19, Visible=ESP.Enabled and ESP.Names})
            box.Components["Tracer"] = Draw("Line",{Thickness=ESP.Thickness, Color=box.Color, Transparency=1, Visible=ESP.Enabled and ESP.Tracers})
            ESP.Objects[obj] = box
            obj.AncestryChanged:Connect(function(_,parent) if parent==nil and ESP.AutoRemove~=false then box:Remove() end end)
            obj:GetPropertyChangedSignal("Parent"):Connect(function() if obj.Parent==nil and ESP.AutoRemove~=false then box:Remove() end end)
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum then hum.Died:Connect(function() if ESP.AutoRemove~=false then box:Remove() end end) end
            return box
        end
        local function CharAdded(char)
            local p = Players:GetPlayerFromCharacter(char)
            if not char:FindFirstChild("HumanoidRootPart") then local ev; ev = char.ChildAdded:Connect(function(c) if c.Name=="HumanoidRootPart" then ev:Disconnect(); ESP:Add(char,{Name = p and p.Name or char.Name, Player = p, PrimaryPart = c}) end end) else ESP:Add(char,{Name = p and p.Name or char.Name, Player = p, PrimaryPart = char.HumanoidRootPart}) end
        end
        local function PlayerAdded(p) p.CharacterAdded:Connect(CharAdded); if p.Character then coroutine.wrap(CharAdded)(p.Character) end end
        Players.PlayerAdded:Connect(PlayerAdded)
        for _,v in pairs(Players:GetPlayers()) do if v~=LocalPlayer then PlayerAdded(v) end end
        RunService.RenderStepped:Connect(function() cam = Workspace.CurrentCamera; for _,v in pairs(ESP.Objects) do if v.Update then pcall(function() v:Update() end) end end end)
        task.spawn(function() while true do task.wait(0.1); ESP:Toggle(_G.WRDESPEnabled); ESP.Boxes=_G.WRDESPBoxes; ESP.TeamColor=_G.WRDESPTeamColors; ESP.Tracers=_G.WRDESPTracers; ESP.Names=_G.WRDESPNames end end)
        _G.WRDESPLoaded = true
    else
        -- Not studio or drawing unavailable
    end
end

-- MISC: Noclip + Teleport helpers + Rejoin
MiscTab:Section({Title="Misc Utilities"})
local noclip = false
MiscTab:Toggle({Title="Noclip (local)", Value=false, Callback=function(v) noclip = v; notify("Noclip", v and "Enabled" or "Disabled",2) end})
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _,part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then pcall(function() part.CanCollide = false end) end
        end
    end
end)
MiscTab:Toggle({Title="Infinite Jump", Value=false, Callback=function(v) infJumpEnabled = v; notify("Infinite Jump", v and "Enabled" or "Disabled",2) end})
MiscTab:Button({Title="Manual Rejoin (attempt)", Callback=function() pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end})

-- SETTINGS: executor detector + unload
SettingsTab:Section({Title="UI & Info"})
SettingsTab:Paragraph({Title="Version", Desc="Ronash Hub v2 (safe merged)"})
do
    local detected = "Unknown"
    local function detectExecutor()
        local idfn = (identifyexecutor or identify_executor or getexecutor or get_executor or function() return nil end)
        local ok, name = pcall(function() return idfn() end)
        if ok and name and name ~= "" then detected = tostring(name) else
            local ok2, reg = pcall(function() return debug and debug.getregistry and debug.getregistry() or {} end)
            if ok2 and type(reg) == "table" then
                for k,_ in pairs(reg) do
                    if type(k) == "string" and (k:lower():find("syn") or k:lower():find("krnl") or k:lower():find("comm") or k:lower():find("flux")) then detected = k; break end
                end
            end
        end
    end
    detectExecutor()
    SettingsTab:Label({Title="Executor", Desc=detected})
end
SettingsTab:Button({Title="Unload Ronash Hub", Callback=function() _G.WRDESPEnabled=false; _G.WRDESPLoaded=false; pcall(function() Window:Destroy() end); notify("Ronash Hub","Unloaded",3) end})

-- Final notification
Window:Notify({Title="Ronash Hub", Desc="Loaded (safe merged, aimbot removed)", Time=4})
