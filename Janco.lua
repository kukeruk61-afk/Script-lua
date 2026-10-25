local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local Emotes = {
    {Name = "Take the L", Id = 83265734904502},
    {Name = "Hit the Griddy", Id = 121966805049108},
    {Name = "Orange Justice", Id = 110146282544198},
    {Name = "Gangnam Style", Id = 115518346414107},
    {Name = "The Floss", Id = 10714340543},
    {Name = "Peter nooooo", Id = 84623954062978},
    {Name = "IShowSpeed Dance", Id = 92618727772186},
    {Name = "Robot", Id = 3338025566},
    {Name = "NBA Monster Dunk", Id = 132748833449150},
    {Name = "Break Dance", Id = 18526288497}
}

local AnimationPacks = {
    ["Adidas Aura"] = {
        Idle = 110211186840347, Idle2 = 114191137265065, Idle3 = 99129837931148,
        Walk = 83842218823011, Run = 118320322718866, Jump = 109996626521204,
        Climb = 97824616490448, Fall = 95603166884636, Swim = 134530128383903,
        SwimIdle = 94922130551805
    },
    ["Adidas Community"] = {
        Idle = 122257458498464, Idle2 = 102357151005774, Idle3 = 89262795687364,
        Walk = 122150855457006, Run = 82598234841035, Jump = 75290611992385,
        Climb = 88763136693023, Fall = 98600215928904, Swim = 133308483266208,
        SwimIdle = 109346520324160
    },
    ["Adidas Sports"] = {
        Idle = 18537376492, Idle2 = 18537371272, Idle3 = 18537374150,
        Walk = 18537392113, Run = 18537384940, Jump = 18537380791,
        Climb = 18537363391, Fall = 18537367238, Swim = 18537389531,
        SwimIdle = 18537387180
    },
    ["NFL Animation"] = {
        Idle = 92080889861410, Idle2 = 74451233229259, Idle3 = 80884010501210,
        Walk = 110358958299415, Run = 117333533048078, Jump = 119846112151352,
        Climb = 134630013742019, Fall = 129773241321032, Swim = 132697394189921,
        SwimIdle = 79090109939093
    },
    ["Ninja"] = {
        Idle = 656117400, Idle2 = 656118341, Idle3 = 886742569,
        Walk = 656121766, Run = 656118852, Jump = 656117878,
        Climb = 656114359, Fall = 656115606, Swim = 656119721,
        SwimIdle = 656121397
    },
    ["Levitation"] = {
        Idle = 616006778, Idle2 = 616008087, Idle3 = 886862142,
        Walk = 616013216, Run = 616010382, Jump = 616008936,
        Climb = 616003713, Fall = 616005863, Swim = 616011509,
        SwimIdle = 616012453
    }
}

local CurrentEmoteIndex = 1
local CurrentTrack = nil
local CurrentPack = nil
local OriginalAnimations = {}

local function SaveOriginalAnimations()
    local character = LocalPlayer.Character
    if not character then return end
    local animate = character:FindFirstChild("Animate")
    if not animate then return end
    if animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation1") then
        OriginalAnimations.idle1 = animate.idle.Animation1.AnimationId
        OriginalAnimations.idle2 = animate.idle.Animation2.AnimationId
    end
    if animate:FindFirstChild("walk") then
        OriginalAnimations.walk = animate.walk:FindFirstChildOfClass("Animation").AnimationId
    end
    if animate:FindFirstChild("run") then
        OriginalAnimations.run = animate.run:FindFirstChildOfClass("Animation").AnimationId
    end
    if animate:FindFirstChild("jump") then
        OriginalAnimations.jump = animate.jump:FindFirstChildOfClass("Animation").AnimationId
    end
    if animate:FindFirstChild("climb") then
        OriginalAnimations.climb = animate.climb:FindFirstChildOfClass("Animation").AnimationId
    end
    if animate:FindFirstChild("fall") then
        OriginalAnimations.fall = animate.fall:FindFirstChildOfClass("Animation").AnimationId
    end
    if animate:FindFirstChild("swim") then
        OriginalAnimations.swim = animate.swim:FindFirstChildOfClass("Animation").AnimationId
        OriginalAnimations.swimidle = animate.swimidle:FindFirstChildOfClass("Animation").AnimationId
    end
    if animate:FindFirstChild("pose") then
        local poseAnim = animate.pose:FindFirstChildOfClass("Animation")
        if poseAnim then
            OriginalAnimations.pose = poseAnim.AnimationId
        end
    end
end

