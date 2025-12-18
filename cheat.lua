for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end

local req = (syn and syn.request) or (http and http.request) or http_request

function GetHttp(URL)
	local Data = nil
	local Test = req({
        Url = URL,
        Method = 'GET',
	})
	for i,v in pairs(Test) do
		Data = v
	end
	return Data
end

local Something = GetHttp("https://raw.githubusercontent.com/WMS-Death/bladeball/refs/heads/main/Source.lua")


local Win = loadstring(Something)():Window("Silent Shield", "Blade Ball cheat")
local Ragebot = Win:Tab("Ragebot")
local Credits = Win:Tab("Credits")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local RandRNG = math.random()
local RandAutoaParry = {[tostring(RandRNG)] = false}

Ragebot:Toggle("Auto Parry", false, function(t)
    RandAutoaParry[tostring(RandRNG)] = t
end)

Ragebot:Slider("Parry Base Distance", 0, 100, 0, function(t)
    BaseDistance = t
end)

Ragebot:line()

Ragebot:Toggle("Auto Walk", false, function(t)
    AutoWalk = t
end)

Ragebot:Toggle("Player Saftey", false, function(t)
    PlayerSaftey = t
end)

Ragebot:Slider("Player Saftey Distance", 0, 50, 10, function(v)
    PlayerSaftey_Distance = v
end)

local can_Execute = false
if not getgenv().WalkSpeed_Mana then
    getgenv().WalkSpeed_Mana = 0
    can_Execute = true
else
    can_Execute = false
end

Ragebot:Slider("Walk Speed", 0, 250, 35, function(v)
    getgenv().WalkSpeed_Mana = v
end)

if can_Execute then
    print("executed!")
    spawn(function()
        while task.wait() do
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().WalkSpeed_Mana
            end)
        end
    end)
end

Ragebot:Slider("Auto Walk Distance X", -40, 40, 12, function(t)
    AutoWalkDistanceX = t
end)

Ragebot:Slider("Auto Walk Distance Z", -40, 40, 13, function(t)
    AutoWalkDistanceZ = t
end)

Ragebot:Toggle("Auto Jump", false, function(t)
    AutoDoubleJump = t
end)

Ragebot:line()

Ragebot:Toggle("Aim At Closest Player", false, function(t)
    ClosestPlayer_var = t
end)

Ragebot:Toggle("Random Teleports", false, function(t)
    RandomTeleports = t
end)

Ragebot:Slider("Teleport Distance X", -40, 40, 0, function(t)
    TeleportDistanceX = t
end)

Ragebot:Slider("Teleport Distance Z", -40, 40, 0, function(t)
    TeleportDistanceZ = t
end)

function GetMouse()
    local UserInputService = game:GetService("UserInputService")
    return UserInputService:GetMouseLocation()  -- Ensure this is the correct method for your setup
end

function GetClosestPlayer()
    local closestDistance = math.huge
    local closestTarget = nil
    for _, v in pairs(game:GetService("Workspace").Alive:GetChildren()) do
        if v and v:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer.Character then
            local humanoidRootPart = v.HumanoidRootPart
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude --(Vector2.new(viewportPoint.X, viewportPoint.Y) - mousePos).magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = v
                end
        end
    end
    return closestTarget
end

