--=====================================================================
--  ███╗   ██╗██╗   NL · Modern Smooth UI  (v8 — stable)
--  ████╗  ██║██║   RightCtrl (PC) / bottom-left NL dot (mobile)
--  ██╔██╗ ██║██║   RMB / long-press → settings
--  ██║╚██╗██║██║   Single LocalScript · Delta Mobile
--  ██║ ╚████║███████╗
--  ╚═╝  ╚═══╝╚══════╝
--=====================================================================

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local Lighting     = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local LP           = Players.LocalPlayer

--=====================================================================
--  UTIL
--=====================================================================
local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local EASE_OUT  = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local EASE_SOFT = TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function Tw(obj, info, props)
    if not obj or not obj.Parent then return end
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function round(num, step)
    step = step or 1
    return math.floor(num / step + 0.5) * step
end

-- расширенная проверка тач-устройства
local function isTouchDevice()
    local ok, val = pcall(function()
        return UIS.TouchEnabled and not UIS.MouseEnabled
    end)
    if ok then return val end
    return UIS.TouchEnabled
end

--=====================================================================
--  PARENT RESOLUTION  ← ГЛАВНЫЙ ФИКС
--=====================================================================
local function resolveParent()
    -- 1. gethui
    if type(gethui) == "function" then
        local ok, res = pcall(gethui)
        if ok and typeof(res) == "Instance" then return res end
    end
    -- 2. get_hidden_gui
    if type(get_hidden_gui) == "function" then
        local ok, res = pcall(get_hidden_gui)
        if ok and typeof(res) == "Instance" then return res end
    end
    -- 3. PlayerGui (гарантированно работает)
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if pg then return pg end
    local ok, pg2 = pcall(function()
        return LP:WaitForChild("PlayerGui", 5)
    end)
    if ok and pg2 then return pg2 end
    -- 4. Последний fallback — CoreGui через pcall
    local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and cg then return cg end
    return game:GetService("Players")
end

local parent = resolveParent()

--=====================================================================
--  CONFIG
--=====================================================================
local DEFAULT = {
    Fullbright   = { Enabled=false, Brightness=2, TimeOfDay=14, Key="F", Mode="Toggle" },
    WalkSpeed    = { Enabled=false, Value=32,  Key="V", Mode="Toggle" },
    JumpPower    = { Enabled=false, Value=60,  Key="J", Mode="Toggle" },
    InfiniteJump = { Enabled=false, Key="I", Mode="Toggle" },
    NoFog        = { Enabled=false, Key="H", Mode="Toggle" },
    PlayerESP    = { Enabled=false, Key="E", Mode="Toggle" },
    UI           = { XS=0.5, XO=-230, YS=0.5, YO=-155 },
    FAB          = { XS=0,   XO=12,   YS=1,   YO=-60  },
    Sound        = { Enabled=true, Volume=0.5 },
}

local Config = HttpService:JSONDecode(HttpService:JSONEncode(DEFAULT))
local CFG_FILE = "NL_Config.json"
local hasFS = (type(writefile) == "function"
    and type(readfile) == "function"
    and type(isfile) == "function")

local notify, applyAll, openSettings, closePopup

local function ensureUI()
    if type(Config.UI) ~= "table" then Config.UI = { XS=0.5, XO=-230, YS=0.5, YO=-155 } end
    local dUI = { XS=0.5, XO=-230, YS=0.5, YO=-155 }
    for k, v in pairs(dUI) do
        if type(Config.UI[k]) ~= "number" then Config.UI[k] = v end
    end

    if type(Config.FAB) ~= "table" then Config.FAB = { XS=0, XO=12, YS=1, YO=-60 } end
    local dFAB = { XS=0, XO=12, YS=1, YO=-60 }
    for k, v in pairs(dFAB) do
        if type(Config.FAB[k]) ~= "number" then Config.FAB[k] = v end
    end

    if type(Config.Sound) ~= "table" then Config.Sound = { Enabled=true, Volume=0.5 } end
    if type(Config.Sound.Enabled) ~= "boolean" then Config.Sound.Enabled = true end
    if type(Config.Sound.Volume) ~= "number" then Config.Sound.Volume = 0.5 end
end

local savePending = false
local function saveCfgDebounced()
    if savePending then return end
    savePending = true
    task.delay(0.6, function()
        savePending = false
        if hasFS then
            pcall(function() writefile(CFG_FILE, HttpService:JSONEncode(Config)) end)
        end
    end)
end

local function saveCfg(silent)
    if hasFS then
        pcall(function() writefile(CFG_FILE, HttpService:JSONEncode(Config)) end)
    end
    if not silent and notify then notify("Saved", "Configuration stored", 2) end
end

local function loadCfg(silent)
    if not hasFS then
        if not silent and notify then notify("Config", "Filesystem unavailable", 2) end
        return
    end
    local ok = pcall(function()
        if isfile(CFG_FILE) then
            local data = HttpService:JSONDecode(readfile(CFG_FILE))
            for k, v in pairs(data) do
                if type(Config[k]) == "table" and type(v) == "table" then
                    for k2, v2 in pairs(v) do Config[k][k2] = v2 end
                end
            end
        end
    end)
    ensureUI()
    if not silent and notify then
        notify("Config", ok and "Loaded" or "Load failed", 2)
    end
end

local function resetCfg()
    local savedUI = Config.UI
    local savedFAB = Config.FAB
    local savedSound = Config.Sound
    Config = HttpService:JSONDecode(HttpService:JSONEncode(DEFAULT))
    Config.UI = savedUI or DEFAULT.UI
    Config.FAB = savedFAB or DEFAULT.FAB
    Config.Sound = savedSound or DEFAULT.Sound
    ensureUI()
    saveCfg(true)
    if notify then notify("Config", "Reset to defaults", 2) end
end

local function resetBinds()
    for k, v in pairs(DEFAULT) do
        if Config[k] and type(v) == "table" and v.Key then
            Config[k].Key = v.Key
            Config[k].Mode = v.Mode
        end
    end
    saveCfg(true)
    if notify then notify("Binds", "All keybinds reset", 2) end
end

ensureUI()

--=====================================================================
--  ROOT
--=====================================================================
local running = true
local listeningKey = false
local activeKBConn = nil
local activeSliderUpdate = nil

