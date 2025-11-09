-- Ronash Hub v4 Mobile (Red) - Compact (safe name-minified)
local W= "Ronash Hub v4 Mobile (Red)"
local F= "RonashHub_v4_mobile_red"
local P= game:GetService("Players")
local S= game:GetService("StarterGui")
local C= game:GetService("CoreGui")
local U= game:GetService("UserInputService")
local R= game:GetService("RunService")
local Wk= game:GetService("Workspace")
local L= game:GetService("Lighting")
local T= game:GetService("TweenService")
local Tp= game:GetService("TeleportService")

local me=P.LocalPlayer
local cam=Wk.CurrentCamera
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()
local function n(t,s,d) pcall(function() S:SetCore("SendNotification",{Title=tostring(t),Text=tostring(s),Duration=d or 3}) end) end

local win = lib:MakeWindow({Title = W, SubTitle = "by Jonash Studio", SaveFolder = F})
win:AddMinimizeButton({ Button = { Image = "rbxassetid://96680008830476", BackgroundTransparency = 0 }, Corner = { CornerRadius = UDim.new(0,999) } })

local tabs = {}
local names = {
 "Home","MM2","Combat","Teleport","Movement","Visuals","Tools",
 "GunMods","ESP","Aimbot","Knife","Effects","Sounds","Settings","Credits"
}
for i=1,#names do tabs[names[i]] = win:MakeTab({names[i], i==1 and "home" or "star"}) end
win:SelectTab(tabs.Home)

-- persistence state
local st = {
 speed=16, jump=50, fly=false, noclip=false, inf=false,
 esp=false, aim=false, knife=false, gunfov=70, ui=0, theme="Red-Black", rainbow=false, hub=true
}

local function sh() return me and me.Character and me.Character:FindFirstChildOfClass("Humanoid") end
local function hdr(t,tt) t:AddParagraph({tostring(tt),""}) end
local function clr(nm) for _,c in pairs(cam:GetChildren()) do if c.Name==nm then pcall(function() c:Destroy() end) end end end

-- HOME
hdr(tabs.Home,"Welcome","Ronash Hub v4 Mobile (Red) | MM2-only")
tabs.Home:AddButton({"Copy Key Link",function() pcall(function() setclipboard("https://jonashstudio.github.io/Key-system/") end) n("Ronash","Key link copied!",2) end})
tabs.Home:AddToggle({Name="Enable Notifications",Default=true,Callback=function(v) n("Ronash","Notifications "..(v and "enabled" or "disabled"),2) end})
tabs.Home:AddTextBox({Name="Quick Msg",Description="Test",PlaceholderText="Type...",Callback=function(v) n("Home",tostring(v),2) end})

