-- =========================
-- RONASH v2🔥 PART 1
-- Loader + Main UI + Fly Tab
-- =========================

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- ===== LOADER =====
local loaderGui=Instance.new("ScreenGui")
loaderGui.Name="RonashLoader"
loaderGui.Parent=game:GetService("CoreGui")

local bg=Instance.new("Frame")
bg.Size=UDim2.new(0,400,0,200)
bg.Position=UDim2.new(0.5,-200,0.5,-100)
bg.BackgroundColor3=Color3.fromRGB(20,20,20)
bg.BorderSizePixel=0
bg.Parent=loaderGui

-- Logo
local logo=Instance.new("ImageLabel")
logo.Size=UDim2.new(0,150,0,150)
logo.Position=UDim2.new(0.5,-75,0,20)
logo.Image="rbxassetid://96680008830476"
logo.BackgroundTransparency=1
logo.Parent=bg

-- Progress Text
local progText = Instance.new("TextLabel")
progText.Size = UDim2.new(0, 300, 0, 20)
progText.Position = UDim2.new(0.5,-150,1,-80)
progText.BackgroundTransparency = 1
progText.Font = Enum.Font.SourceSans
progText.TextSize = 18
progText.TextColor3 = Color3.fromRGB(0,255,255)
progText.Text = "Loading..."
progText.Parent = bg

-- Progress Bar Background
local barBG=Instance.new("Frame")
barBG.Size=UDim2.new(0,300,0,20)
barBG.Position=UDim2.new(0.5,-150,1,-50)
barBG.BackgroundColor3=Color3.fromRGB(60,60,60)
barBG.BorderSizePixel=0
barBG.Parent=bg

-- Progress Fill
local barFill=Instance.new("Frame")
barFill.Size=UDim2.new(0,0,1,0)
barFill.BackgroundColor3=Color3.fromRGB(0,255,255)
barFill.BorderSizePixel=0
barFill.Parent=barBG

-- TweenService for smooth progress
local TweenService=game:GetService("TweenService")
local totalTime=2.5
local steps=50

for i=1,steps do
    local percent=i/steps
    progText.Text = "Loading... "..math.floor(percent*100).."%"
    TweenService:Create(barFill,TweenInfo.new(totalTime/steps,Enum.EasingStyle.Linear),{Size=UDim2.new(percent,0,1,0)}):Play()
    task.wait(totalTime/steps)
end

task.wait(0.5)
loaderGui:Destroy()

-- Ronash Hub v2.0.0.8 (Merged: Fly + Freecam + ESP + Closest-to-cursor Aimbot + Silent Aim demo + Hotkeys)
-- IMPORTANT: Aimbot / Silent Aim / ESP are Studio-only visual/local demos. They do NOT modify server state.

local LOGO_ID = "rbxassetid://75875011299043" -- your logo
local Version = "1.6.51"
local url = "https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"

-- Load WindUI (with retries)
local WindUI
for i = 1, 4 do
    local ok, lib = pcall(function() return loadstring(game:HttpGet(url))() end)
    if ok and lib then WindUI = lib break end
    task.wait(0.15)
end
if not WindUI then warn("Failed to load WindUI"); return end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Allow demos only in Studio for safety
local ALLOW_DEMOS = RunService:IsStudio()
if not ALLOW_DEMOS then
    warn("Aimbot / Silent aim / ESP demos restricted to Studio-only for safety.")
end

-- Window (logo as icon, solid black background)
local Window = WindUI:CreateWindow({
    Title = "Ronash Hub",
    Icon = LOGO_ID,                 -- window icon
    Author = "Ronash",
    Folder = "RonashHub",
    Theme = "Dark",
    Size = UDim2.fromOffset(640, 420),
    Resizable = true,
    SideBarWidth = 180,
    Background = "rbxassetid://0",  -- solid black background
    BackgroundImageTransparency = 0, -- fully opaque black
    Keybind = Enum.KeyCode.RightControl
})