local ScreenGui = Create("ScreenGui", {
    Name = "NL_UI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    DisplayOrder = 999,                    -- ← ФИКС: поверх других UI
    Enabled = true,
}, parent)

--=====================================================================
--  SOUND SYSTEM  ← ФИКС: workspace + built-in assets + pcall
--=====================================================================
local SoundFolder = Create("Folder", { Name = "NL_SoundFolder" }, workspace)

-- Только встроенные rbxasset:// — не зависят от каталога
local SFX = {
    Click    = "rbxasset://sounds/clickfast.wav",
    ToggleOn = "rbxasset://sounds/electronicpingshort.wav",
    ToggleOff= "rbxasset://sounds/electronicpingshort.wav",
    Switch   = "rbxasset://sounds/clickfast.wav",
    Open     = "rbxasset://sounds/electronicpingshort.wav",
    Close    = "rbxasset://sounds/electronicpingshort.wav",
    Notify   = "rbxasset://sounds/electronicpingshort.wav",
}

local function playSound(id, volume, pitch)
    pcall(function()
        if not Config.Sound or not Config.Sound.Enabled then return end
        if not SoundFolder or not SoundFolder.Parent then return end

        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = (Config.Sound.Volume or 0.5) * (volume or 1)
        s.PlaybackSpeed = pitch or 1
        s.Parent = SoundFolder

        s:Play()

        local destroyed = false
        local function cleanup()
            if destroyed then return end
            destroyed = true
            pcall(function() s:Destroy() end)
        end
        pcall(function() s.Ended:Connect(cleanup) end)
        task.delay(3, cleanup)
    end)
end

local function sfxClick()    playSound(SFX.Click,     0.7, 1.00) end
local function sfxToggleOn() playSound(SFX.ToggleOn,  0.6, 1.20) end
local function sfxToggleOff()playSound(SFX.ToggleOff, 0.6, 0.85) end
local function sfxSwitch()   playSound(SFX.Switch,    0.55, 1.30) end
local function sfxOpen()     playSound(SFX.Open,      0.6, 1.10) end
local function sfxClose()    playSound(SFX.Close,     0.6, 0.80) end
local function sfxNotify()   playSound(SFX.Notify,    0.5, 1.40) end

--=====================================================================
--  NOTIFICATIONS
--=====================================================================
local notifHolder = Create("Frame", {
    Size = UDim2.new(0, 240, 1, -30),
    Position = UDim2.new(1, -250, 0, 15),
    BackgroundTransparency = 1,
    ZIndex = 100,
}, ScreenGui)
Create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Top,
}, notifHolder)

-- ← ФИКС: не используем CanvasGroup, просто Frame
notify = function(title, text, dur)
    if not notifHolder or not notifHolder.Parent then return end
    dur = dur or 2.5
    sfxNotify()

    local card = Create("Frame", {
        Size = UDim2.new(0, 240, 0, 46),
        BackgroundColor3 = Color3.fromRGB(20, 20, 32),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 100,
    }, notifHolder)
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}, card)

    local stroke = Create("UIStroke",
        {Color = Color3.fromRGB(70, 60, 130), Thickness = 1, Transparency = 1}, card)

    local accent = Create("Frame", {
        Size = UDim2.new(0, 3, 1, -14),
        Position = UDim2.new(0, 7, 0, 7),
        BackgroundColor3 = Color3.fromRGB(155, 108, 255),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 2)}, accent)

    local t1 = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 16),
        Position = UDim2.new(0, 18, 0, 6),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = title, TextColor3 = Color3.fromRGB(240, 240, 250),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
    }, card)
    local t2 = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 14),
        Position = UDim2.new(0, 18, 0, 22),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = text, TextColor3 = Color3.fromRGB(150, 150, 175),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
    }, card)

    Tw(card, EASE_SOFT, {BackgroundTransparency = 0})
    Tw(stroke, EASE_SOFT, {Transparency = 0})
    Tw(accent, EASE_SOFT, {BackgroundTransparency = 0})
    Tw(t1, EASE_SOFT, {TextTransparency = 0})
    Tw(t2, EASE_SOFT, {TextTransparency = 0})

    task.delay(dur, function()
        if not card.Parent then return end
        Tw(card, EASE_SOFT, {BackgroundTransparency = 1})
        Tw(stroke, EASE_SOFT, {Transparency = 1})
        Tw(accent, EASE_SOFT, {BackgroundTransparency = 1})
        Tw(t1, EASE_SOFT, {TextTransparency = 1})
        Tw(t2, EASE_SOFT, {TextTransparency = 1})
        task.wait(0.34)
        if card.Parent then card:Destroy() end
    end)
end

--=====================================================================
--  MAIN WINDOW
--=====================================================================
local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 460, 0, 310),
    Position = UDim2.new(Config.UI.XS, Config.UI.XO, Config.UI.YS, Config.UI.YO),
    BackgroundColor3 = Color3.fromRGB(14, 14, 21),
    BorderSizePixel = 0,
    Visible = true,                          -- ← ФИКС: явно видимо
    ZIndex = 10,
}, ScreenGui)
Create("UICorner", {CornerRadius = UDim.new(0, 12)}, Main)
Create("UIStroke",
    {Color = Color3.fromRGB(52, 48, 82), Thickness = 1,
     ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, Main)
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 20)),
    },
    Rotation = 90,
}, Main)

local orb = Create("Frame", {
    Size = UDim2.new(0, 220, 0, 220),
    Position = UDim2.new(0, -80, 0, -80),
    BackgroundColor3 = Color3.fromRGB(155, 108, 255),
    BorderSizePixel = 0,
    BackgroundTransparency = 0.92,
    ZIndex = 0,
}, Main)
Create("UICorner", {CornerRadius = UDim.new(1, 0)}, orb)

local glow = Create("Frame", {
    Size = UDim2.new(1, -24, 0, 1),
    Position = UDim2.new(0, 12, 0, 38),
    BackgroundColor3 = Color3.fromRGB(155, 108, 255),
    BorderSizePixel = 0,
    ZIndex = 3,
}, Main)
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 108, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(155, 108, 255)),
    },
    Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.25),
        NumberSequenceKeypoint.new(1, 1),
    },
}, glow)