local function ResetAnimations()
    local character = LocalPlayer.Character
    if not character then return end
    local animate = character:FindFirstChild("Animate")
    if not animate then return end
    if OriginalAnimations.idle1 then
        animate.idle.Animation1.AnimationId = OriginalAnimations.idle1
        animate.idle.Animation2.AnimationId = OriginalAnimations.idle2
    end
    if OriginalAnimations.walk then
        animate.walk:FindFirstChildOfClass("Animation").AnimationId = OriginalAnimations.walk
    end
    if OriginalAnimations.run then
        animate.run:FindFirstChildOfClass("Animation").AnimationId = OriginalAnimations.run
    end
    if OriginalAnimations.jump then
        animate.jump:FindFirstChildOfClass("Animation").AnimationId = OriginalAnimations.jump
    end
    if OriginalAnimations.climb then
        animate.climb:FindFirstChildOfClass("Animation").AnimationId = OriginalAnimations.climb
    end
    if OriginalAnimations.fall then
        animate.fall:FindFirstChildOfClass("Animation").AnimationId = OriginalAnimations.fall
    end
    if OriginalAnimations.swim then
        animate.swim:FindFirstChildOfClass("Animation").AnimationId = OriginalAnimations.swim
        animate.swimidle:FindFirstChildOfClass("Animation").AnimationId = OriginalAnimations.swimidle
    end
    if OriginalAnimations.pose then
        animate.pose:FindFirstChildOfClass("Animation").AnimationId = OriginalAnimations.pose
    end
    if animate:FindFirstChild("Disabled") then
        animate.Disabled = false
    end
    CurrentPack = nil
end

local function ApplyAnimationPack(packName)
    local pack = AnimationPacks[packName]
    if not pack then return end
    local character = LocalPlayer.Character
    if not character then
        character = LocalPlayer.CharacterAdded:Wait()
    end
    local animate = character:FindFirstChild("Animate")
    if not animate then return end
    if not next(OriginalAnimations) then
        SaveOriginalAnimations()
    end
    if animate.idle then
        animate.idle.Animation1.AnimationId = "rbxassetid://" .. pack.Idle
        animate.idle.Animation2.AnimationId = "rbxassetid://" .. pack.Idle2
    end
    if animate:FindFirstChild("pose") and pack.Idle3 then
        local poseAnim = animate.pose:FindFirstChildOfClass("Animation")
        if poseAnim then
            poseAnim.AnimationId = "rbxassetid://" .. pack.Idle3
        end
    end
    if animate.walk then
        animate.walk:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. pack.Walk
    end
    if animate.run then
        animate.run:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. pack.Run
    end
    if animate.jump then
        animate.jump:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. pack.Jump
    end
    if animate.climb then
        animate.climb:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. pack.Climb
    end
    if animate.fall then
        animate.fall:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. pack.Fall
    end
    if animate.swim then
        animate.swim:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. pack.Swim
        animate.swimidle:FindFirstChildOfClass("Animation").AnimationId = "rbxassetid://" .. pack.SwimIdle
    end
    animate.Disabled = false
    animate.Disabled = true
    task.wait()
    animate.Disabled = false
    CurrentPack = packName
end

local function StopCurrentEmote()
    if CurrentTrack and CurrentTrack.IsPlaying then
        CurrentTrack:Stop()
        CurrentTrack = nil
    end
    local animate = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Animate")
    if animate then animate.Disabled = false end
end

local function PlayEmote(emoteId)
    local character = LocalPlayer.Character
    if not character then character = LocalPlayer.CharacterAdded:Wait() end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    if CurrentTrack and CurrentTrack.IsPlaying then CurrentTrack:Stop() end
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. emoteId
    CurrentTrack = humanoid:LoadAnimation(anim)
    CurrentTrack:Play()
    CurrentTrack.Looped = true
    CurrentTrack.Priority = Enum.AnimationPriority.Action
    CurrentTrack:AdjustSpeed(1)
    local animate = character:FindFirstChild("Animate")
    if animate then animate.Disabled = true end
end

local existingGui = CoreGui:FindFirstChild("AnimationHub")
if existingGui then existingGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimationHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 200)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Thickness = 1.5
FrameStroke.Color = Color3.fromRGB(40, 40, 40)
FrameStroke.Parent = MainFrame

local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(1, 0, 0, 30)
DragBar.Position = UDim2.new(0, 0, 0, 0)
DragBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DragBar.BorderSizePixel = 0
DragBar.Parent = MainFrame

local DragBarCorner = Instance.new("UICorner")
DragBarCorner.CornerRadius = UDim.new(0, 8)
DragBarCorner.Parent = DragBar

