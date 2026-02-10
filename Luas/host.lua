
-- start the server
Port = 53640 
Server =  game:GetService("NetworkServer") 
HostService = game:GetService("RunService") 

Server:Start(Port, 20)

-- enable physics and such
game:GetService("RunService"):Run() 
print("Rowritten server started!")

function createClientRemotes()
    -- create events folder
    local events = Instance.new("Folder")
    events.Name = "clientEvents"

    -- username event
    local userEvent = Instance.new("RemoteEvent")
    userEvent.Name = "usernameChange"
    userEvent.Parent = events

    userEvent.OnServerEvent:connect(function(player, newValue)
        local val = player:WaitForChild("actualUsername")
        val.Value = newValue
    end)

    -- finish
    events.Parent = game:GetService("ReplicatedStorage")
end

function loadBodyColors(player)
    repeat
        wait()
    until player.Character and player.Character.Humanoid and player.Character.Humanoid.Health > 0
    local character = player.Character
    local bodyColors = player:FindFirstChild("bodyColors")
    if bodyColors then
        -- go thru every part and check if it exists in the colors model
        for _, v in pairs(character:GetChildren()) do
            local color = bodyColors:FindFirstChild(v.Name)
            if color then
                -- set the color
                v.BrickColor = color.Value
            end
        end
    end
end

function createPlayerStuff(player)
    -- create body colors
    if not player:FindFirstChild("bodyColors") then
        local bodyColors = Instance.new("Model")
        bodyColors.Name = "bodyColors"

        -- create colors
        local colorValue = Instance.new("BrickColorValue", bodyColors)
        colorValue.Value = BrickColor.new(23)
        colorValue.Name = "Torso"

        local colorValue = Instance.new("BrickColorValue", bodyColors)
        colorValue.Value = BrickColor.new(24)
        colorValue.Name = "Head"

        local colorValue = Instance.new("BrickColorValue", bodyColors)
        colorValue.Value = BrickColor.new(119)
        colorValue.Name = "Left Leg"

        local colorValue = Instance.new("BrickColorValue", bodyColors)
        colorValue.Value = BrickColor.new(119)
        colorValue.Name = "Right Leg"

        local colorValue = Instance.new("BrickColorValue", bodyColors)
        colorValue.Value = BrickColor.new(24)
        colorValue.Name = "Left Arm"

        local colorValue = Instance.new("BrickColorValue", bodyColors)
        colorValue.Value = BrickColor.new(24)
        colorValue.Name = "Right Arm"

        -- finish
        bodyColors.Parent = player
    end
    -- create fake actual username
     if not player:FindFirstChild("actualUsername") then
        local username = Instance.new("StringValue")
        username.Name = "actualUsername"
        username.Value = "Player" -- "Guest"..math.random(128, 9999)
        username.Parent = player
     end
end

-- control player respawning
function onJoined(player)
    -- set up stuff
    createPlayerStuff(player)
    wait(0.1)
    -- spawn in
    player:LoadCharacter(true)
    loadBodyColors(player)
    -- handle respawning
    while wait() do 
        if player.Character.Humanoid.Health == 0 then 
            wait(5) 
            player:LoadCharacter(true)
            loadBodyColors(player)
        elseif player.Character.Parent  == nil then 
            wait(5) 
            player:LoadCharacter(true)
            loadBodyColors(player)
        end 
    end 
end 

createClientRemotes()
-- events
game.Players.PlayerAdded:connect(onJoined) 