--=====================================================================
--  TOP BAR
--=====================================================================
local TopBar = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Active = true,
}, Main)

local LogoLabel = Create("TextLabel", {
    Size = UDim2.new(0, 40, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "NL",
    TextColor3 = Color3.fromRGB(240, 240, 250),
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, TopBar)
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 160, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255)),
    },
}, LogoLabel)
Create("TextLabel", {
    Size = UDim2.new(0, 120, 1, 0),
    Position = UDim2.new(0, 48, 0, 1),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "• modern",
    TextColor3 = Color3.fromRGB(120, 120, 145),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, TopBar)

local function makeTopBtn(text, xOffset, danger)
    local b = Create("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, xOffset, 0, 7),
        BackgroundColor3 = Color3.fromRGB(26, 26, 40),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 6,
    }, TopBar)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, b)
    Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, b)
    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = text,
        TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 12,
    }, b)
    local function enter()
        Tw(b, EASE_OUT, {
            BackgroundTransparency = 0,
            BackgroundColor3 = danger and Color3.fromRGB(90, 30, 45)
                or Color3.fromRGB(45, 45, 65)
        })
        Tw(lbl, EASE_OUT, {TextColor3 = Color3.fromRGB(255, 255, 255)})
    end
    local function leave()
        Tw(b, EASE_OUT, {
            BackgroundTransparency = 0.2,
            BackgroundColor3 = Color3.fromRGB(26, 26, 40)
        })
        Tw(lbl, EASE_OUT, {TextColor3 = Color3.fromRGB(200, 200, 220)})
    end
    b.MouseEnter:Connect(enter)
    b.MouseLeave:Connect(leave)
    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then enter() end
    end)
    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then leave() end
    end)
    b.MouseButton1Click:Connect(sfxClick)
    return b
end

local CloseBtn = makeTopBtn("✕", -32, true)
local MinBtn   = makeTopBtn("—", -60, false)

--=====================================================================
--  SIDEBAR
--=====================================================================
local Sidebar = Create("Frame", {
    Size = UDim2.new(0, 122, 1, -50),
    Position = UDim2.new(0, 10, 0, 42),
    BackgroundColor3 = Color3.fromRGB(19, 19, 30),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ZIndex = 2,
}, Main)
Create("UICorner", {CornerRadius = UDim.new(0, 10)}, Sidebar)
Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, Sidebar)
Create("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, Sidebar)
Create("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6),
}, Sidebar)

local Content = Create("Frame", {
    Size = UDim2.new(1, -150, 1, -56),
    Position = UDim2.new(0, 140, 0, 46),
    BackgroundTransparency = 1,
    ZIndex = 2,
    ClipsDescendants = true,
}, Main)

--=====================================================================
--  TABS
--=====================================================================
local pages, tabs = {}, {}
local activeTab = nil

local function switchTab(name)
    if activeTab == name then return end
    activeTab = name
    for n, page in pairs(pages) do
        if n == name then
            page.Visible = true
            page.Position = UDim2.new(0, 10, 0, 0)
            Tw(page, EASE_SOFT, {Position = UDim2.new(0, 0, 0, 0)})
        else
            page.Visible = false
        end
    end
    for n, btn in pairs(tabs) do
        local isActive = (n == name)
        Tw(btn.bg, EASE_OUT, {
            BackgroundTransparency = isActive and 0 or 0.35,
            BackgroundColor3 = isActive and Color3.fromRGB(34, 30, 55)
                or Color3.fromRGB(22, 22, 34)
        })
        Tw(btn.bar, EASE_OUT, {BackgroundTransparency = isActive and 0 or 1})
        Tw(btn.lbl, EASE_OUT, {
            TextColor3 = isActive and Color3.fromRGB(240, 240, 250)
                or Color3.fromRGB(150, 150, 175)
        })
    end
end

local function makeTab(name, icon)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Color3.fromRGB(22, 22, 34),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, Sidebar)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, btn)
    Create("UIStroke", {Color = Color3.fromRGB(42, 42, 62), Thickness = 1, Transparency = 0.3}, btn)

    local bar = Create("Frame", {
        Size = UDim2.new(0, 3, 0, 14),
        Position = UDim2.new(0, 5, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(155, 108, 255),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
    }, btn)
    Create("UICorner", {CornerRadius = UDim.new(0, 2)}, bar)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 160, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 200, 255)),
        },
        Rotation = 90,
    }, bar)

    Create("TextLabel", {
        Size = UDim2.new(0, 16, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = icon,
        TextColor3 = Color3.fromRGB(180, 180, 210),
        TextSize = 12,
    }, btn)

    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, -28, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = Color3.fromRGB(150, 150, 175),
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, btn)

    local function enter()
        if activeTab ~= name then
            Tw(btn, EASE_OUT, {BackgroundTransparency = 0,
                BackgroundColor3 = Color3.fromRGB(28, 28, 44)})
        end
    end
    local function leave()
        if activeTab ~= name then
            Tw(btn, EASE_OUT, {BackgroundTransparency = 0.35,
                BackgroundColor3 = Color3.fromRGB(22, 22, 34)})
        end
    end
    btn.MouseEnter:Connect(enter)
    btn.MouseLeave:Connect(leave)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then enter() end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then leave() end
    end)
    btn.MouseButton1Click:Connect(function()
        if activeTab == name then return end
        sfxSwitch()
        switchTab(name)
    end)

    local page = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110),
        ScrollBarImageTransparency = 0.4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, Content)
    Create("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    Create("UIPadding", {
        PaddingRight = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 10),
    }, page)

    pages[name] = page
    tabs[name] = {bg = btn, bar = bar, lbl = lbl}
    return page
end