local DragBarStroke = Instance.new("UIStroke")
DragBarStroke.Thickness = 0.5
DragBarStroke.Color = Color3.fromRGB(60, 60, 60)
DragBarStroke.Parent = DragBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -10, 1, 0)
TitleLabel.Position = UDim2.new(0, 5, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 12
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
TitleLabel.Text = "Emotes by sticky"
TitleLabel.Parent = DragBar

local EmojiLabel = Instance.new("TextLabel")
EmojiLabel.Size = UDim2.new(1, -10, 0, 16)
EmojiLabel.Position = UDim2.new(0, 5, 0, 32)
EmojiLabel.BackgroundTransparency = 1
EmojiLabel.Font = Enum.Font.Gotham
EmojiLabel.TextSize = 9
EmojiLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
EmojiLabel.TextXAlignment = Enum.TextXAlignment.Left
EmojiLabel.Text = "discord.gg/Z7vPrxecnJ"
EmojiLabel.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local EmotesTab = Instance.new("TextButton")
EmotesTab.Size = UDim2.new(0.5, -1, 1, 0)
EmotesTab.Position = UDim2.new(0, 0, 0, 0)
EmotesTab.Text = "Emotes"
EmotesTab.TextSize = 12
EmotesTab.TextColor3 = Color3.fromRGB(255, 255, 255)
EmotesTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
EmotesTab.BorderSizePixel = 0
EmotesTab.AutoButtonColor = false
EmotesTab.Parent = TabContainer
local EmotesTabCorner = Instance.new("UICorner")
EmotesTabCorner.CornerRadius = UDim.new(0, 6)
EmotesTabCorner.Parent = EmotesTab

local PacksTab = Instance.new("TextButton")
PacksTab.Size = UDim2.new(0.5, -1, 1, 0)
PacksTab.Position = UDim2.new(0.5, 1, 0, 0)
PacksTab.Text = "Packs"
PacksTab.TextSize = 12
PacksTab.TextColor3 = Color3.fromRGB(200, 200, 200)
PacksTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
PacksTab.BorderSizePixel = 0
PacksTab.AutoButtonColor = false
PacksTab.Parent = TabContainer
local PacksTabCorner = Instance.new("UICorner")
PacksTabCorner.CornerRadius = UDim.new(0, 6)
PacksTabCorner.Parent = PacksTab

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -80)
ContentContainer.Position = UDim2.new(0, 0, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local EmotesContent = Instance.new("Frame")
EmotesContent.Size = UDim2.new(1, 0, 1, 0)
EmotesContent.BackgroundTransparency = 1
EmotesContent.Visible = true
EmotesContent.Parent = ContentContainer

local PacksContent = Instance.new("Frame")
PacksContent.Size = UDim2.new(1, 0, 1, 0)
PacksContent.BackgroundTransparency = 1
PacksContent.Visible = false
PacksContent.Parent = ContentContainer

local LeftArrow = Instance.new("TextButton")
LeftArrow.Size = UDim2.new(0, 30, 0, 30)
LeftArrow.Position = UDim2.new(0, 10, 0.5, -15)
LeftArrow.Text = "◀"
LeftArrow.TextSize = 18
LeftArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftArrow.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
LeftArrow.BorderSizePixel = 0
LeftArrow.AutoButtonColor = false
LeftArrow.Parent = EmotesContent
local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 6)
LeftCorner.Parent = LeftArrow

local EmoteButton = Instance.new("TextButton")
EmoteButton.Size = UDim2.new(0, 120, 0, 40)
EmoteButton.Position = UDim2.new(0.5, -60, 0.5, -20)
EmoteButton.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
EmoteButton.Text = Emotes[CurrentEmoteIndex].Name
EmoteButton.TextSize = 14
EmoteButton.TextColor3 = Color3.fromRGB(255, 100, 100)
EmoteButton.Font = Enum.Font.GothamBold
EmoteButton.BorderSizePixel = 0
EmoteButton.AutoButtonColor = false
EmoteButton.Parent = EmotesContent
local EmoteCorner = Instance.new("UICorner")
EmoteCorner.CornerRadius = UDim.new(0, 6)
EmoteCorner.Parent = EmoteButton

local RightArrow = Instance.new("TextButton")
RightArrow.Size = UDim2.new(0, 30, 0, 30)
RightArrow.Position = UDim2.new(1, -40, 0.5, -15)
RightArrow.Text = "▶"
RightArrow.TextSize = 18
RightArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
RightArrow.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
RightArrow.BorderSizePixel = 0
RightArrow.AutoButtonColor = false
RightArrow.Parent = EmotesContent
local RightCorner = Instance.new("UICorner")
RightCorner.CornerRadius = UDim.new(0, 6)
RightCorner.Parent = RightArrow

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0, 100, 0, 28)
StopButton.Position = UDim2.new(0.5, -50, 1, -36)
StopButton.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
StopButton.Text = "⏹ Stop"
StopButton.TextSize = 12
StopButton.TextColor3 = Color3.fromRGB(255, 100, 100)
StopButton.Font = Enum.Font.GothamBold
StopButton.BorderSizePixel = 0
StopButton.AutoButtonColor = false
StopButton.Parent = EmotesContent
local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 6)
StopCorner.Parent = StopButton

