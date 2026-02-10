--This is a joinscript that works in 2013 and back, etc. 
-- functions -------------------------- 
function onPlayerAdded(player) 
	-- override 
end 
pcall(function() game:SetPlaceID(1, false) end) 
local startTime = tick() 
local connectResolved = false 
local loadResolved = false 
local joinResolved = false 
local playResolved = true 
local playStartTime = 0 
local cdnSuccess = 0 
local cdnFailure = 0 
settings()["Game Options"].CollisionSoundEnabled = true 
pcall(function() settings().Rendering.EnableFRM = true end) 
pcall(function() settings().Physics.Is30FpsThrottleEnabled = false end) 
pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end) 
pcall(function() settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto end) 
local threadSleepTime = ...  
if threadSleepTime==nil then  
	threadSleepTime = 15  
end  
local test = true  
local closeConnection = game.Close:connect(function()   
	if 0 then  
		if not connectResolved then  
			local duration = tick() - startTime;  
		elseif (not loadResolved) or (not joinResolved) then  
			local duration = tick() - startTime;  
			if not loadResolved then  
				loadResolved = true  
			end  
			if not joinResolved then  
				joinResolved = true  
			end  
		elseif not playResolved then  
			playResolved = true  
		end  
	end  
end)  
game:GetService("ChangeHistoryService"):SetEnabled(false)  
game:GetService("ContentProvider"):SetThreadPool(16)  
game:GetService("InsertService"):SetBaseSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=10&type=base")  
game:GetService("InsertService"):SetUserSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=d")  
game:GetService("InsertService"):SetCollectionUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?sid=d")  
game:GetService("InsertService"):SetAssetUrl("http://www.roblox.com/Asset/?id=d")  
game:GetService("InsertService"):SetAssetVersionUrl("http://www.roblox.com/Asset/?assetversionid=d")  
pcall(function() game:GetService("SocialService"):SetFriendUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=d") end)  
pcall(function() game:GetService("SocialService"):SetBestFriendUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=d") end)  
pcall(function() game:GetService("SocialService"):SetGroupUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=d") end)  
pcall(function() game:GetService("SocialService"):SetGroupRankUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=d") end)  
pcall(function() game:GetService("SocialService"):SetGroupRoleUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=d") end)  
pcall(function() game:GetService("GamePassService"):SetPlayerHasPassUrl("http://www.roblox.com/Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=d") end)  
pcall(function() game:GetService("MarketplaceService"):SetProductInfoUrl("https://api.roblox.com/marketplace/productinfo?assetId=d") end)  
pcall(function() game:GetService("MarketplaceService"):SetPlayerOwnsAssetUrl("https://api.roblox.com/ownership/hasasset?userId=d") end)  
pcall(function() game:SetCreatorID(0, Enum.CreatorType.User) end)  
pcall(function() game:GetService("Players"):SetChatStyle(Enum.ChatStyle.ClassicAndBubble)  
end)  
local waitingForCharacter = false  
pcall( function()  
	if settings().Network.MtuOverride == 0 then  
	  settings().Network.MtuOverride = 1400  
	end  
end)  
client = game:GetService("NetworkClient")  
visit = game:GetService("Visit")  
function setMessage(message)  
	-- todo: animated "..."  
	if not false then  
		game:SetMessage(message)  
	else  
		-- hack, good enought for now  
		game:SetMessage("Teleporting ...")  
	end  
end  
function showErrorWindow(message, errorType, errorCategory)  
	game:SetMessage(message)  
end  
-- called when the client connection closes  
function onDisconnection(peer, lostConnection)  
	if lostConnection then  
		showErrorWindow("You have lost connection", "LostConnection", "LostConnection")  
	else  
		showErrorWindow("This game has been shutdown", "Kick", "Kick")  
	end  
end  
function requestCharacter(replicator)  	
	-- prepare code for when the Character appears  
	local connection  
	connection = player.Changed:connect(function (property)  
		if property=="Character" then  
			game:ClearMessage()  
			waitingForCharacter = false  			
			connection:disconnect() 	 	
			if 0 then  
				if not joinResolved then  
					local duration = tick() - startTime;  
					joinResolved = true  
					playStartTime = tick()  
					playResolved = false  
				end  
			end  
		end  
	end) 	 
	setMessage("Requesting character")  	
	local success, err = pcall(function()  
		replicator:RequestCharacter()  
		setMessage("Waiting for character")  
		waitingForCharacter = true  
	end)  
end  
function onConnectionAccepted(url, replicator)  
	connectResolved = true  
	local waitingForMarker = true 	 
	local success, err = pcall(function()  
		if not test then  
		    visit:SetPing("", 300)  
		end 	 
		if not false then  
			game:SetMessageBrickCount()  
		else  
			setMessage("Teleporting ...")  
		end  
		replicator.Disconnection:connect(onDisconnection)  		
		local marker = replicator:SendMarker()  		
		marker.Received:connect(function()  
			waitingForMarker = false  
			requestCharacter(replicator)  
		end)  
	end) 	 
	if not success then  
		return  
	end 	 
	while waitingForMarker do  
		workspace:ZoomToExtents()  
		wait(0.5)  
	end  
end  
-- called when the client connection fails  
function onConnectionFailed(_, error)  
	showErrorWindow("Failed to connect to the Game. (ID=" .. error .. ")", "ID" .. error, "Other")  
end  
-- called when the client connection is rejected  
function onConnectionRejected()  
	connectionFailed:disconnect()  
	showErrorWindow("This game is not available. Please try another", "WrongVersion", "WrongVersion")  
end  

function checkAndConnect(ipText, playerName)
	local success, err = pcall(function()	  
		game:SetRemoteBuildMode(true) 	 
		setMessage("Connecting to Server")  
		client.ConnectionAccepted:connect(onConnectionAccepted)  
		client.ConnectionRejected:connect(onConnectionRejected)  
		connectionFailed = client.ConnectionFailed:connect(onConnectionFailed)  
		client.Ticket = playerName
		playerConnectSucces, player = pcall(function() return client:PlayerConnect(math.random(5, 999), tostring(ipText), 53640, 0, threadSleepTime) end) 
		-- player changes
		local repStorage = game:GetService("ReplicatedStorage")
		-- fire the username events
		local clientEvents = repStorage:WaitForChild("clientEvents")
		clientEvents:WaitForChild("usernameChange"):FireServer(playerName)

		-- other stuff
		player:SetSuperSafeChat(false)  
		pcall(function() player:SetUnder13(false) end)  
		pcall(function() player:SetMembershipType(Enum.MembershipType.TurboBuildersClub) end)  
		pcall(function() player:SetAccountAge(365) end)  
		--player.Idled:connect(onPlayerIdled)  
		-- Overriden  
		onPlayerAdded(player)  
		--player.CharacterAppearance = ""  
		if not test then visit:SetUploadUrl("")end  	
	end)  

	--finsih
	pcall(function() game:SetScreenshotInfo("") end)  
end

-- this is the part where it creates the website lookin gui


function createAvatarPage()

end

function createGamePage()

end

function createMainFrame()

end


function createIPbox()
	local nameToSet = tostring(math.random(1, 999))
	local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))

	-- create main frame holder
	local mainFrame = Instance.new("Frame", gui)
	mainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
	mainFrame.Size = UDim2.new(0.45, 0, 0.6, 0)
	mainFrame.BackgroundColor3 = Color3.new(1, 1, 1)

	-- create the ip text box
	local box_ip = Instance.new("TextBox", mainFrame)
	box_ip.Font = Enum.Font.SourceSansLight
	box_ip.FontSize = Enum.FontSize.Size18
	box_ip.Text = "localhost"
	box_ip.Position = UDim2.new(0.1, 0, 0.3, 0)
	box_ip.Size = UDim2.new(0.8, 0, 0.15, 0)
	box_ip.ClearTextOnFocus = false
	box_ip.TextScaled = true
	box_ip.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)

	-- create the player name box
	local box_name = Instance.new("TextBox", mainFrame)
	box_name.Font = Enum.Font.SourceSansLight
	box_name.FontSize = Enum.FontSize.Size18
	box_name.Text = "5bigbangs"
	box_name.Position = UDim2.new(0.1, 0, 0.75, 0)
	box_name.Size = UDim2.new(0.8, 0, 0.15, 0)
	box_name.ClearTextOnFocus = false
	box_name.TextScaled = true
	box_name.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)

	-- create the texts
	local text_ip = Instance.new("TextLabel", mainFrame)
	text_ip.Font = Enum.Font.SourceSans
	text_ip.FontSize = Enum.FontSize.Size18
	text_ip.Text = "Type in the SERVER IP ADRESS:"
	text_ip.Position = UDim2.new(0.1, 0, 0.1, 0)
	text_ip.Size = UDim2.new(0.8, 0, 0.15, 0)
	text_ip.TextScaled = true
	text_ip.BackgroundTransparency = 1

	local text_name = Instance.new("TextLabel", mainFrame)
	text_name.Font = Enum.Font.SourceSans
	text_name.FontSize = Enum.FontSize.Size18
	text_name.Text = "Type in your PLAYER NAME:"
	text_name.Position = UDim2.new(0.1, 0, 0.55, 0)
	text_name.Size = UDim2.new(0.8, 0, 0.15, 0)
	text_name.TextScaled = true
	text_name.BackgroundTransparency = 1

	-- connect events
	box_ip.FocusLost:connect(function(enter)
		if enter then
			local text = box_ip.Text
			nameToSet = tostring(box_name.Text)
			gui:Destroy() --just in case
			checkAndConnect(text, nameToSet)
		end
	end)

end

pcall(function() settings().Diagnostics:LegacyScriptMode() end)  
createIPbox()

