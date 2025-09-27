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

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

local Window = Library:Window({
    Title = "Ronash Hub",
    Desc = "Ronash Hub — the best universal script",
    Icon = "rbxassetid://75875011299043",
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.RightControl,
        Size = UDim2.new(0, 575, 0, 387)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "Ronash"
    }
})

-- Main Tab
local MainTab = Window:Tab({Title = "Main", Icon = "star"})
local MainSection = MainTab:Section({Title = "Core Features"})

-- Fly
local flying = false
local ctrl = {f=0,b=0,l=0,r=0}
local lastctrl = {f=0,b=0,l=0,r=0}
local speed=0
local maxspeed=50
local bg=nil
local bv=nil
local plr = game.Players.LocalPlayer
local torso = plr.Character:WaitForChild("Torso")
local mouse = plr:GetMouse()

function Fly()
    bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9,9e9,9e9)
    bg.cframe = torso.CFrame
    bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0,0.1,0)
    bv.maxForce = Vector3.new(9e9,9e9,9e9)
    repeat task.wait()
        plr.Character.Humanoid.PlatformStand = true
        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = math.clamp(speed + 0.5 + speed/maxspeed,0,maxspeed)
        else
            speed = math.max(speed - 1,0)
        end
        if ctrl.l + ctrl.r ~=0 or ctrl.f + ctrl.b ~=0 then
            bv.velocity = ((workspace.CurrentCamera.CFrame.LookVector*(ctrl.f+ctrl.b)) + ((workspace.CurrentCamera.CFrame*CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0)).p - workspace.CurrentCamera.CFrame.p))*speed
            lastctrl = {f=ctrl.f,b=ctrl.b,l=ctrl.l,r=ctrl.r}
        elseif speed ~= 0 then
            bv.velocity = ((workspace.CurrentCamera.CFrame.LookVector*(lastctrl.f+lastctrl.b)) + ((workspace.CurrentCamera.CFrame*CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0)).p - workspace.CurrentCamera.CFrame.p))*speed
        else
            bv.velocity = Vector3.new(0,0.1,0)
        end
        bg.cframe = workspace.CurrentCamera.CFrame*CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
    until not flying
    ctrl={f=0,b=0,l=0,r=0}
    lastctrl={f=0,b=0,l=0,r=0}
    speed=0
    bg:Destroy()
    bv:Destroy()
    plr.Character.Humanoid.PlatformStand=false
end

mouse.KeyDown:Connect(function(key)
    key = key:lower()
    if key=="e" then flying = not flying if flying then Fly() end
    elseif key=="w" then ctrl.f=1
    elseif key=="s" then ctrl.b=-1
    elseif key=="a" then ctrl.l=-1
    elseif key=="d" then ctrl.r=1
    end
end)

mouse.KeyUp:Connect(function(key)
    key=key:lower()
    if key=="w" then ctrl.f=0
    elseif key=="s" then ctrl.b=0
    elseif key=="a" then ctrl.l=0
    elseif key=="d" then ctrl.r=0
    end
end)

MainSection:Toggle({
    Title="Fly",
    Desc="Enable flying",
    Value=false,
    Callback=function(v)
        flying=v
        if v then Fly() end
    end
})

-- AntiAFK
local VirtualUser = game:GetService('VirtualUser')
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

MainSection:Toggle({
    Title="AntiAFK",
    Desc="Prevents idle kick",
    Value=true,
    Callback=function(v) end
})

-- ESP (WRD)
_G.WRDESPEnabled = true
_G.WRDESPBoxes = true
_G.WRDESPTeamColors = true
_G.WRDESPTracers = false
_G.WRDESPNames = true

