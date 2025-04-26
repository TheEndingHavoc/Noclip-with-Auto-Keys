local noclipActive = false
local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local noclipLoop
local keyPressLoop
local VirtualInput = game:GetService("VirtualInputManager")
local keysToPress = {Enum.KeyCode.Q, Enum.KeyCode.E, Enum.KeyCode.R} --keys to loop
local currentKeyIndex = 1

local function disableCollisions()
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function enableCollisions()
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

local function simulateKeyPress(key)
    VirtualInput:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    VirtualInput:SendKeyEvent(false, key, false, game)
end

local function startNoclip()
    if noclipLoop then noclipLoop:Disconnect() end
    if keyPressLoop then keyPressLoop:Disconnect() end

    noclipLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if not noclipActive then return end
        disableCollisions()
        task.wait(0.5) --delay for noclip loop
    end)

    keyPressLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if not noclipActive then return end
        local key = keysToPress[currentKeyIndex]
        simulateKeyPress(key)
        currentKeyIndex = (currentKeyIndex % #keysToPress) + 1 -- Cycle through keys
        task.wait(0.5) --key press delay
    end)
end

local function toggleNoclip()
    noclipActive = not noclipActive
    
    if noclipActive then
        startNoclip()
        print("Noclip: ON | Auto Keys: Q, E, R")
    else
        if noclipLoop then noclipLoop:Disconnect() end
        if keyPressLoop then keyPressLoop:Disconnect() end
        enableCollisions()
        print("Noclip: OFF | Key presses stopped")
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    if noclipActive then
        disableCollisions()
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
        toggleNoclip()
    end
end)

print("Advanced Noclip loaded. Press N to toggle.")