--=====================================================================
--  TOGGLE
--=====================================================================
local function makeToggle(parent, getVal, setVal, shouldSuppress)
    local t = Create("TextButton", {
        Size = UDim2.new(0, 36, 0, 18),
        BackgroundColor3 = Color3.fromRGB(35, 35, 52),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, parent)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, t)
    local stroke = Create("UIStroke", {Color = Color3.fromRGB(60, 60, 85), Thickness = 1}, t)

    local fill = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(120, 80, 230),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 1,
    }, t)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)

    local knob = Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(200, 200, 220),
        BorderSizePixel = 0,
        ZIndex = 3,
    }, t)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)

    local function update(anim)
        local on = getVal()
        local knobPos = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local knobCol = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 220)
        local strokeCol = on and Color3.fromRGB(155, 108, 255) or Color3.fromRGB(60, 60, 85)
        local bgCol = on and Color3.fromRGB(30, 25, 50) or Color3.fromRGB(35, 35, 52)
        if anim then
            Tw(t, EASE_OUT, {BackgroundColor3 = bgCol})
            Tw(knob, EASE_OUT, {Position = knobPos, BackgroundColor3 = knobCol})
            Tw(stroke, EASE_OUT, {Color = strokeCol})
            Tw(fill, EASE_OUT, {BackgroundTransparency = on and 0 or 1})
        else
            t.BackgroundColor3 = bgCol
            knob.Position = knobPos
            knob.BackgroundColor3 = knobCol
            stroke.Color = strokeCol
            fill.BackgroundTransparency = on and 0 or 1
        end
    end

    t.MouseButton1Click:Connect(function()
        if shouldSuppress and shouldSuppress() then return end
        local newState = not getVal()
        if newState then sfxToggleOn() else sfxToggleOff() end
        setVal(newState)
        update(true)
    end)
    update(false)
    return t, update
end

--=====================================================================
--  SLIDER
--=====================================================================
UIS.InputChanged:Connect(function(input)
    if not activeSliderUpdate then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        activeSliderUpdate(input.Position.X)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        activeSliderUpdate = nil
    end
end)

local function makeSlider(parent, min, max, step, getVal, setVal, size)
    size = size or UDim2.new(0, 120, 0, 5)
    local wrap = Create("Frame", {
        Size = size,
        BackgroundColor3 = Color3.fromRGB(30, 30, 46),
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = false,
    }, parent)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, wrap)

    local fill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(120, 80, 230),
        BorderSizePixel = 0,
    }, wrap)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)

    local knob = Create("Frame", {
        Size = UDim2.new(0, 11, 0, 11),
        Position = UDim2.new(0, 0, 0.5, -5.5),
        BackgroundColor3 = Color3.fromRGB(240, 240, 250),
        BorderSizePixel = 0,
        ZIndex = 3,
    }, wrap)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)

    local function refresh()
        if not wrap.Parent then return end
        local v = getVal()
        local pct = 0
        if max ~= min then
            pct = math.clamp((v - min) / (max - min), 0, 1)
        end
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -5.5, 0.5, -5.5)
    end

    local function updateFromX(x)
        if not wrap or not wrap.Parent then
            activeSliderUpdate = nil
            return
        end
        local absW = wrap.AbsoluteSize.X
        if absW <= 0 then return end
        local rel = math.clamp((x - wrap.AbsolutePosition.X) / absW, 0, 1)
        local val = round(min + rel * (max - min), step)
        val = math.clamp(val, min, max)
        setVal(val)
        refresh()
    end

    wrap.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            activeSliderUpdate = updateFromX
            updateFromX(input.Position.X)
        end
    end)

    refresh()
    return wrap, refresh
end

--=====================================================================
--  CONTEXT BINDER
--=====================================================================
local function bindOpenContext(obj, fn)
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            sfxSwitch()
            fn()
        end
    end)

    local pressTask = nil
    local startPos = nil
    obj.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then return end
        startPos = input.Position
        if pressTask then task.cancel(pressTask) end
        pressTask = task.delay(0.45, function()
            pressTask = nil
            sfxSwitch()
            fn()
        end)
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not startPos then return end
        if (input.Position - startPos).Magnitude > 8 then
            if pressTask then task.cancel(pressTask); pressTask = nil end
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then return end
        if pressTask then task.cancel(pressTask); pressTask = nil end
        startPos = nil
    end)
end

--=====================================================================
--  CARDS
--=====================================================================
local cardRefreshers = {}
local function refreshCard(key)
    if cardRefreshers[key] then cardRefreshers[key]() end
end

local function buildCard(parent_, opts)
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33),
        BorderSizePixel = 0,
        Active = true,
    }, parent_)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    local stroke = Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 23, 36)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28)),
        },
        Rotation = 90,
    }, card)

    local indicator = Create("Frame", {
        Size = UDim2.new(0, 3, 0, 20),
        Position = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(155, 108, 255),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, indicator)

    Create("TextLabel", {
        Size = UDim2.new(1, -160, 0, 16),
        Position = UDim2.new(0, 18, 0, 6),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = opts.name,
        TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -160, 0, 12),
        Position = UDim2.new(0, 18, 0, 22),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = opts.desc,
        TextColor3 = Color3.fromRGB(130, 130, 155),
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local keyChip = Create("TextButton", {
        Size = UDim2.new(0, 34, 0, 18),
        Position = UDim2.new(1, -114, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(30, 30, 46),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 5)}, keyChip)
    Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, keyChip)
    local keyLbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = tostring(Config[opts.key].Key or "—"),
        TextColor3 = Color3.fromRGB(180, 180, 210),
        TextSize = 10,
    }, keyChip)

    local suppressTog = false
    local suppressKey = false

    local tog, togUpdate = makeToggle(card,
        function() return opts.getEnabled() end,
        function(v)
            opts.setEnabled(v)
            if applyAll then applyAll() end
            saveCfg(true)
            if opts.onChange then opts.onChange(v) end
        end,
        function()
            if suppressTog then
                suppressTog = false
                return true
            end
            return false
        end)
    tog.Position = UDim2.new(1, -72, 0.5, -9)

    tog.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            suppressTog = false
        end
    end)

    local function refreshVisual()
        local on = opts.getEnabled()
        Tw(indicator, EASE_OUT, {BackgroundTransparency = on and 0 or 1})
        Tw(stroke, EASE_OUT, {
            Color = on and Color3.fromRGB(80, 60, 140) or Color3.fromRGB(40, 40, 60),
            Transparency = on and 0 or 0.2,
        })
        togUpdate(false)
        keyLbl.Text = tostring(Config[opts.key].Key or "—")
    end
    cardRefreshers[opts.key] = refreshVisual
    refreshVisual()

    local function enter()
        Tw(card, EASE_OUT, {BackgroundColor3 = Color3.fromRGB(26, 26, 40)})
    end
    local function leave()
        Tw(card, EASE_OUT, {BackgroundColor3 = Color3.fromRGB(21, 21, 33)})
    end
    card.MouseEnter:Connect(enter)
    card.MouseLeave:Connect(leave)
    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then enter() end
    end)
    card.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then leave() end
    end)

    local function openSelf()
        if openSettings then openSettings(opts.key) end
    end

    bindOpenContext(card, openSelf)

    bindOpenContext(tog, function()
        suppressTog = true
        openSelf()
    end)

    keyChip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            suppressKey = false
        end
    end)
    bindOpenContext(keyChip, function()
        suppressKey = true
        openSelf()
    end)
    keyChip.MouseButton1Click:Connect(function()
        if suppressKey then
            suppressKey = false
            return
        end
        sfxClick()
        openSelf()
    end)

    return card