local PackList = Instance.new("ScrollingFrame")
PackList.Size = UDim2.new(1, -20, 1, -45)
PackList.Position = UDim2.new(0, 10, 0, 5)
PackList.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
PackList.BorderSizePixel = 0
PackList.CanvasSize = UDim2.new(0, 0, 0, 0)
PackList.ScrollBarThickness = 6
PackList.Parent = PacksContent
local PackListCorner = Instance.new("UICorner")
PackListCorner.CornerRadius = UDim.new(0, 6)
PackListCorner.Parent = PackList

local PackLayout = Instance.new("UIListLayout")
PackLayout.Padding = UDim.new(0, 5)
PackLayout.SortOrder = Enum.SortOrder.LayoutOrder
PackLayout.Parent = PackList

local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(1, -20, 0, 28)
ResetButton.Position = UDim2.new(0, 10, 1, -36)
ResetButton.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
ResetButton.Text = "Reset Animations"
ResetButton.TextSize = 12
ResetButton.TextColor3 = Color3.fromRGB(255, 100, 100)
ResetButton.Font = Enum.Font.GothamBold
ResetButton.BorderSizePixel = 0
ResetButton.AutoButtonColor = false
ResetButton.Parent = PacksContent
local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 6)
ResetCorner.Parent = ResetButton

local function RefreshPackList()
    for _, child in ipairs(PackList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local yOffset = 0
    for packName, _ in pairs(AnimationPacks) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Text = packName
        btn.TextSize = 12
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = PackList
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        btn.MouseButton1Click:Connect(function()
            ApplyAnimationPack(packName)
            for _, b in ipairs(PackList:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        end)
        yOffset = yOffset + 40
    end
    PackList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

local function SwitchTab(tab)
    if tab == "Emotes" then
        EmotesContent.Visible = true
        PacksContent.Visible = false
        EmotesTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        EmotesTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        PacksTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        PacksTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        EmotesContent.Visible = false
        PacksContent.Visible = true
        EmotesTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        EmotesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
        PacksTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        PacksTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        RefreshPackList()
    end
end

EmotesTab.MouseButton1Click:Connect(function() SwitchTab("Emotes") end)
PacksTab.MouseButton1Click:Connect(function() SwitchTab("Packs") end)

local function CycleEmote(direction)
    CurrentEmoteIndex = CurrentEmoteIndex + direction
    if CurrentEmoteIndex < 1 then
        CurrentEmoteIndex = #Emotes
    elseif CurrentEmoteIndex > #Emotes then
        CurrentEmoteIndex = 1
    end
    local newEmote = Emotes[CurrentEmoteIndex]
    if EmoteButton then
        EmoteButton.Text = newEmote.Name
    end
    PlayEmote(newEmote.Id)
end

local function AnimateButton(button, downColor, upColor)
    local tween = TweenService:Create(button, TweenInfo.new(0.05), {BackgroundColor3 = downColor})
    tween:Play()
    task.delay(0.1, function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = upColor}):Play()
    end)
end

LeftArrow.MouseButton1Click:Connect(function()
    AnimateButton(LeftArrow, Color3.fromRGB(0, 60, 0), Color3.fromRGB(0, 100, 0))
    CycleEmote(-1)
end)
RightArrow.MouseButton1Click:Connect(function()
    AnimateButton(RightArrow, Color3.fromRGB(0, 60, 0), Color3.fromRGB(0, 100, 0))
    CycleEmote(1)
end)
EmoteButton.MouseButton1Click:Connect(function()
    AnimateButton(EmoteButton, Color3.fromRGB(60, 25, 25), Color3.fromRGB(35, 15, 15))
    CycleEmote(0)
end)
StopButton.MouseButton1Click:Connect(function()
    AnimateButton(StopButton, Color3.fromRGB(60, 25, 25), Color3.fromRGB(35, 15, 15))
    StopCurrentEmote()
end)
ResetButton.MouseButton1Click:Connect(function()
    ResetAnimations()
end)

LeftArrow.MouseButton1Enter:Connect(function()
    TweenService:Create(LeftArrow, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 130, 0)}):Play()
end)
LeftArrow.MouseButton1Leave:Connect(function()
    TweenService:Create(LeftArrow, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
end)
RightArrow.MouseButton1Enter:Conne