local function notify(t,c,sec) WindUI:Notify({Title = t or "Ronash", Content = c or "", Duration = sec or 3}) end

-- Tabs
local MainTab = Window:Tab({Title="Main", Icon="home"})
local PlayerTab = Window:Tab({Title="Player", Icon="user"})
local CombatTab = Window:Tab({Title="Combat", Icon="sword"})
local VisualsTab = Window:Tab({Title="Visuals", Icon="eye"})
local TeleportTab = Window:Tab({Title="Teleport", Icon="map-pin"})
local MiscTab = Window:Tab({Title="Misc", Icon="layers"})
local SettingsTab = Window:Tab({Title="Settings", Icon="settings"})

-- Main Tab
MainTab:Paragraph({Title="Overview", Desc="Ronash Hub — Studio-safe demos, UI, and local utilities."})
MainTab:Button({Title="Copy Discord Invite", Callback=function() pcall(setclipboard,"https://discord.gg/pvywPyskHT"); notify("Discord","Invite copied",2) end})
MainTab:Button({Title="Spawn Local Demo Marker", Callback=function()
    local cam = workspace.CurrentCamera
    if cam then
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.6,0.6,0.6)
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromRGB(120,200,255)
        part.CFrame = cam.CFrame * CFrame.new(0,0,-6)
        part.Parent = workspace
        notify("Demo","Local marker spawned (3s)",2)
        task.delay(3,function() if part and part.Parent then part:Destroy() end end)
    end
end})

-- -------------------------
-- Player Utilities
-- -------------------------
PlayerTab:Section({Title="Player Utilities (Fly & Freecam - SAFE)"})