end

--=====================================================================
--  SETTINGS POPUP
--=====================================================================
local SettingsPopup = Create("Frame", {
    Size = UDim2.new(0, 260, 0, 300),
    Position = UDim2.new(0.5, -130, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(16, 16, 26),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 50,
}, ScreenGui)
Create("UICorner", {CornerRadius = UDim.new(0, 11)}, SettingsPopup)
Create("UIStroke", {Color = Color3.fromRGB(80, 60, 140), Thickness = 1,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, SettingsPopup)
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25)),
    },
    Rotation = 90,
}, SettingsPopup)

local popTitle = Create("TextLabel", {
    Size = UDim2.new(1, -50, 0, 30),
    Position = UDim2.new(0, 14, 0, 4),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Settings",
    TextColor3 = Color3.fromRGB(235, 235, 245),
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
}, SettingsPopup)

local popClose = Create("TextButton", {
    Size = UDim2.new(0, 22, 0, 22),
    Position = UDim2.new(1, -30, 0, 8),
    BackgroundColor3 = Color3.fromRGB(35, 35, 52),
    BorderSizePixel = 0,
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(220, 220, 235),
    TextSize = 11,
    AutoButtonColor = false,
}, SettingsPopup)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, popClose)

closePopup = function()
    SettingsPopup.Visible = false
    listeningKey = false
    activeSliderUpdate = nil
    if activeKBConn then
        pcall(function() activeKBConn:Disconnect() end)
        activeKBConn = nil
    end
end
popClose.MouseButton1Click:Connect(function()
    sfxClose()
    closePopup()
end)

local popScroll = Create("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -44),
    Position = UDim2.new(0, 8, 0, 38),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, SettingsPopup)
Create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, popScroll)
Create("UIPadding", {
    PaddingTop = UDim.new(0, 2),
    PaddingLeft = UDim.new(0, 2),
    PaddingRight = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 6),
}, popScroll)

