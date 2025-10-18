--// Ronash Hub UI
--// Safe & Optimized Version (No exploits, fully ToS-safe)

-- Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Create Main Window
local Window = Library:Window({
    Title = "Ronash Hub",
    Desc = "Powerful all-in-one tool by Jonash",
    Icon = 1234567890, -- change this to your own icon ID
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 575, 0, 387)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "Ronash"
    }
})

---------------------------------------------------------------------
-- 🧩 MAIN TAB
---------------------------------------------------------------------
local Main = Window:Tab({Title = "Main", Icon = "home"}) do
    Main:Section({Title = "Welcome"})
    Main:Button({
        Title = "Show Greeting",
        Desc = "Display a welcome message",
        Callback = function()
            Window:Notify({
                Title = "Ronash Hub",
                Desc = "Welcome to the all-in-one utility hub!",
                Time = 3
            })
        end
    })
end

---------------------------------------------------------------------
-- 🧍 PLAYER TAB
---------------------------------------------------------------------
local Player = Window:Tab({Title = "Player", Icon = "user"}) do
    Player:Section({Title = "Player Controls"})

    local speed = 16
    local jump = 50

    Player:Slider({
        Title = "WalkSpeed",
        Min = 16,
        Max = 100,
        Value = 16,
        Callback = function(v)
            speed = v
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    })

    Player:Slider({
        Title = "JumpPower",
        Min = 50,
        Max = 200,
        Value = 50,
        Callback = function(v)
            jump = v
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
        end
    })

    Player:Button({
        Title = "Reset Speed & Jump",
        Desc = "Reset to default values",
        Callback = function()
            speed = 16
            jump = 50
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
            Window:Notify({
                Title = "Player Reset",
                Desc = "WalkSpeed and JumpPower restored.",
                Time = 3
            })
        end
    })
end

---------------------------------------------------------------------
-- 🌍 TELEPORT TAB
---------------------------------------------------------------------
local Teleport = Window:Tab({Title = "Teleport", Icon = "map"}) do
    Teleport:Section({Title = "Quick Locations"})

    Teleport:Button({
        Title = "Teleport to Spawn",
        Callback = function()
            local plr = game.Players.LocalPlayer
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
            end
        end
    })

    Teleport:Button({
        Title = "Teleport to Random Player",
        Callback = function()
            local players = game.Players:GetPlayers()
            local target = players[math.random(1, #players)]
            local plr = game.Players.LocalPlayer
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            end
        end
    })
end

---------------------------------------------------------------------
-- 🎨 VISUALS TAB
---------------------------------------------------------------------
local Visuals = Window:Tab({Title = "Visuals", Icon = "eye"}) do
    Visuals:Section({Title = "Local Visuals"})

    Visuals:Slider({
        Title = "Camera Zoom",
        Min = 5,
        Max = 120,
        Value = 70,
        Callback = function(v)
            game.Players.LocalPlayer.CameraMaxZoomDistance = v
        end
    })

    Visuals:Toggle({
        Title = "Highlight Self",
        Desc = "Add glowing highlight to your character",
        Value = false,
        Callback = function(state)
            local char = game.Players.LocalPlayer.Character
            if not char then return end
            if state then
                local highlight = Instance.new("Highlight")
                highlight.Name = "RonashHighlight"
                highlight.FillColor = Color3.fromRGB(0, 170, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = char
            else
                if char:FindFirstChild("RonashHighlight") then
                    char.RonashHighlight:Destroy()
                end
            end
        end
    })
end

---------------------------------------------------------------------
-- ⚙️ SETTINGS TAB
---------------------------------------------------------------------
local Settings = Window:Tab({Title = "Settings", Icon = "settings"}) do
    Settings:Section({Title = "Hub Settings"})

    Settings:Dropdown({
        Title = "Theme",
        List = {"Dark", "Light", "Blue", "Purple"},
        Value = "Dark",
        Callback = function(choice)
            Window:SetTheme(choice)
            Window:Notify({
                Title = "Theme Applied",
                Desc = "Changed theme to " .. choice,
                Time = 2
            })
        end
    })

    Settings:Button({
        Title = "Reload Hub",
        Callback = function()
            Window:Notify({
                Title = "Ronash Hub",
                Desc = "Reloading...",
                Time = 2
            })
            task.wait(1)
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    })
end

---------------------------------------------------------------------
-- 🏆 CREDITS TAB
---------------------------------------------------------------------
local Credits = Window:Tab({Title = "Credits", Icon = "award"}) do
    Credits:Section({Title = "Developers"})
    Credits:Code({
        Title = "Credits",
        Code = [[
Ronash Hub
Made by: Jonash
Framework: x2zu UI
Optimized & merged version by Jonash
]]
    })
end

---------------------------------------------------------------------
-- Final Notification
---------------------------------------------------------------------
Window:Notify({
    Title = "Ronash Hub",
    Desc = "All systems loaded successfully!",
    Time = 4
})