-- Freecam (camera-only)
PlayerTab:Button({Title="Freecam (camera-only)", Callback=function()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if cam.CameraType == Enum.CameraType.Scriptable then
        notify("Freecam","Already active.",2); return
    end
    cam.CameraType = Enum.CameraType.Scriptable
    notify("Freecam","Freecam enabled. Press RightShift to exit.",3)
    local startCFrame = cam.CFrame
    local speed = 80
    local move = {W=false,S=false,A=false,D=false,Up=false,Down=false}
    local conn1, conn2, conn3
    conn1 = RunService.RenderStepped:Connect(function(dt)
        local cf = startCFrame
        local dir = Vector3.new((move.D and 1 or 0)-(move.A and 1 or 0),
                                (move.Up and 1 or 0)-(move.Down and 1 or 0),
                                (move.W and -1 or 0)+(move.S and 1 or 0))
        if dir.Magnitude > 0 then dir = dir.Unit end
        startCFrame = startCFrame + cf:VectorToWorldSpace(dir) * speed * dt
        cam.CFrame = startCFrame
    end)
    conn2 = UserInputService.InputBegan:Connect(function(input,gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.W then move.W = true end
        if input.KeyCode == Enum.KeyCode.S then move.S = true end
        if input.KeyCode == Enum.KeyCode.A then move.A = true end
        if input.KeyCode == Enum.KeyCode.D then move.D = true end
        if input.KeyCode == Enum.KeyCode.Space then move.Up = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then move.Down = true end
        if input.KeyCode == Enum.KeyCode.RightShift then
            if conn1 then pcall(function() conn1:Disconnect() end) end
            if conn2 then pcall(function() conn2:Disconnect() end) end
            if conn3 then pcall(function() conn3:Disconnect() end) end
            cam.CameraType = Enum.CameraType.Custom
            notify("Freecam", "Freecam disabled.",2)
        end
    end)
    conn3 = UserInputService.InputEnded:Connect(function(input,gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.W then move.W = false end
        if input.KeyCode == Enum.KeyCode.S then move.S = false end
        if input.KeyCode == Enum.KeyCode.A then move.A = false end
        if input.KeyCode == Enum.KeyCode.D then move.D = false end
        if input.KeyCode == Enum.KeyCode.Space then move.Up = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then move.Down = false end
    end)
end})

-- Spawn Local Fly (your original fly script kept intact)
PlayerTab:Button({Title="Spawn Local Fly (original)", Callback=function()
    task.spawn(function()
        ----------------------------------------------------
        ---  A redistribution of https://wearedevs.net/  ---
        ----------------------------------------------------

        --Waits until the player is in game
        repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Torso") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        local mouse = game.Players.LocalPlayer:GetMouse()

        --Waits until the player's mouse is found
        repeat task.wait() until mouse

        --Variables
        local plr = game.Players.LocalPlayer
        local torso = plr.Character.Torso
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed = 0
        local bg = nil
        local bv = nil

        --Actual flying
        function Fly()
            pcall(function() game.StarterGui:SetCore("SendNotification", {Title="Fly Activated"; Text="WeAreDevs.net"; Duration=1;}) end)
            bg = Instance.new("BodyGyro", torso)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = torso.CFrame
            bv = Instance.new("BodyVelocity", torso)
            bv.velocity = Vector3.new(0,0.1,0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            repeat task.wait()
              plr.Character.Humanoid.PlatformStand = true
              if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed+.5+(speed/maxspeed)
                if speed > maxspeed then
                  speed = maxspeed
                end
              elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                speed = speed-1
                if speed < 0 then
                  speed = 0
                end
              end
              if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
              elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
              else
                bv.velocity = Vector3.new(0,0.1,0)
              end
              bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
            until not flying
            ctrl = {f = 0, b = 0, l = 0, r = 0}
            lastctrl = {f = 0, b = 0, l = 0, r = 0}
            speed = 0
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
            plr.Character.Humanoid.PlatformStand = false
            pcall(function() game.StarterGui:SetCore("SendNotification", {Title="Fly Deactivated"; Text="WeAreDevs.net"; Duration=1;}) end)
        end

        --Controls
        mouse.KeyDown:Connect(function(key)
            if key:lower() == "e" then
                if flying then 
                    flying = false
                else
                    flying = true
                    Fly()
                end
            elseif key:lower() == "w" then
                ctrl.f = 1
            elseif key:lower() == "s" then
                ctrl.b = -1
            elseif key:lower() == "a" then
                ctrl.l = -1
            elseif key:lower() == "d" then
                ctrl.r = 1
            end
        end)

        mouse.KeyUp:Connect(function(key)
            if key:lower() == "w" then
                ctrl.f = 0
            elseif key:lower() == "s" then
                ctrl.b = 0
            elseif key:lower() == "a" then
                ctrl.l = 0
            elseif key:lower() == "d" then
                ctrl.r = 0
            end
        end)

        Fly()
    end)
end})

-- -------------------------
-- Visuals / ESP (Studio-only)
-- -------------------------
VisualsTab:Section({Title="Visuals (ESP - Studio-only)"})
VisualsTab:Button({Title="Start ESP (Studio-only)", Callback=function()
    if not ALLOW_DEMOS then notify("ESP","ESP is Studio-only for safety.",3); return end
    startESP = true
    notify("ESP","ESP will start (if not already).",2)
end})
VisualsTab:Button({Title="Stop ESP", Callback=function()
    stopESP = true
    notify("ESP","ESP will stop.",2)
end})
VisualsTab:Dropdown({Title="Crosshair (local)", Values={"None","Dot","Classic"}, Index=2, Callback=function(v) notify("Crosshair","Selected "..tostring(v),2) end})

-- Drawing & ESP helpers
local hasDrawing = (type(Drawing) == "table" and type(Drawing.new) == "function")
local drawingObjects = {} -- [player] = {box, name}
local espConn
local espRunning = false
local startESP = false
local stopESP = false

local function makeDrawing(typeName)
    if not hasDrawing then return nil end
    local ok, d = pcall(function() return Drawing.new(typeName) end)
    if not ok then return nil end
    return d
end

local function ensurePlayerDrawings(player)
    if drawingObjects[player] then return drawingObjects[player] end
    local box = makeDrawing("Square")
    local name = makeDrawing("Text")
    if box then box.Visible = false; box.Thickness = 2; box.Filled = false end
    if name then name.Visible = false; name.Size = 16; name.Center = true; name.Outline = true end
    drawingObjects[player] = {box = box, name = name}
    return drawingObjects[player]
end

local function cleanupESPDrawings()
    for p,t in pairs(drawingObjects) do
        if t.box and t.box.Remove then pcall(function() t.box:Remove() end) end
        if t.name and t.name.Remove then pcall(function() t.name:Remove() end) end
    end
    drawingObjects = {}
end

local function runESP()
    if not ALLOW_DEMOS or not hasDrawing then return end
    if espRunning then return end
    espRunning = true
    espConn = RunService.RenderStepped:Connect(function()
        if stopESP then
            -- stop request
            stopESP = false
            espRunning = false
            if espConn and espConn.Connected then pcall(function() espConn:Disconnect() end) end
            cleanupESPDrawings()
            return
        end
        if startESP then
            startESP = false -- consumed
        end

        local cam = workspace.CurrentCamera
        if not cam then return end
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                local head = plr.Character:FindFirstChild("Head")
                local topPos = (head and head.Position or hrp.Position) + Vector3.new(0, 0.5, 0)
                local pos, onScreen = cam:WorldToViewportPoint(topPos)
                local tbl = ensurePlayerDrawings(plr)
                if onScreen then
                    -- approximate box size based on distance
                    local dist = (cam.CFrame.Position - hrp.Position).Magnitude
                    local height = math.clamp(300 / math.max(dist,1), 12, 200)
                    local width = height * 0.5
                    tbl.box.Visible = true
                    tbl.box.Size = Vector2.new(width, height)
                    tbl.box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                    tbl.name.Visible = true
                    tbl.name.Position = Vector2.new(pos.X, pos.Y - height/2 - 14)
                    tbl.name.Text = plr.Name
                    -- team color if available
                    if plr.Team then
                        local c = plr.Team.TeamColor.Color
                        tbl.box.Color = c
                        tbl.name.Color = c
                    else
                        tbl.box.Color = Color3.fromRGB(255,170,0)
                        tbl.name.Color = Color3.fromRGB(255,170,0)
                    end
                else
                    if tbl.box then tbl.box.Visible = false end
                    if tbl.name then tbl.name.Visible = false end
                end
            else
                -- hide if no character
                local tbl = drawingObjects[plr]
                if tbl then
                    if tbl.box then tbl.box.Visible = false end
                    if tbl.name then tbl.name.Visible = false end
                end
            end
        end
    end)
end

-- Start a small loop to watch startESP/stopESP flags
task.spawn(function()
    while true do
        task.wait(0.15)
        if startESP and not espRunning then runESP() end
        -- stopESP is handled inside runESP loop
    end
end)

-- -------------------------
-- Combat: Aimbot (closest-to-cursor) & Silent Aim demo
-- -------------------------
CombatTab:Section({Title="Aimbot & Silent Aim (Studio-only visual demos)"})
local aimbotEnabled = false
local silentEnabled = false
local aimbotFOV = 150 -- pixels
local aimbotSmooth = 0.18

-- Drawing objects for aimbot
local drawFOV, drawLine, drawText, silentHitMarker
if hasDrawing then
    drawFOV = makeDrawing("Circle"); if drawFOV then drawFOV.Visible=false; drawFOV.Filled=false; drawFOV.Thickness=2; drawFOV.Color = Color3.fromRGB(255,60,60) end
    drawLine = makeDrawing("Line"); if drawLine then drawLine.Visible=false; drawLine.Thickness=2; drawLine.Color = Color3.fromRGB(0,255,0) end
    drawText = makeDrawing("Text"); if drawText then drawText.Visible=false; drawText.Size=16; drawText.Center=true; drawText.Outline=true end
    silentHitMarker = makeDrawing("Circle"); if silentHitMarker then silentHitMarker.Visible=false; silentHitMarker.Radius=6; silentHitMarker.Thickness=2; silentHitMarker.Color=Color3.fromRGB(255,0,255) end
end

-- UI toggles
CombatTab:Toggle({Title="Enable Aimbot (Studio-only)", Default=false, Callback=function(v)
    if v and not ALLOW_DEMOS then notify("Aimbot","Studio-only for safety.",4); return end
    aimbotEnabled = v
    if drawFOV then drawFOV.Visible = v end
    notify("Aimbot", v and "Aimbot demo enabled." or "Aimbot demo disabled.", 2)
end})

CombatTab:Slider({Title="Aimbot FOV (px)", Min=50, Max=400, Default=aimbotFOV, Callback=function(val) aimbotFOV = val; if drawFOV then drawFOV.Radius = val end end})
CombatTab:Slider({Title="Aimbot Smoothness", Min=0.01, Max=0.9, Default=aimbotSmooth, Callback=function(v) aimbotSmooth = v end})

CombatTab:Toggle({Title="Enable Silent Aim (Studio-only visual)", Default=false, Callback=function(v)
    if v and not ALLOW_DEMOS then notify("Silent Aim","Studio-only for safety.",4); return end
    silentEnabled = v
    notify("Silent Aim", v and "Silent Aim demo enabled." or "Silent Aim demo disabled.", 2)
end})

-- Hotkeys: RightAlt toggles aimbot, RightShift toggles ESP
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        if ALLOW_DEMOS then
            aimbotEnabled = not aimbotEnabled
            if drawFOV then drawFOV.Visible = aimbotEnabled end
            notify("Hotkey","Aimbot "..(aimbotEnabled and "enabled" or "disabled"),1.5)
        else
            notify("Hotkey","Aimbot is Studio-only.",2)
        end
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        if ALLOW_DEMOS then
            -- toggle ESP state by switching flags
            if espRunning then
                stopESP = true
                notify("Hotkey","ESP stopping...",1.5)
            else
                startESP = true
                notify("Hotkey","ESP starting...",1.5)
            end
        else
            notify("Hotkey","ESP is Studio-only.",2)
        end
    end
end)

-- Helper: find nearest player to cursor within FOV px
local function getNearestToCursorWithinFOV(px)
    local cam = workspace.CurrentCamera
    if not cam then return nil, math.huge end
    local mouse = LocalPlayer:GetMouse()
    local best, bestDist = nil, px or math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local hrp = plr.Character.HumanoidRootPart
            local sp, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if d < bestDist then
                    bestDist = d
                    best = plr
                end
            end
        end
    end
    return best, bestDist
end

-- Local mouse connection for silent aim demo (visual-only)
local mouse = LocalPlayer:GetMouse()
local mouseConn = mouse.Button1Down:Connect(function()
    if not silentEnabled or not ALLOW_DEMOS then return end
    local target, _ = getNearestToCursorWithinFOV(9999)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local origin = cam.CFrame.Position
        local direction = (hrp.Position - origin).Unit * 3000
        local ray = Ray.new(origin, direction)
        local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character}, false, true)
        if not hit then pos = hrp.Position end
        if silentHitMarker then
            local screen = cam:WorldToViewportPoint(pos)
            if screen.Z > 0 then
                silentHitMarker.Position = Vector2.new(screen.X, screen.Y)
                silentHitMarker.Visible = true
                task.delay(0.45, function() if silentHitMarker then silentHitMarker.Visible = false end end)
            end
        end
        if drawText then
            local scr = workspace.CurrentCamera:WorldToViewportPoint(pos)
            drawText.Visible = true
            drawText.Position = Vector2.new(scr.X, scr.Y - 14)
            drawText.Text = ("SimHit: %s"):format(target.Name)
            task.delay(0.6, function() if drawText then drawText.Visible = false end end)
        end
    end
end)