local function popRow(label, height)
    height = height or 26
    local row = Create("Frame", {
        Size = UDim2.new(1, -2, 0, height),
        BackgroundColor3 = Color3.fromRGB(22, 22, 35),
        BorderSizePixel = 0,
    }, popScroll)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, row)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, row)
    Create("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = label,
        TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    return row
end

openSettings = function(fnKey)
    if not Config[fnKey] then return end

    listeningKey = false
    activeSliderUpdate = nil
    if activeKBConn then
        pcall(function() activeKBConn:Disconnect() end)
        activeKBConn = nil
    end

    popScroll.CanvasPosition = Vector2.new(0, 0)

    popTitle.Text = fnKey .. "  •  Settings"
    SettingsPopup.Visible = true
    SettingsPopup.Size = UDim2.new(0, 240, 0, 275)
    SettingsPopup.Position = UDim2.new(0.5, -120, 0.5, -137)
    Tw(SettingsPopup, EASE_SOFT, {
        Size = UDim2.new(0, 260, 0, 300),
        Position = UDim2.new(0.5, -130, 0.5, -150),
    })

    for _, c in pairs(popScroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextButton") then
            c:Destroy()
        end
    end

    local data = Config[fnKey]

    do
        local row = popRow("Enabled")
        local tog = makeToggle(row,
            function() return data.Enabled end,
            function(v)
                data.Enabled = v
                if applyAll then applyAll() end
                refreshCard(fnKey)
                saveCfg(true)
            end)
        tog.Position = UDim2.new(1, -42, 0.5, -9)
    end

    if type(data.Value) == "number" then
        local row = popRow("Value", 40)
        local valLbl = Create("TextLabel", {
            Size = UDim2.new(0, 50, 0, 18),
            Position = UDim2.new(1, -56, 0, 4),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = tostring(math.floor(data.Value)),
            TextColor3 = Color3.fromRGB(180, 140, 255),
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, row)
        local sl = makeSlider(row, 16, 250, 1,
            function() return data.Value end,
            function(v)
                data.Value = v
                valLbl.Text = tostring(math.floor(v))
                if applyAll then applyAll() end
                saveCfgDebounced()
            end,
            UDim2.new(1, -20, 0, 5))
        sl.Position = UDim2.new(0, 10, 1, -10)
    end

    if type(data.Brightness) == "number" then
        local row = popRow("Brightness", 40)
        local valLbl = Create("TextLabel", {
            Size = UDim2.new(0, 50, 0, 18),
            Position = UDim2.new(1, -56, 0, 4),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = string.format("%.1f", data.Brightness),
            TextColor3 = Color3.fromRGB(180, 140, 255),
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, row)
        local sl = makeSlider(row, 0.5, 8, 0.1,
            function() return data.Brightness end,
            function(v)
                data.Brightness = v
                valLbl.Text = string.format("%.1f", v)
                if applyAll then applyAll() end
                saveCfgDebounced()
            end,
            UDim2.new(1, -20, 0, 5))
        sl.Position = UDim2.new(0, 10, 1, -10)
    end

    if type(data.TimeOfDay) == "number" then
        local row = popRow("Time of Day", 40)
        local valLbl = Create("TextLabel", {
            Size = UDim2.new(0, 50, 0, 18),
            Position = UDim2.new(1, -56, 0, 4),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = string.format("%.1f", data.TimeOfDay),
            TextColor3 = Color3.fromRGB(180, 140, 255),
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, row)
        local sl = makeSlider(row, 0, 24, 0.5,
            function() return data.TimeOfDay end,
            function(v)
                data.TimeOfDay = v
                valLbl.Text = string.format("%.1f", v)
                if applyAll then applyAll() end
                saveCfgDebounced()
            end,
            UDim2.new(1, -20, 0, 5))
        sl.Position = UDim2.new(0, 10, 1, -10)
    end

    do
        local row = popRow("Keybind")
        local kb = Create("TextButton", {
            Size = UDim2.new(0, 60, 0, 18),
            Position = UDim2.new(1, -68, 0.5, -9),
            BackgroundColor3 = Color3.fromRGB(30, 30, 46),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}, kb)
        Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, kb)
        local kbLbl = Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = tostring(data.Key or "—"),
            TextColor3 = Color3.fromRGB(200, 200, 230),
            TextSize = 10,
        }, kb)

        kb.MouseButton1Click:Connect(function()
            if listeningKey then return end
            sfxClick()
            listeningKey = true
            kbLbl.Text = "· · ·"
            kbLbl.TextColor3 = Color3.fromRGB(180, 140, 255)

            if activeKBConn then
                pcall(function() activeKBConn:Disconnect() end)
            end
            activeKBConn = UIS.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local newKey = input.KeyCode.Name
                    data.Key = newKey

                    for otherKey, otherData in pairs(Config) do
                        if otherKey ~= fnKey
                            and type(otherData) == "table"
                            and otherData.Key == newKey then
                            otherData.Key = "None"
                            refreshCard(otherKey)
                        end
                    end

                    kbLbl.Text = newKey
                    kbLbl.TextColor3 = Color3.fromRGB(200, 200, 230)
                    listeningKey = false
                    refreshCard(fnKey)
                    saveCfg(true)
                    sfxToggleOn()
                    if activeKBConn then
                        pcall(function() activeKBConn:Disconnect() end)
                        activeKBConn = nil
                    end
                end
            end)
        end)
    end

    do
        local row = popRow("Mode")
        local dd = Create("TextButton", {
            Size = UDim2.new(0, 70, 0, 18),
            Position = UDim2.new(1, -78, 0.5, -9),
            BackgroundColor3 = Color3.fromRGB(30, 30, 46),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}, dd)
        Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, dd)
        local ddLbl = Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = data.Mode or "Toggle",
            TextColor3 = Color3.fromRGB(200, 200, 230),
            TextSize = 10,
        }, dd)
        local modeOpts = {"Toggle", "Hold"}
        dd.MouseButton1Click:Connect(function()
            sfxClick()
            local i = 1
            for k, v in ipairs(modeOpts) do
                if v == data.Mode then i = k end
            end
            i = i % #modeOpts + 1
            data.Mode = modeOpts[i]
            ddLbl.Text = data.Mode
            saveCfg(true)
        end)
    end

    do
        local row = Create("Frame", {
            Size = UDim2.new(1, -2, 0, 26),
            BackgroundTransparency = 1,
        }, popScroll)

        local save = Create("TextButton", {
            Size = UDim2.new(0.5, -3, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(70, 45, 150),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 7)}, save)
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = "Save",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 10,
        }, save)
        save.MouseButton1Click:Connect(function()
            sfxToggleOn()
            saveCfg()
        end)

        local close = Create("TextButton", {
            Size = UDim2.new(0.5, -3, 1, 0),
            Position = UDim2.new(0.5, 3, 0, 0),
            BackgroundColor3 = Color3.fromRGB(45, 25, 60),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 7)}, close)
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = "Close",
            TextColor3 = Color3.fromRGB(220, 180, 200),
            TextSize = 10,
        }, close)
        close.MouseButton1Click:Connect(function()
            sfxClose()
            closePopup()
        end)
    end
end

--=====================================================================
--  PAGES + CARDS
--=====================================================================
local MainPage     = makeTab("Main",     "★")
local MovementPage = makeTab("Movement", "➤")
local VisualsPage  = makeTab("Visuals",  "◈")
local SettingsPage = makeTab("Settings", "⚙")

buildCard(MainPage, {
    name = "Fullbright",
    desc = "Max world brightness",
    key = "Fullbright",
    getEnabled = function() return Config.Fullbright.Enabled end,
    setEnabled = function(v) Config.Fullbright.Enabled = v end,
})

buildCard(MovementPage, {
    name = "WalkSpeed",
    desc = "Adjust walk speed",
    key = "WalkSpeed",
    getEnabled = function() return Config.WalkSpeed.Enabled end,
    setEnabled = function(v) Config.WalkSpeed.Enabled = v end,
})

buildCard(MovementPage, {
    name = "JumpPower",
    desc = "Adjust jump height",
    key = "JumpPower",
    getEnabled = function() return Config.JumpPower.Enabled end,
    setEnabled = function(v) Config.JumpPower.Enabled = v end,
})

buildCard(MovementPage, {
    name = "Infinite Jump",
    desc = "Jump mid-air continuously",
    key = "InfiniteJump",
    getEnabled = function() return Config.InfiniteJump.Enabled end,
    setEnabled = function(v) Config.InfiniteJump.Enabled = v end,
})

buildCard(VisualsPage, {
    name = "No Fog",
    desc = "Removes world fog",
    key = "NoFog",
    getEnabled = function() return Config.NoFog.Enabled end,
    setEnabled = function(v) Config.NoFog.Enabled = v end,
})

buildCard(VisualsPage, {
    name = "Player ESP",
    desc = "Highlight all players",
    key = "PlayerESP",
    getEnabled = function() return Config.PlayerESP.Enabled end,
    setEnabled = function(v) Config.PlayerESP.Enabled = v end,
})

--=====================================================================
--  SETTINGS TAB ACTIONS
--=====================================================================
local function makeActionButton(parent_, text, desc, color1, color2, onClick)
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33),
        BorderSizePixel = 0,
    }, parent_)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)

    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 16),
        Position = UDim2.new(0, 16, 0, 5),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = text,
        TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 12),
        Position = UDim2.new(0, 16, 0, 21),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = desc,
        TextColor3 = Color3.fromRGB(130, 130, 155),
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local btn = Create("TextButton", {
        Size = UDim2.new(0, 76, 0, 24),
        Position = UDim2.new(1, -88, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(70, 45, 150),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, btn)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(120, 80, 240)),
            ColorSequenceKeypoint.new(1, color2 or Color3.fromRGB(70, 130, 240)),
        },
    }, btn)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "Apply",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
    }, btn)

    btn.MouseButton1Click:Connect(function()
        sfxClick()
        onClick()
    end)
    return card