spawn(function()
    while task.wait() do
        if PlayerSaftey then
            if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end
            pcall(function()
                if (GetClosestPlayer().HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= PlayerSaftey_Distance then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetClosestPlayer().HumanoidRootPart.CFrame * CFrame.new(-25, 0, -PlayerSaftey_Distance)
                end
            end)
        end
    end
end)

function GetBall()
    for i,v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
        if v:IsA("Part") then
            return v
        end
    end
    return nil
end

function GetBallfromplayerPos(Ball)
    return (Ball.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
end

local function getSpeed(part)
    if part:IsA("BasePart") then
        local speed = part.Velocity.Magnitude
        if speed > 1 then
            return part, speed
        end
        return nil, nil
    else
        print("The provided instance is not a BasePart.")
        return nil, nil
    end
end

local function measureVerticalDistance(humanoidRootPart, targetPart)
    local humanoidRootPartY = humanoidRootPart.Position.Y
    local targetPartY = targetPart.Position.Y
    local verticalDistance = math.abs(humanoidRootPartY - targetPartY)
    return verticalDistance
end

function GetHotKey()
	for i,v in pairs(game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame:GetChildren()) do
		if v:IsA("TextLabel") then
			return v.Text
		end
	end
	return ""
end

local text = game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame.F
local KeyCodeBlock = text.Text
text:GetPropertyChangedSignal("Text"):Connect(function()
    KeyCodeBlock = text.Text
end)

local CanSlash = false
local BallSpeed = 0

spawn(function()
    while task.wait() do
        if RandAutoaParry[tostring(RandRNG)] then
            pcall(function()
				for i, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                    if v:IsA("Part") then
                        if not game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then return end
						local part, speed = getSpeed(v)
                        if part and speed then
                            local minDistance = 2.5 * (speed * 0.1) + 2
                            if minDistance == 0 or minDistance <= 20 then
                                BallSpeed = 23
                            elseif minDistance == 20 or minDistance <= 88 then
                                BallSpeed = 2.5 * (speed * 0.1) + 5
                            elseif minDistance == 88 or minDistance <= 110 then
                                BallSpeed = 90
                            -- elseif minDistance >= 110 then
                            --     BallSpeed = 2 * (speed * 0.1)
                            end
							if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude <= (BallSpeed) then -- (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude <= minDistance and 
                                CanSlash = true
                            else
                                CanSlash = false
                            end
						end
                    end
                end
                
                if CanSlash then
                    if math.random(1, 5) == 5 then
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    else
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[KeyCodeBlock], false, game)
                    end
                    CanSlash = false
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoWalk then
            pcall(function()
                if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end
				for i, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                    if v:IsA("Part") then
						local part, speed = getSpeed(v)
                        if part and speed then
							if speed > 5 then
                                if not game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then
                                    game.Players.LocalPlayer.Character.Humanoid:MoveTo(part.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ))
                                else
                                    for i,v in pairs(game:GetService("Workspace").Alive:GetChildren()) do
                                        if game.Players.LocalPlayer.Character.Parent.Name == "Alive" then
                                            if  v ~= game.Players.LocalPlayer.Character then
                                                game.Players.LocalPlayer.Character.Humanoid:MoveTo(v.HumanoidRootPart.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ))
                                            end
                                        end
                                    end
                                end
							end
						end
                    end
                end
            end)
        end
        if AutoDoubleJump then
            pcall(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if ClosestPlayer_var then
            pcall(function()
                if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end
                local OldCameraFrame = workspace.CurrentCamera.CFrame
                local ClosestPlayer = GetClosestPlayer()
                if ClosestPlayer then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, ClosestPlayer.Head.Position)
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(math.random(1,2)) do
        if RandomTeleports then
            pcall(function()
                if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end
                for i, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                    if v:IsA("Part") then
						local part, speed = getSpeed(v)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(TeleportDistanceX, 0, TeleportDistancez)
                    end
                end
            end)
        end
    end
end)

Credits:Button("Developer: thew.bypass", function()
    setclipboard("https://discord.gg/u67zkhS7cF")
end)

Credits:Button("UI Designer: thew.bypass", function()
    setclipboard("https://discord.gg/u67zkhS7cF")
end)

Credits:Button("Silent Shield Discord Server", function()
    setclipboard("https://discord.gg/u67zkhS7cF")
        local req = (syn and syn.request) or (http and http.request) or http_request
        if req then
            req({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = {
                    ['Content-Type'] = 'application/json',
                    Origin = 'https://discord.com'
                },
                Body = game:GetService('HttpService'):JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    nonce = game:GetService('HttpService'):GenerateGUID(false),
                    args = {code = 'u67zkhS7cF'}
                })
            })
        end
end)

local req = (syn and syn.request) or (http and http.request) or http_request
if req then
    req({
        Url = 'http://127.0.0.1:6463/rpc?v=1',
        Method = 'POST',
        Headers = {
            ['Content-Type'] = 'application/json',
            Origin = 'https://discord.com'
        },
        Body = game:GetService('HttpService'):JSONEncode({
            cmd = 'INVITE_BROWSER',
            nonce = game:GetService('HttpService'):GenerateGUID(false),
            args = {code = 'u67zkhS7cF'}
        })
    })
end

Credits:line()

Credits:Button("Destroy Gui", function()
    if game.CoreGui:FindFirstChild("woof") then
           game.CoreGui.woof:Destroy()
    end
end)

Credits:Button("Rejoin", function()
    local ts = game:GetService("TeleportService")
    local p = game:GetService("Players").LocalPlayer
    ts:Teleport(game.PlaceId, p)
end)

Credits:line()