-- Render loop for aimbot visuals & studio camera control
local aimConn = RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local m = LocalPlayer:GetMouse()

    -- Update FOV circle
    if drawFOV then
        drawFOV.Position = Vector2.new(m.X, m.Y)
        drawFOV.Radius = aimbotFOV
    end

    -- Aimbot logic (closest-to-cursor)
    if aimbotEnabled and ALLOW_DEMOS then
        local target, dist = getNearestToCursorWithinFOV(aimbotFOV)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local sp, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if drawLine and onScreen then
                drawLine.From = Vector2.new(m.X, m.Y)
                drawLine.To = Vector2.new(sp.X, sp.Y)
                drawLine.Visible = true
            end
            -- Smoothly rotate camera to face target (Studio-only)
            if ALLOW_DEMOS then
                local desired = CFrame.new(cam.CFrame.Position, hrp.Position)
                workspace.CurrentCamera.CFrame = cam.CFrame:Lerp(desired, aimbotSmooth)
            end
        else
            if drawLine then drawLine.Visible = false end
        end
    else
        if drawLine then drawLine.Visible = false end
        if drawFOV then drawFOV.Visible = false end
    end
end)

-- -------------------------
-- Teleport / Misc / Settings / Unload
-- -------------------------
TeleportTab:Section({Title="Teleport (local attempts)"})
TeleportTab:Button({Title="Teleport To Spawn (local)", Callback=function()
    pcall(function()
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("DefaultSpawnLocation")
        if spawn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawn.Position + Vector3.new(0,5,0))
            notify("Teleport","Attempted local teleport to spawn.",3)
        else
            notify("Teleport","Spawn or character missing.",3)
        end
    end)
end})
TeleportTab:Input({Title="Teleport to Player (local attempt)", Placeholder="PlayerName", Callback=function(txt)
    local target = Players:FindFirstChild(txt)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0) end)
        notify("Teleport","Attempted teleport to "..txt,3)
    else
        notify("Teleport","Player not found or missing character.",3)
    end