end

makeActionButton(SettingsPage, "Save Config", "Save current configuration",
    Color3.fromRGB(100, 200, 130), Color3.fromRGB(60, 150, 100),
    function() saveCfg() end)

makeActionButton(SettingsPage, "Load Config", "Load configuration from file",
    Color3.fromRGB(130, 100, 240), Color3.fromRGB(80, 150, 240),
    function()
        loadCfg()
        Main.Position = UDim2.new(Config.UI.XS, Config.UI.XO, Config.UI.YS, Config.UI.YO)
        if applyAll then applyAll() end
        for k in pairs(cardRefreshers) do refreshCard(k) end
    end)

makeActionButton(SettingsPage, "Reset Config", "Reset every setting to default",
    Color3.fromRGB(240, 100, 130), Color3.fromRGB(180, 60, 100),
    function()
        resetCfg()
        if applyAll then applyAll() end
        for k in pairs(cardRefreshers) do refreshCard(k) end
    end)

makeActionButton(SettingsPage, "Reset Keybinds", "Reset bindings and modes",
    Color3.fromRGB(240, 170, 100), Color3.fromRGB(200, 120, 60),
    function()
        resetBinds()
        for k in pairs(cardRefreshers) do refreshCard(k) end
    end)

makeActionButton(SettingsPage, "Toggle Sound", "Enable / disable UI sounds",
    Color3.fromRGB(120, 180, 220), Color3.fromRGB(80, 130, 200),
    function()
        Config.Sound.Enabled = not Config.Sound.Enabled
        saveCfg(true)
        if Config.Sound.Enabled then
            sfxToggleOn()
            notify("Sound", "UI sounds enabled", 1.5)
        else
            notify("Sound", "UI sounds disabled", 1.5)
        end
    end)

makeActionButton(SettingsPage, "Unload GUI", "Destroy NL interface",
    Color3.fromRGB(220, 90, 110), Color3.fromRGB(160, 50, 70),
    function()
        running = false
        if activeKBConn then
            pcall(function() activeKBConn:Disconnect() end)
            activeKBConn = nil
        end
        if SoundFolder then SoundFolder:Destroy() end
        if ScreenGui then ScreenGui:Destroy() end
    end)

--=====================================================================
--  FEATURE LOGIC
--=====================================================================
local function applyFullbright()
    if Config.Fullbright.Enabled then
        Lighting.Brightness     = Config.Fullbright.Brightness
        Lighting.ClockTime      = Config.Fullbright.TimeOfDay
        Lighting.Ambient        = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Brightness     = 1
        Lighting.ClockTime      = 14
        Lighting.Ambient        = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end

local function applyWalkSpeed()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.WalkSpeed = Config.WalkSpeed.Enabled and Config.WalkSpeed.Value or 16
end

local function applyJumpPower()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function() hum.UseJumpPower = true end)
    hum.JumpPower = Config.JumpPower.Enabled and Config.JumpPower.Value or 50
end

local function applyNoFog()
    if Config.NoFog.Enabled then
        pcall(function()
            Lighting.FogEnd   = 100000
            Lighting.FogStart = 100000
        end)
    else
        pcall(function()
            Lighting.FogEnd   = 100000
            Lighting.FogStart = 0
        end)
    end
end

local espHighlights = {}
local function applyESP()
    if not Config.PlayerESP.Enabled then
        for _, h in pairs(espHighlights) do
            if h and h.Parent then h:Destroy() end
        end
        espHighlights = {}
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local existing = espHighlights[plr]
            if not existing or not existing.Parent then
                local hl = Instance.new("Highlight")
                hl.Name = "NL_ESP"
                hl.Adornee = plr.Character
                hl.FillColor = Color3.fromRGB(155, 108, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.6
                hl.OutlineTransparency = 0.1
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = plr.Character
                espHighlights[plr] = hl
            end
        end
    end

    for plr, h in pairs(espHighlights) do
        if not plr.Parent or not plr.Character or not h.Parent then
            if h and h.Parent then h:Destroy() end
            espHighlights[plr] = nil
        end
    end
end

applyAll = function()
    applyFullbright()
    applyWalkSpeed()
    applyJumpPower()
    applyNoFog()
    applyESP()
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    for k in pairs(Config) do
        if type(Config[k]) == "table" and Config[k].Enabled and Config[k].Mode == "Hold" then
            Config[k].Enabled = false
            refreshCard(k)
        end
    end
    if running and applyAll then applyAll() end
end)

task.spawn(function()
    while running do
        task.wait(1)
        if not running then break end
        if Config.PlayerESP.Enabled then applyESP() end
    end
end)

task.spawn(function()
    while running do
        task.wait(0.3)
        if not running then break end
        if Config.WalkSpeed.Enabled then applyWalkSpeed() end
        if Config.JumpPower.Enabled then applyJumpPower() end
        if Config.Fullbright.Enabled then
            if Lighting.Brightness ~= Config.Fullbright.Brightness then
                Lighting.Brightness = Config.Fullbright.Brightness
            end
            if Lighting.ClockTime ~= Config.Fullbright.TimeOfDay then
                Lighting.ClockTime = Config.Fullbright.TimeOfDay
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not running or not Config.InfiniteJump.Enabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

--=====================================================================
--  KEYBIND HANDLER
--=====================================================================
local heldState = {}

local function setFunctionState(key, state, save)
    if not Config[key] then return end
    if type(Config[key]) ~= "table" or not Config[key].Key then return end
    if Config[key].Enabled == state then return end
    Config[key].Enabled = state
    refreshCard(key)
    if applyAll then applyAll() end
    if save ~= false then saveCfg(true) end
end

local function toggleMainVisibility()
    Main.Visible = not Main.Visible
    if Main.Visible then
        sfxOpen()
        Main.Size = UDim2.new(0, 440, 0, 296)
        Tw(Main, EASE_SOFT, {Size = UDim2.new(0, 460, 0, 310)})
    else
        sfxClose()
        closePopup()
    end
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe or listeningKey then return end

    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleMainVisibility()
        return
    end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        local kname = input.KeyCode.Name
        for fnKey, data in pairs(Config) do
            if type(data) == "table" and data.Key == kname and data.Key ~= "None" then
                if data.Mode == "Hold" then
                    if not heldState[fnKey] then
                        heldState[fnKey] = true
                        setFunctionState(fnKey, true, false)
                    end
                else
                    setFunctionState(fnKey, not data.Enabled, true)
                end
            end
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local kname = input.KeyCode.Name
        for fnKey, data in pairs(Config) do
            if type(data) == "table" and data.Key == kname and data.Mode == "Hold" then
                if heldState[fnKey] then
                    heldState[fnKey] = false
                    setFunctionState(fnKey, false, false)
                end
            end
        end
    end
end)