-- MM2 overview
hdr(tabs.MM2,"MM2 Quick","Client-only helpers")
tabs.MM2:AddToggle({Name="Auto Info Track",Default=false,Callback=function(v) n("MM2","Auto info "..(v and "on" or "off"),2) end})
tabs.MM2:AddButton({"Server Info",function() n("MM2",("Place:%s  Job:%s  Players:%d"):format(tostring(game.PlaceId),tostring(game.JobId),#P:GetPlayers()),5) end})

-- COMBAT
hdr(tabs.Combat,"Combat","ESP, Knife, AutoStab, Teleport")
tabs.Combat:AddToggle({Name="ESP",Default=false,Callback=function(v)
 st.esp=v
 if v then
  for _,pl in pairs(P:GetPlayers()) do if pl~=me then pcall(function()
    local c=pl.Character local root=c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChildWhichIsA("BasePart"))
    if root and not cam:FindFirstChild("ESP_"..pl.UserId) then
      local b=Instance.new("BoxHandleAdornment"); b.Name="ESP_"..pl.UserId; b.Adornee=root; b.Size=Vector3.new(2,3,1); b.AlwaysOnTop=true; b.ZIndex=2; b.Color3=Color3.new(0,1,0); b.Transparency=0.5; b.Parent=cam
    end
  end) end end
  n("Combat","ESP enabled",2)
 else clr("ESP_") n("Combat","ESP disabled",2) end
end})
tabs.Combat:AddToggle({Name="Knife Aura",Default=false,Callback=function(v) st.knife=v n("Combat","Knife Aura "..(v and "on" or "off"),2) end})
tabs.Combat:AddToggle({Name="Auto Stab",Default=false,Callback=function(v) st.stab=v n("Combat","Auto Stab "..(v and "on" or "off"),2) end})
tabs.Combat:AddButton({"TP to Nearest (Local)",function()
 local h=sh() if not h or not me.Character or not me.Character:FindFirstChild("HumanoidRootPart") then n("Combat","Char not ready",2) return end
 local near,dist=nil,math.huge
 for _,pl in pairs(P:GetPlayers()) do if pl~=me and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
  local d=(pl.Character.HumanoidRootPart.Position - me.Character.HumanoidRootPart.Position).magnitude
  if d<dist then dist=d near=pl end end end
 if near then pcall(function() me.Character.HumanoidRootPart.CFrame=near.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end) n("Combat","Teleported near "..near.Name,2) else n("Combat","No target",2) end
end})

-- TELEPORT (MM2 map teleports - simulated)
hdr(tabs.Teleport,"Teleports","MM2 places (sim)")
tabs.Teleport:AddButton({"Lobby",function() n("Teleport","Lobby (sim)",2) end})
tabs.Teleport:AddButton({"Knife Room",function() n("Teleport","Knife Room (sim)",2) end})
tabs.Teleport:AddTextBox({Name="Custom x,y,z",PlaceholderText="0,5,0",Callback=function(v)
 local x,y,z=string.match(v,"(-?%d+%.?%d*),%s*(-?%d+%.?%d*),%s*(-?%d+%.?%d*)")
 if x and y and z and me.Character and me.Character:FindFirstChild("HumanoidRootPart") then pcall(function() me.Character.HumanoidRootPart.CFrame=CFrame.new(tonumber(x),tonumber(y),tonumber(z)) end) n("Teleport","Teleported "..v,2) else n("Teleport","Invalid/char not ready",2) end
end})

-- MOVEMENT
hdr(tabs.Movement,"Movement","WalkSpeed Jump Fly Noclip")
tabs.Movement:AddSlider({Name="WalkSpeed",Min=16,Max=200,Increment=1,Default=16,Callback=function(v) st.speed=v n("Movement","WalkSpeed "..v,2) end})
tabs.Movement:AddSlider({Name="JumpPower",Min=50,Max=400,Increment=1,Default=50,Callback=function(v) st.jump=v n("Movement","JumpPower "..v,2) end})
tabs.Movement:AddToggle({Name="Infinite Jump",Default=false,Callback=function(v) st.inf=v n("Movement","Inf Jump "..(v and "on" or "off"),2) end})
tabs.Movement:AddToggle({Name="Noclip",Default=false,Callback=function(v) st.noclip=v n("Movement","Noclip "..(v and "on" or "off"),2) end})
tabs.Movement:AddToggle({Name="Fly",Default=false,Callback=function(v) st.fly=v n("Movement","Fly "..(v and "on" or "off"),2) end})
tabs.Movement:AddButton({"Reset Movement",function() st.speed=16 st.jump=50 local h=sh() if h then pcall(function() h.WalkSpeed=16 h.JumpPower=50 end) end n("Movement","Reset",2) end})

-- VISUALS
hdr(tabs.Visuals,"Visuals","Fullbright Nametags Chams UI")
tabs.Visuals:AddButton({"Fullbright Toggle",function() L.Brightness=(L.Brightness==2 and 0 or 2) n("Visuals","Fullbright toggled",2) end})
tabs.Visuals:AddToggle({Name="Show Names",Default=false,Callback=function(v)
 if v then for _,pl in pairs(P:GetPlayers()) do if pl~=me and pl.Character and not pl.Character:FindFirstChild("RNTag") then local r=pl.Character:FindFirstChild("HumanoidRootPart") if r then local b=Instance.new("BillboardGui"); b.Name="RNTag"; b.Size=UDim2.new(0,120,0,30); b.Adornee=r; b.AlwaysOnTop=true; b.Parent=Wk; local t=Instance.new("TextLabel",b); t.Size=UDim2.new(1,0,1,0); t.BackgroundTransparency=1; t.Text=pl.Name; t.TextScaled=true; t.Font=Enum.Font.GothamBold end end end n("Visuals","Names on",2) else for _,v2 in pairs(Wk:GetChildren()) do if v2:IsA("BillboardGui") and v2.Name=="RNTag" then pcall(function() v2:Destroy() end) end end n("Visuals","Names off",2) end end})
tabs.Visuals:AddToggle({Name="Chams Simple",Default=false,Callback=function(v) n("Visuals","Chams "..(v and "on" or "off"),2) end})
tabs.Visuals:AddSlider({Name="UI Trans",Min=0,Max=1,Increment=0.05,Default=0,Callback=function(v) st.ui=v n("Visuals","UI trans "..v,1) end})

-- TOOLS
hdr(tabs.Tools,"Tools","AutoFarm AutoRespawn Rejoin")
tabs.Tools:AddButton({"Auto Farm (Sim)",function() n("Tools","Auto farm simulated",2) end})
tabs.Tools:AddToggle({Name="Auto Respawn",Default=false,Callback=function(v) n("Tools","AutoRespawn "..(v and "on" or "off"),2) end})
tabs.Tools:AddButton({"QuickSpawnTP",function() if me.Character and me.Character:FindFirstChild("HumanoidRootPart") then pcall(function() me.Character.HumanoidRootPart.CFrame=CFrame.new(0,5,0) end) n("Tools","Teleported spawn",2) else n("Tools","Char not ready",2) end end})
tabs.Tools:AddButton({"Rejoin",function() n("Tools","Rejoining...",2) pcall(function() Tp:RejoinPlaceInstance(game.PlaceId, game.JobId) end) end})
tabs.Tools:AddButton({"Unload Hub",function() n("Ronash","Hub unloaded (visual)",2) end})

-- GUN MODS
hdr(tabs.GunMods,"Gun Mods","FOV Visuals (client)")
tabs.GunMods:AddSlider({Name="Gun FOV",Min=70,Max=250,Increment=1,Default=70,Callback=function(v) st.gunfov=v n("GunMods","Gun FOV "..v,2) end})
tabs.GunMods:AddToggle({Name="No Visual Recoil",Default=false,Callback=function(v) n("GunMods","No recoil "..(v and "on" or "off"),2) end})
tabs.GunMods:AddButton({"Reset GunMods",function() st.gunfov=70 n("GunMods","Reset",2) end})

-- ESP tab (extra tools)
hdr(tabs.ESP,"ESP Tools","Extras for ESP")
tabs.ESP:AddButton({"Clear ESP",function() clr("ESP_") n("ESP","ESP cleared",2) end})
tabs.ESP:AddToggle({Name="ESP Boxes (auto)",Default=false,Callback=function(v) n("ESP","Auto ESP "..(v and "on" or "off"),2) end})
tabs.ESP:AddSlider({Name="ESP Size",Min=1,Max=5,Increment=0.5,Default=2,Callback=function(v) n("ESP","Size "..v,1) end})

-- AIMBOT
hdr(tabs.Aimbot,"Aimbot","Local aim helpers (hold RMB)")
tabs.Aimbot:AddToggle({Name="Enable Aimbot",Default=false,Callback=function(v) st.aim=v n("Aimbot","Aimbot "..(v and "on" or "off"),2) end})
tabs.Aimbot:AddSlider({Name="Smooth",Min=1,Max=30,Increment=1,Default=8,Callback=function(v) st.aimSmooth=v n("Aimbot","Smooth "..v,1) end})
tabs.Aimbot:AddDropdown({Name="Target Part",Options={"Head","HumanoidRootPart"},Default=1,Callback=function(v) st.aimPart=v n("Aimbot","Target "..v,1) end})

-- KNIFE
hdr(tabs.Knife,"Knife","Knife helpers")
tabs.Knife:AddToggle({Name="Knife Aura (Local)",Default=false,Callback=function(v) st.knife=v n("Knife","Knife aura "..(v and "on" or "off"),2) end})
tabs.Knife:AddSlider({Name="Aura Range",Min=2,Max=10,Increment=0.5,Default=3,Callback=function(v) st.knifeRange=v n("Knife","Range "..v,1) end})
tabs.Knife:AddButton({"Fake Stab",function() n("Knife","Fake stab (sim)",2) end})

-- EFFECTS (visual)
hdr(tabs.Effects,"Effects","Lighting & local fx")
tabs.Effects:AddToggle({Name="Rainbow Ambient",Default=false,Callback=function(v) st.rainbow=v if v then spawn(function() while st.rainbow do L.Ambient=Color3.fromHSV((tick()%10)/10,1,1) wait(0.18) end end) end n("Effects","Rainbow "..(v and "on" or "off"),2) end})
tabs.Effects:AddButton({"Spawn Sparkle (Local)",function() n("Effects","Sparkle (sim)",2) end})
tabs.Effects:AddSlider({Name="Bright",Min=0,Max=5,Increment=0.1,Default=1,Callback=function(v) L.Brightness=v n("Effects","Brightness "..v,1) end})

-- SOUNDS (local)
hdr(tabs.Sounds,"Sounds","Local sound play")
tabs.Sounds:AddTextBox({Name="Play ID",Description="rbxassetid://...",PlaceholderText="rbxassetid://...",Callback=function(v) n("Sounds","Play "..tostring(v).." (client)",2) end})
tabs.Sounds:AddButton({"Stop All (Local)",function() n("Sounds","Stopped (client)",2) end})
tabs.Sounds:AddSlider({Name="Volume",Min=0,Max=100,Increment=1,Default=50,Callback=function(v) n("Sounds","Volume "..v,1) end})

-- SETTINGS
hdr(tabs.Settings,"Settings","UI & persistence")
tabs.Settings:AddDropdown({Name="Theme",Options={"Red-Black","Dark","Light"},Default=1,Callback=function(v) st.theme=v n("Settings","Theme set",1) end})
tabs.Settings:AddToggle({Name="Show Sidebar",Default=true,Callback=function(v) n("Settings","Sidebar "..(v and "shown" or "hidden"),1) end})
tabs.Settings:AddSlider({Name="Global UI Trans",Min=0,Max=1,Increment=0.05,Default=0,Callback=function(v) st.ui=v n("Settings","UI UI trans "..v,1) end})
tabs.Settings:AddToggle({Name="Auto Save",Default=true,Callback=function(v) n("Settings","Auto Save "..(v and "on" or "off"),1) end})
tabs.Settings:AddButton({"Reset Defaults",function() st={speed=16,jump=50,fly=false,noclip=false,inf=false,esp=false,aim=false,knife=false,gunfov=70,ui=0,theme="Red-Black",rainbow=false,hub=true} local h=sh() if h then pcall(function() h.WalkSpeed=16 h.JumpPower=50 end) end n("Settings","Reset",2) end})
tabs.Settings:AddButton({"Unload Hub",function() n("Ronash","Hub unloaded (visual)",2) end})

-- CREDITS
hdr(tabs.Credits,"Credits","Jonash Studio — Ronash Hub v4")
tabs.Credits:AddParagraph({"Thanks for using Ronash Hub. Client-side mm2 features only."})
tabs.Credits:AddButton({"Copy Link",function() pcall(function() setclipboard("https://jonashstudio.github.io/") end) n("Credits","Link copied",2) end})

-- Floating circular toggle button (same asset)
do
 local g=Instance.new("ScreenGui"); g.Name="RonashFloatGui"; g.ResetOnSpawn=false; g.Parent=C
 local b=Instance.new("ImageButton"); b.Name="RonashFloat"; b.Size=UDim2.new(0,70,0,70); b.Position=UDim2.new(0,12,0.5,-35); b.AnchorPoint=Vector2.new(0,0.5)
 b.Image="rbxassetid://96680008830476"; b.BackgroundColor3=Color3.fromRGB(25,25,25); b.BackgroundTransparency=0; b.BorderSizePixel=0; b.ZIndex=9999; b.Parent=g; b.AutoButtonColor=true
 local u=Instance.new("UICorner",b); u.CornerRadius=UDim.new(1,0)
 local hi=TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
 local normal={BackgroundColor3=Color3.fromRGB(25,25,25); Size=b.Size}
 local hover={BackgroundColor3=Color3.fromRGB(40,10,10); Size=UDim2.new(0,76,0,76)}
 b.MouseEnter:Connect(function() pcall(function() T:Create(b,hi,hover):Play() end) end)
 b.MouseLeave:Connect(function() pcall(function() T:Create(b,hi,normal):Play() end) end)
 local dragging=false; local ds,sp
 b.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; ds=i.Position; sp=b.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
 U.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-ds; local a=b.Parent.AbsoluteSize; local nx=math.clamp((sp.X.Offset+d.X)/a.X,0,1); local ny=math.clamp((sp.Y.Offset+d.Y)/a.Y,0,1); b.Position=UDim2.new(nx,sp.X.Offset+d.X,ny,sp.Y.Offset+d.Y) end end)
 b.MouseButton1Click:Connect(function() pcall(function() if win.Toggle then win:Toggle() elseif win.Open~=nil then win.Open = not win.Open else local r=C:FindFirstChildWhichIsA("ScreenGui"); if r then r.Enabled = not r.Enabled end end end) st.hub = not st.hub n("Ronash", st.hub and "Hub shown" or "Hub hidden",2) end)
end

-- Runtime handlers
R.RenderStepped:Connect(function()
 if st.noclip and me.Character then for _,p in pairs(me.Character:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.CanCollide=false end) end end end
 local h=sh() if h then pcall(function() h.WalkSpeed=st.speed h.JumpPower=st.jump end) end
end)

U.InputBegan:Connect(function(i,gp) if gp then return end if st.inf and i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==Enum.KeyCode.Space then local h=sh() if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end end end)

game:BindToClose(function() clr("ESP_") for _,v in pairs(Wk:GetChildren()) do if v:IsA("BillboardGui") and v.Name=="RNTag" then pcall(function() v:Destroy() end) end end n("Ronash","Cleaned up",2) end)

n("Ronash","Ronash Hub v4 Mobile (Red) loaded - MM2 only",4)