-- ESP script (full)
do
    local ESP = {Enabled=false,Boxes=true,BoxShift=CFrame.new(0,-1.5,0),BoxSize=Vector3.new(4,6,0),Color=Color3.fromRGB(255,170,0),FaceCamera=false,Names=true,TeamColor=true,Thickness=2,AttachShift=1,TeamMates=true,Players=true,Objects=setmetatable({}, {__mode="kv"}),Overrides={}}
    local cam = workspace.CurrentCamera
    local plrs = game:GetService("Players")
    local plr = plrs.LocalPlayer
    local V3new = Vector3.new
    local WorldToViewportPoint = cam.WorldToViewportPoint
    local function Draw(obj,props)
        local new = Drawing.new(obj)
        for i,v in pairs(props or {}) do new[i]=v end
        return new
    end
    function ESP:GetPlrFromChar(char) return plrs:GetPlayerFromCharacter(char) end
    function ESP:GetTeam(p) return p.Team end
    function ESP:IsTeamMate(p) return self:GetTeam(p)==self:GetTeam(plr) end
    function ESP:GetColor(obj) local p=self:GetPlrFromChar(obj) return p and self.TeamColor and p.Team and p.Team.TeamColor.Color or self.Color end
    function ESP:Toggle(bool) self.Enabled=bool; for i,v in pairs(self.Objects) do if v.Components then for i,vv in pairs(v.Components) do vv.Visible=false end end end end
    function ESP:Add(obj,options)
        if not obj.Parent then return end
        local box = setmetatable({Name=options.Name or obj.Name,Type="Box",Color=options.Color,Size=options.Size or self.BoxSize,Object=obj,Player=options.Player or plrs:GetPlayerFromCharacter(obj),PrimaryPart=options.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"),Components={},IsEnabled=options.IsEnabled,Temporary=options.Temporary,ColorDynamic=options.ColorDynamic,RenderInNil=options.RenderInNil}, {__index={}})
        box.Components["Quad"]=Draw("Quad",{Thickness=self.Thickness,Color=box.Color,Transparency=1,Filled=false,Visible=self.Enabled and self.Boxes})
        box.Components["Name"]=Draw("Text",{Text=box.Name,Color=box.Color,Center=true,Outline=true,Size=19,Visible=self.Enabled and self.Names})
        box.Components["Distance"]=Draw("Text",{Color=box.Color,Center=true,Outline=true,Size=19,Visible=self.Enabled and self.Names})
        box.Components["Tracer"]=Draw("Line",{Thickness=self.Thickness,Color=box.Color,Transparency=1,Visible=self.Enabled and self.Tracers})
        self.Objects[obj]=box
        return box
    end
    game:GetService("RunService").RenderStepped:Connect(function()
        cam=workspace.CurrentCamera
        if ESP.Enabled then
            for i,v in pairs(ESP.Objects) do if v.Update then pcall(v.Update,v) end end
        end
    end)
    while task.wait(.1) do
        ESP:Toggle(_G.WRDESPEnabled)
        ESP.Boxes=_G.WRDESPBoxes
        ESP.TeamColor=_G.WRDESPTeamColors
        ESP.Tracers=_G.WRDESPTracers
        ESP.Names=_G.WRDESPNames
    end
end

MainSection:Toggle({
    Title="ESP",
    Desc="Enable ESP",
    Value=true,
    Callback=function(v)
        _G.WRDESPEnabled=v
    end
})

-- Anti-Cheat
getgenv()["AntiCheatSettings"]={Adonis=true,["HD Admin"]=true}
local Settings={["Adonis"]=true,["HD Admin"]=true}
if Settings["Adonis"] then
    local GetFullName=game.GetFullName
    local Hook
    Hook=hookfunction(getrenv().require,newcclosure(function(...)
        local Args={...}
        if not checkcaller() then
            if GetFullName(getcallingscript())==".ClientMover" and Args[1].Name=="Client" then return wait(1e2) end
        end
        return Hook(unpack(Args))
    end))
end
if Settings["HD Admin"] then
    local Hook
    Hook=hookfunction(getrenv().require,newcclosure(function(...)
        local Args={...}
        if not checkcaller() then
            if getcallingscript().Name=="HDAdminStarterPlayer" and Args[1].Name=="MainFramework" then return wait(1e2) end
        end
        return Hook(unpack(Args))
    end))
end

-- B.A.C Tab
local BACTab = Window:Tab({Title="B.A.C",Icon="tag"})
local BACSection = BACTab:Section({Title="Config"})
BACSection:Toggle({
    Title="B.A.C.R",
    Desc="Enable B.A.C.R",
    Value=false,
    Callback=function(v) end
})