--=====================================================================
--  DRAGGING
--=====================================================================
local function clampMainToScreen()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
        or Vector2.new(1920, 1080)
    if vp.X <= 0 then vp = Vector2.new(1920, 1080) end

    local absX = Main.Position.X.Scale * vp.X + Main.Position.X.Offset
    local absY = Main.Position.Y.Scale * vp.Y + Main.Position.Y.Offset
    local sizeX = Main.AbsoluteSize.X > 0 and Main.AbsoluteSize.X or 460
    local sizeY = Main.AbsoluteSize.Y > 0 and Main.AbsoluteSize.Y or 310

    absX = math.clamp(absX, -sizeX + 80, math.max(80, vp.X - 80))
    absY = math.clamp(absY, 0, math.max(0, vp.Y - 40))

    Main.Position = UDim2.new(0, absX, 0, absY)
    Config.UI.XS = 0
    Config.UI.XO = absX
    Config.UI.YS = 0
    Config.UI.YO = absY
end

do
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                clampMainToScreen()
                saveCfgDebounced()
            end
        end
    end)
end

--=====================================================================
--  TOP BUTTONS
--=====================================================================
MinBtn.MouseButton1Click:Connect(function()
    sfxClose()
    Main.Visible = false
    closePopup()
end)
CloseBtn.MouseButton1Click:Connect(function()
    running = false
    if activeKBConn then
        pcall(function() activeKBConn:Disconnect() end)
        activeKBConn = nil
    end
    if SoundFolder then SoundFolder:Destroy() end
    ScreenGui:Destroy()
end)

--=====================================================================
--  MOBILE FLOATING TRIGGER
--=====================================================================
if isTouchDevice() then
    local fab = Create("TextButton", {
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(Config.FAB.XS, Config.FAB.XO, Config.FAB.YS, Config.FAB.YO),
        BackgroundColor3 = Color3.fromRGB(30, 25, 55),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 90,
        Active = true,
    }, ScreenGui)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, fab)
    Create("UIStroke", {Color = Color3.fromRGB(120, 90, 220), Thickness = 1.5}, fab)
    local fabGlow = Create("Frame", {
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundColor3 = Color3.fromRGB(155, 108, 255),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = 0,
    }, fab)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, fabGlow)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "NL",
        TextColor3 = Color3.fromRGB(220, 200, 255),
        TextSize = 13,
        ZIndex = 2,
    }, fab)

    local fabDrag = false
    local fabStart, fabOrigin
    local fabMoved = false

    local function clampFabToScreen()
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
            or Vector2.new(1920, 1080)
        if vp.X <= 0 then vp = Vector2.new(1920, 1080) end

        local absX = fab.Position.X.Scale * vp.X + fab.Position.X.Offset
        local absY = fab.Position.Y.Scale * vp.Y + fab.Position.Y.Offset
        local sz = fab.AbsoluteSize.X > 0 and fab.AbsoluteSize.X or 38

        absX = math.clamp(absX, 4, vp.X - sz - 4)
        absY = math.clamp(absY, 4, vp.Y - sz - 4)

        fab.Position = UDim2.new(0, absX, 0, absY)
        Config.FAB.XS = 0
        Config.FAB.XO = absX
        Config.FAB.YS = 0
        Config.FAB.YO = absY
    end

    fab.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            fabDrag = true
            fabMoved = false
            fabStart = input.Position
            fabOrigin = fab.Position
            Tw(fab, EASE_OUT, {BackgroundTransparency = 0})
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not fabDrag then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - fabStart
            if d.Magnitude > 6 then fabMoved = true end
            fab.Position = UDim2.new(
                fabOrigin.X.Scale, fabOrigin.X.Offset + d.X,
                fabOrigin.Y.Scale, fabOrigin.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and fabDrag then
            fabDrag = false
            Tw(fab, EASE_OUT, {BackgroundTransparency = 0.2})
            if fabMoved then
                clampFabToScreen()
                saveCfgDebounced()
            else
                toggleMainVisibility()
            end
        end
    end)
end

--=====================================================================
--  BOOT
--=====================================================================
loadCfg(true)
clampMainToScreen()
Main.Position = UDim2.new(Config.UI.XS, Config.UI.XO, Config.UI.YS, Config.UI.YO)
Main.Visible = true                          -- ← ФИКС: принудительно видимо
switchTab("Main")
applyAll()
for k in pairs(cardRefreshers) do refreshCard(k) end

-- ← ФИКС: простой Quint tween вместо Back
local finalPos = UDim2.new(Config.UI.XS, Config.UI.XO, Config.UI.YS, Config.UI.YO)
Main.Size = UDim2.new(0, 420, 0, 280)
Main.Position = UDim2.new(finalPos.X.Scale, finalPos.X.Offset,
    finalPos.Y.Scale, finalPos.Y.Offset - 10)
Tw(Main, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 460, 0, 310),
    Position = finalPos,
})

-- ← ФИКС: нотификация через секунду (гарантированно parent уже существует)
task.delay(1, function()
    if running and notify then
        notify("NL", "Loaded · RightCtrl" .. (isTouchDevice() and " / tap NL dot" or ""), 3)
    end
end)

-- ← ФИКС: failsafe — если Main не имеет parent, попробуем PlayerGui
task.delay(2, function()
    if running and (not Main.Parent or not ScreenGui.Parent) then
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        if pg then
            ScreenGui.Parent = pg
            ScreenGui.Enabled = true
            Main.Visible = true
        end
    end
end)