end})

MiscTab:Section({Title="Misc"})
MiscTab:Toggle({Title="Auto Welcome", Default=true, Callback=function(v) if v then notify("Welcome","Welcome to Ronash Hub — local demos active.",3) end end})
MiscTab:Button({Title="Rejoin (attempt)", Callback=function() pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end})

-- Settings: executor detection + Unload
SettingsTab:Section({Title="UI & Info"})
SettingsTab:Paragraph({Title="Version", Desc="Ronash Hub v2.0.0.8 (studio-safe)"})
local execSection = SettingsTab:Section({Title="Executor Detector"})
local detected = "Unknown"
local function detectExecutor()
    local idfn = (identifyexecutor or identify_executor or getexecutor or get_executor or function() return nil end)
    local ok1, name = pcall(function() return idfn() end)
    if ok1 and name and name ~= "" then detected = tostring(name) else
        local ok2, reg = pcall(function() return debug and debug.getregistry and debug.getregistry() or {} end)
        if ok2 and type(reg) == "table" then
            for k,_ in pairs(reg) do
                if type(k) == "string" and (k:lower():find("syn") or k:lower():find("krnl") or k:lower():find("comm") or k:lower():find("flux")) then
                    detected = k
                    break
                end
            end
        end
    end
end
detectExecutor()
execSection:Label({Title="Executor", Desc=detected})

SettingsTab:Button({Title="Unload Ronash Hub (cleanup)", Callback=function()
    -- disconnect loops
    if aimConn and aimConn.Connected then pcall(function() aimConn:Disconnect() end) end
    if espConn and espConn.Connected then pcall(function() espConn:Disconnect() end) end
    if mouseConn and mouseConn.Connected then pcall(function() mouseConn:Disconnect() end) end
    -- remove drawings
    if hasDrawing then
        pcall(function()
            if drawFOV then drawFOV:Remove() end
            if drawLine then drawLine:Remove() end
            if drawText then drawText:Remove() end
            if silentHitMarker then silentHitMarker:Remove() end
            cleanupESPDrawings()
        end)
    end
    pcall(function() WindUI:Destroy() end)
    notify("Ronash Hub","Unloaded and cleaned.",3)
end})

-- Init UI
Window:Init()
notify("Ronash Hub", "Loaded v2.0.0.8 (studio-safe)", 4)