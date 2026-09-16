--=====================================================================
--  ███╗   ██╗██╗   NL · Modern UI  (v10 — mega)
--  ████╗  ██║██║   Create: szzzff10 · TikTok: szzzffpvp
--  ██╔██╗ ██║██║   RightCtrl / NL dot · RMB / long-press → settings
--  ██║╚██╗██║██║   5 tabs · Shaders · Invis · Bang · Aimbot
--  ██║ ╚████║███████╗
--  ╚═╝  ╚═══╝╚══════╝
--=====================================================================

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local Localization = game:GetService("LocalizationService")
local StarterGui   = game:GetService("StarterGui")
local LP           = Players.LocalPlayer
local camera       = workspace.CurrentCamera

local SCRIPT_VERSION = "v10.0"
local CREATOR        = "szzzff10"
local TIKTOK         = "szzzffpvp"

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

local function isTouchDevice()
    return UIS.TouchEnabled
end

--=====================================================================
--  LANGUAGE
--=====================================================================
local LANG_LIST = {
    {code="ru", name="Русский"},
    {code="en", name="English"},
    {code="uk", name="Українська"},
    {code="be", name="Беларуская"},
    {code="kk", name="Қазақша"},
    {code="de", name="Deutsch"},
    {code="fr", name="Français"},
    {code="es", name="Español"},
    {code="pt", name="Português"},
    {code="tr", name="Türkçe"},
    {code="pl", name="Polski"},
    {code="zh", name="中文"},
    {code="ja", name="日本語"},
    {code="ko", name="한국어"},
}

local LangStrings = {
    ru = {
        tab_main="Главная", tab_movement="Движение", tab_visuals="Визуалы",
        tab_shaders="Шейдеры", tab_settings="Настройки",
        fullbright="Полная яркость", fullbright_d="Максимальная яркость",
        walkspeed="Скорость ходьбы", jumppower="Сила прыжка",
        infjump="Бесконечный прыжок", nofog="Убрать туман",
        esp="ESP игроков", aimbot="Аимбот", tptool="TP Tool",
        tpplayer="Телепорт к игроку", invis="Невидимость", zoom="Приближение",
        walkfling="WalkFling", bang="Bang", antibang="Анти-Bang",
        sithead="Сесть на голову", language="Язык", sound_vol="Громкость",
        save_cfg="Сохранить", load_cfg="Загрузить", reset_cfg="Сброс конфига",
        reset_binds="Сброс биндов", toggle_sound="Звуки UI", unload="Выгрузить",
        give="Выдать", apply="OK", open="Открыть", close="Закрыть", save="OK",
        players_online="Игроков онлайн", game_name="Игра", server_id="Server ID",
        creator="Создатель", version="Версия", fps="FPS", ping="Пинг",
        net_status="Соединение", search_player="Поиск игрока...",
        search_lang="Поиск языка...", no_players="Не найдено",
        selected="Выбран", bang_warn="Bang через 5 сек",
        shader_none="Без шейдера", shader_sunset="Закат", shader_night="Ночь",
        shader_evening="Вечер", shader_day="День", shader_noon="Полдень",
        custom_keys="Кастомные кнопки", jump_btn="Кнопка прыжка",
        e_btn="Кнопка E", pos="Позиция", test_e="Тест E",
    },
    en = {
        tab_main="Main", tab_movement="Movement", tab_visuals="Visuals",
        tab_shaders="Shaders", tab_settings="Settings",
        fullbright="Fullbright", fullbright_d="Max brightness",
        walkspeed="Walk Speed", jumppower="Jump Power",
        infjump="Infinite Jump", nofog="No Fog",
        esp="Player ESP", aimbot="Aimbot", tptool="TP Tool",
        tpplayer="Teleport to Player", invis="Invisibility", zoom="Zoom",
        walkfling="WalkFling", bang="Bang", antibang="Anti-Bang",
        sithead="Sit on Head", language="Language", sound_vol="Sound Volume",
        save_cfg="Save", load_cfg="Load", reset_cfg="Reset Config",
        reset_binds="Reset Binds", toggle_sound="UI Sounds", unload="Unload",
        give="Give", apply="OK", open="Open", close="Close", save="OK",
        players_online="Players Online", game_name="Game", server_id="Server ID",
        creator="Creator", version="Version", fps="FPS", ping="Ping",
        net_status="Connection", search_player="Search player...",
        search_lang="Search language...", no_players="Not found",
        selected="Selected", bang_warn="Bang in 5 sec",
        shader_none="No shader", shader_sunset="Sunset", shader_night="Night",
        shader_evening="Evening", shader_day="Day", shader_noon="Noon",
        custom_keys="Custom Keys", jump_btn="Jump Button",
        e_btn="E Button", pos="Position", test_e="Test E",
    },
}

local LANG_FAMILY = {
    ru="ru", uk="ru", be="ru", kk="ru",
    en="en", de="en", fr="en", es="en", pt="en",
    tr="en", pl="en", zh="en", ja="en", ko="en",
}

local function isLangSupported(code) return LANG_FAMILY[code] ~= nil end

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
    Aimbot       = { Enabled=false, Key="Q", Mode="Hold", FOV=180, Smooth=0.3, TeamCheck=false, ShowFOV=true },
    WalkFling    = { Enabled=false, Power=50, Key="G", Mode="Hold" },
    AntiBang     = { Enabled=false, Key="B", Mode="Toggle" },
    UI           = { XS=0.5, XO=-230, YS=0.5, YO=-155 },
    FAB          = { XS=0,   XO=14,   YS=1,   YO=-44  },
    Sound        = { Enabled=true, Volume=0.5 },
    Lang         = "auto",
    Shader       = "none",
    Zoom         = { Enabled=false, Value=70, Key="Z", Mode="Toggle" },
    CustomKeys   = {
        Jump = { Enabled=false, XS=0.5, XO=0, YS=0.85, YO=0 },
        E    = { Enabled=false, XS=0.5, XO=120, YS=0.85, YO=0 },
    },
}

local Config = HttpService:JSONDecode(HttpService:JSONEncode(DEFAULT))
local CFG_FILE = "NL_Config.json"
local hasFS = (type(writefile) == "function"
    and type(readfile) == "function"
    and type(isfile) == "function")

local notify, applyAll, openSettings, closePopup, restoreAll

local function detectUserLang()
    local ok, loc = pcall(function()
        return Localization.RobloxLocaleId
    end)
    if not ok or not loc then return "en" end
    local code = loc:sub(1,2):lower()
    if isLangSupported(code) then return code end
    return "en"
end

local function T(key)
    local code = Config.Lang
    if code == "auto" then code = detectUserLang() end
    local fam = LANG_FAMILY[code] or "en"
    local tbl = LangStrings[fam] or LangStrings.en
    return tbl[key] or LangStrings.en[key] or key
end

local function ensureUI()
    if type(Config.UI) ~= "table" then Config.UI = { XS=0.5, XO=-230, YS=0.5, YO=-155 } end
    local dUI = { XS=0.5, XO=-230, YS=0.5, YO=-155 }
    for k, v in pairs(dUI) do
        if type(Config.UI[k]) ~= "number" then Config.UI[k] = v end
    end

    if type(Config.FAB) ~= "table" then Config.FAB = { XS=0, XO=14, YS=1, YO=-44 } end
    local dFAB = { XS=0, XO=14, YS=1, YO=-44 }
    for k, v in pairs(dFAB) do
        if type(Config.FAB[k]) ~= "number" then Config.FAB[k] = v end
    end

    if type(Config.Sound) ~= "table" then Config.Sound = { Enabled=true, Volume=0.5 } end
    if type(Config.Aimbot) ~= "table" then Config.Aimbot = DEFAULT.Aimbot end
    if type(Config.WalkFling) ~= "table" then Config.WalkFling = DEFAULT.WalkFling end
    if type(Config.AntiBang) ~= "table" then Config.AntiBang = DEFAULT.AntiBang end
    if type(Config.Zoom) ~= "table" then Config.Zoom = DEFAULT.Zoom end
    if type(Config.CustomKeys) ~= "table" then Config.CustomKeys = DEFAULT.CustomKeys end
    if type(Config.CustomKeys.Jump) ~= "table" then Config.CustomKeys.Jump = DEFAULT.CustomKeys.Jump end
    if type(Config.CustomKeys.E) ~= "table" then Config.CustomKeys.E = DEFAULT.CustomKeys.E end
    if type(Config.Lang) ~= "string" then Config.Lang = "auto" end
    if type(Config.Shader) ~= "string" then Config.Shader = "none" end
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
    if not silent and notify then notify(T("save_cfg"), "OK", 1.5) end
end

local function loadCfg(silent)
    if not hasFS then return end
    local ok = pcall(function()
        if isfile(CFG_FILE) then
            local data = HttpService:JSONDecode(readfile(CFG_FILE))
            for k, v in pairs(data) do
                if type(Config[k]) == "table" and type(v) == "table" then
                    for k2, v2 in pairs(v) do Config[k][k2] = v2 end
                else
                    Config[k] = v
                end
            end
        end
    end)
    ensureUI()
    if not silent and notify then notify("Config", ok and "OK" or "Failed", 2) end
end

local function resetCfg()
    local savedUI, savedFAB = Config.UI, Config.FAB
    local savedSound, savedLang = Config.Sound, Config.Lang
    Config = HttpService:JSONDecode(HttpService:JSONEncode(DEFAULT))
    Config.UI = savedUI or DEFAULT.UI
    Config.FAB = savedFAB or DEFAULT.FAB
    Config.Sound = savedSound or DEFAULT.Sound
    Config.Lang = savedLang or "auto"
    ensureUI()
    saveCfg(true)
end

local function resetBinds()
    for k, v in pairs(DEFAULT) do
        if Config[k] and type(v) == "table" and v.Key then
            Config[k].Key = v.Key
            Config[k].Mode = v.Mode
        end
    end
    saveCfg(true)
end

ensureUI()

--=====================================================================
--  PARENT
--=====================================================================
local function resolveParent()
    if type(gethui) == "function" then
        local ok, res = pcall(gethui)
        if ok and typeof(res) == "Instance" then return res end
    end
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if pg then return pg end
    local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and cg then return cg end
    return game:GetService("Players")
end

local parent = resolveParent()
local running = true
local listeningKey = false
local activeKBConn = nil
local activeSliderUpdate = nil

local ScreenGui = Create("ScreenGui", {
    Name = "NL_UI", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true, DisplayOrder = 999,
}, parent)

--=====================================================================
--  LOADING SCREEN
--=====================================================================
local Loading = Create("Frame", {
    Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = Color3.fromRGB(8, 8, 14),
    BorderSizePixel = 0, ZIndex = 500,
}, ScreenGui)

local loadTitle = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0.35, 0),
    BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
    Text = "NL · Modern UI", TextColor3 = Color3.fromRGB(240, 240, 250),
    TextSize = 24, ZIndex = 501,
}, Loading)
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 160, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255)),
    },
}, loadTitle)

local loadBarBg = Create("Frame", {
    Size = UDim2.new(0, 300, 0, 6), Position = UDim2.new(0.5, -150, 0.5, 30),
    BackgroundColor3 = Color3.fromRGB(30, 30, 46), BorderSizePixel = 0, ZIndex = 501,
}, Loading)
Create("UICorner", {CornerRadius = UDim.new(1, 0)}, loadBarBg)

local loadBar = Create("Frame", {
    Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(155, 108, 255),
    BorderSizePixel = 0, ZIndex = 502,
}, loadBarBg)
Create("UICorner", {CornerRadius = UDim.new(1, 0)}, loadBar)
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 108, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 200, 255)),
    },
}, loadBar)

local loadPct = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0.5, 50),
    BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
    Text = "0%", TextColor3 = Color3.fromRGB(180, 180, 210),
    TextSize = 14, ZIndex = 501,
}, Loading)

local loadCredits = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0.9, 0),
    BackgroundTransparency = 1, Font = Enum.Font.Gotham,
    Text = "Create: szzzff10 · TikTok: szzzffpvp",
    TextColor3 = Color3.fromRGB(120, 120, 145), TextSize = 11, ZIndex = 501,
}, Loading)

task.spawn(function()
    for i = 0, 100 do
        if not Loading.Parent then return end
        loadBar.Size = UDim2.new(i/100, 0, 1, 0)
        loadPct.Text = i .. "%"
        task.wait(0.012)
    end
    task.wait(0.2)
    Tw(Loading, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {BackgroundTransparency = 1})
    Tw(loadTitle, EASE_SOFT, {TextTransparency = 1})
    Tw(loadBarBg, EASE_SOFT, {BackgroundTransparency = 1})
    Tw(loadBar, EASE_SOFT, {BackgroundTransparency = 1})
    Tw(loadPct, EASE_SOFT, {TextTransparency = 1})
    Tw(loadCredits, EASE_SOFT, {TextTransparency = 1})
    task.wait(0.55)
    if Loading.Parent then Loading:Destroy() end
end)

--=====================================================================
--  SOUND
--=====================================================================
local SoundFolder = Create("Folder", { Name = "NL_SoundFolder" }, workspace)

local SFX = {
    Click="rbxassetid://8743723012", ToggleOn="rbxassetid://8743718235",
    ToggleOff="rbxassetid://8743699346", Switch="rbxassetid://8743700476",
    Open="rbxassetid://8743696654", Close="rbxassetid://8743705750",
    Notify="rbxassetid://9125402238",
}

local function playSound(id, volume, pitch)
    pcall(function()
        if not Config.Sound.Enabled then return end
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

local sfxClick     = function() playSound(SFX.Click, 0.7, 1.0) end
local sfxToggleOn  = function() playSound(SFX.ToggleOn, 0.6, 1.1) end
local sfxToggleOff = function() playSound(SFX.ToggleOff, 0.6, 0.95) end
local sfxSwitch    = function() playSound(SFX.Switch, 0.55, 1.15) end
local sfxOpen      = function() playSound(SFX.Open, 0.6, 1.05) end
local sfxClose     = function() playSound(SFX.Close, 0.6, 0.9) end
local sfxNotify    = function() playSound(SFX.Notify, 0.5, 1.2) end

--=====================================================================
--  NOTIFICATIONS
--=====================================================================
local notifHolder = Create("Frame", {
    Size = UDim2.new(0, 240, 1, -30),
    Position = UDim2.new(1, -250, 0, 15),
    BackgroundTransparency = 1, ZIndex = 100,
}, ScreenGui)
Create("UIListLayout", {
    Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Top,
}, notifHolder)

notify = function(title, text, dur)
    if not notifHolder or not notifHolder.Parent then return end
    dur = dur or 2.5
    sfxNotify()
    local card = Create("Frame", {
        Size = UDim2.new(0, 240, 0, 46),
        BackgroundColor3 = Color3.fromRGB(20, 20, 32),
        BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 100,
    }, notifHolder)
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}, card)
    local stroke = Create("UIStroke", {Color = Color3.fromRGB(70, 60, 130), Thickness = 1, Transparency = 1}, card)
    local accent = Create("Frame", {
        Size = UDim2.new(0, 3, 1, -14), Position = UDim2.new(0, 7, 0, 7),
        BackgroundColor3 = Color3.fromRGB(155, 108, 255),
        BorderSizePixel = 0, BackgroundTransparency = 1,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 2)}, accent)

    local t1 = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 16), Position = UDim2.new(0, 18, 0, 6),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = title, TextColor3 = Color3.fromRGB(240, 240, 250),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1,
    }, card)
    local t2 = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 14), Position = UDim2.new(0, 18, 0, 22),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = text, TextColor3 = Color3.fromRGB(150, 150, 175),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1,
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
    Name = "Main", Size = UDim2.new(0, 480, 0, 320),
    Position = UDim2.new(Config.UI.XS, Config.UI.XO, Config.UI.YS, Config.UI.YO),
    BackgroundColor3 = Color3.fromRGB(14, 14, 21),
    BorderSizePixel = 0, Visible = true, ZIndex = 10,
}, ScreenGui)
Create("UICorner", {CornerRadius = UDim.new(0, 14)}, Main)
Create("UIStroke", {
    Color = Color3.fromRGB(52, 48, 82), Thickness = 1,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, Main)
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 20)),
    }, Rotation = 90,
}, Main)

local orb = Create("Frame", {
    Size = UDim2.new(0, 240, 0, 240), Position = UDim2.new(0, -90, 0, -90),
    BackgroundColor3 = Color3.fromRGB(155, 108, 255),
    BorderSizePixel = 0, BackgroundTransparency = 0.92, ZIndex = 0,
}, Main)
Create("UICorner", {CornerRadius = UDim.new(1, 0)}, orb)

local glow = Create("Frame", {
    Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 0, 38),
    BackgroundColor3 = Color3.fromRGB(155, 108, 255),
    BorderSizePixel = 0, ZIndex = 3,
}, Main)
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 108, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(155, 108, 255)),
    },
    Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.25),
        NumberSequenceKeypoint.new(1, 1),
    },
}, glow)

-- TOP BAR
local TopBar = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1,
    ZIndex = 5, Active = true,
}, Main)

local LogoLabel = Create("TextLabel", {
    Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
    Text = "NL", TextColor3 = Color3.fromRGB(240, 240, 250),
    TextSize = 17, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, TopBar)
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 160, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255)),
    },
}, LogoLabel)

Create("TextLabel", {
    Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 48, 0, 1),
    BackgroundTransparency = 1, Font = Enum.Font.Gotham,
    Text = "• " .. SCRIPT_VERSION, TextColor3 = Color3.fromRGB(120, 120, 145),
    TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, TopBar)

local function makeTopBtn(text, xOffset, danger)
    local b = Create("TextButton", {
        Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, xOffset, 0, 7),
        BackgroundColor3 = Color3.fromRGB(26, 26, 40), BackgroundTransparency = 0.2,
        BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 6,
    }, TopBar)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, b)
    Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, b)
    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = text,
        TextColor3 = Color3.fromRGB(200, 200, 220), TextSize = 12,
    }, b)
    b.MouseEnter:Connect(function()
        Tw(b, EASE_OUT, {
            BackgroundTransparency = 0,
            BackgroundColor3 = danger and Color3.fromRGB(90, 30, 45)
                or Color3.fromRGB(45, 45, 65),
        })
        Tw(lbl, EASE_OUT, {TextColor3 = Color3.fromRGB(255, 255, 255)})
    end)
    b.MouseLeave:Connect(function()
        Tw(b, EASE_OUT, {
            BackgroundTransparency = 0.2,
            BackgroundColor3 = Color3.fromRGB(26, 26, 40),
        })
        Tw(lbl, EASE_OUT, {TextColor3 = Color3.fromRGB(200, 200, 220)})
    end)
    b.MouseButton1Click:Connect(sfxClick)
    return b
end
local CloseBtn = makeTopBtn("✕", -32, true)
local MinBtn   = makeTopBtn("—", -60, false)

-- SIDEBAR
local Sidebar = Create("Frame", {
    Size = UDim2.new(0, 130, 1, -50), Position = UDim2.new(0, 10, 0, 42),
    BackgroundColor3 = Color3.fromRGB(19, 19, 30), BackgroundTransparency = 0.15,
    BorderSizePixel = 0, ZIndex = 2,
}, Main)
Create("UICorner", {CornerRadius = UDim.new(0, 10)}, Sidebar)
Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, Sidebar)
Create("UIListLayout", {
    Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, Sidebar)
Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, Sidebar)

local Content = Create("Frame", {
    Size = UDim2.new(1, -158, 1, -56), Position = UDim2.new(0, 148, 0, 46),
    BackgroundTransparency = 1, ZIndex = 2, ClipsDescendants = true,
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
        else page.Visible = false end
    end
    for n, btn in pairs(tabs) do
        local a = (n == name)
        Tw(btn.bg, EASE_OUT, {
            BackgroundTransparency = a and 0 or 0.35,
            BackgroundColor3 = a and Color3.fromRGB(34, 30, 55) or Color3.fromRGB(22, 22, 34),
        })
        Tw(btn.bar, EASE_OUT, {BackgroundTransparency = a and 0 or 1})
        Tw(btn.lbl, EASE_OUT, {
            TextColor3 = a and Color3.fromRGB(240, 240, 250) or Color3.fromRGB(150, 150, 175),
        })
    end
end

local function makeTab(name, icon, labelText)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Color3.fromRGB(22, 22, 34), BackgroundTransparency = 0.35,
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, Sidebar)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, btn)
    Create("UIStroke", {Color = Color3.fromRGB(42, 42, 62), Thickness = 1, Transparency = 0.3}, btn)

    local bar = Create("Frame", {
        Size = UDim2.new(0, 3, 0, 14), Position = UDim2.new(0, 5, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(155, 108, 255),
        BorderSizePixel = 0, BackgroundTransparency = 1,
    }, btn)
    Create("UICorner", {CornerRadius = UDim.new(0, 2)}, bar)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 160, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 200, 255)),
        }, Rotation = 90,
    }, bar)

    Create("TextLabel", {
        Size = UDim2.new(0, 16, 1, 0), Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = icon, TextColor3 = Color3.fromRGB(180, 180, 210), TextSize = 12,
    }, btn)

    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, -28, 1, 0), Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
        Text = labelText, TextColor3 = Color3.fromRGB(150, 150, 175),
        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
    }, btn)

    btn.MouseEnter:Connect(function()
        if activeTab ~= name then
            Tw(btn, EASE_OUT, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(28, 28, 44)})
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then
            Tw(btn, EASE_OUT, {BackgroundTransparency = 0.35, BackgroundColor3 = Color3.fromRGB(22, 22, 34)})
        end
    end)
    btn.MouseButton1Click:Connect(function()
        if activeTab == name then return end
        sfxSwitch()
        switchTab(name)
    end)

    local page = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110), ScrollBarImageTransparency = 0.4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false,
    }, Content)
    Create("UIListLayout", {Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder}, page)
    Create("UIPadding", {PaddingRight = UDim.new(0, 4), PaddingBottom = UDim.new(0, 10)}, page)

    pages[name] = page
    tabs[name] = {bg = btn, bar = bar, lbl = lbl}
    return page
end

--=====================================================================
--  TOGGLE / SLIDER
--=====================================================================
local function makeToggle(parent, getVal, setVal, shouldSuppress)
    local t = Create("TextButton", {
        Size = UDim2.new(0, 36, 0, 18),
        BackgroundColor3 = Color3.fromRGB(35, 35, 52), BorderSizePixel = 0,
        Text = "", AutoButtonColor = false,
    }, parent)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, t)
    local stroke = Create("UIStroke", {Color = Color3.fromRGB(60, 60, 85), Thickness = 1}, t)
    local fill = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(120, 80, 230),
        BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 1,
    }, t)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)
    local knob = Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(200, 200, 220), BorderSizePixel = 0, ZIndex = 3,
    }, t)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)

    local function update(anim)
        local on = getVal()
        local kp = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local kc = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 220)
        local sc = on and Color3.fromRGB(155, 108, 255) or Color3.fromRGB(60, 60, 85)
        local bc = on and Color3.fromRGB(30, 25, 50) or Color3.fromRGB(35, 35, 52)
        if anim then
            Tw(t, EASE_OUT, {BackgroundColor3 = bc})
            Tw(knob, EASE_OUT, {Position = kp, BackgroundColor3 = kc})
            Tw(stroke, EASE_OUT, {Color = sc})
            Tw(fill, EASE_OUT, {BackgroundTransparency = on and 0 or 1})
        else
            t.BackgroundColor3 = bc; knob.Position = kp
            knob.BackgroundColor3 = kc; stroke.Color = sc
            fill.BackgroundTransparency = on and 0 or 1
        end
    end
    t.MouseButton1Click:Connect(function()
        if shouldSuppress and shouldSuppress() then return end
        local ns = not getVal()
        if ns then sfxToggleOn() else sfxToggleOff() end
        setVal(ns); update(true)
    end)
    update(false)
    return t, update
end

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
        Size = size, BackgroundColor3 = Color3.fromRGB(30, 30, 46),
        BorderSizePixel = 0, Active = true, ClipsDescendants = false,
    }, parent)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, wrap)
    local fill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(120, 80, 230),
        BorderSizePixel = 0,
    }, wrap)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)
    local knob = Create("Frame", {
        Size = UDim2.new(0, 11, 0, 11), Position = UDim2.new(0, 0, 0.5, -5.5),
        BackgroundColor3 = Color3.fromRGB(240, 240, 250),
        BorderSizePixel = 0, ZIndex = 3,
    }, wrap)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)

    local function refresh()
        if not wrap.Parent then return end
        local v = getVal()
        local pct = (max ~= min) and math.clamp((v - min) / (max - min), 0, 1) or 0
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -5.5, 0.5, -5.5)
    end
    local function updateFromX(x)
        if not wrap or not wrap.Parent then activeSliderUpdate = nil; return end
        local w = wrap.AbsoluteSize.X
        if w <= 0 then return end
        local rel = math.clamp((x - wrap.AbsolutePosition.X) / w, 0, 1)
        local val = round(min + rel * (max - min), step)
        val = math.clamp(val, min, max)
        setVal(val); refresh()
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
            sfxSwitch(); fn()
        end
    end)
    local pressTask, startPos = nil, nil
    obj.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then return end
        startPos = input.Position
        if pressTask then task.cancel(pressTask) end
        pressTask = task.delay(0.45, function() pressTask = nil; sfxSwitch(); fn() end)
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
        BorderSizePixel = 0, Active = true,
    }, parent_)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    local stroke = Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 23, 36)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28)),
        }, Rotation = 90,
    }, card)

    local indicator = Create("Frame", {
        Size = UDim2.new(0, 3, 0, 20), Position = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(155, 108, 255),
        BorderSizePixel = 0, BackgroundTransparency = 1,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, indicator)

    Create("TextLabel", {
        Size = UDim2.new(1, -160, 0, 16), Position = UDim2.new(0, 18, 0, 6),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = opts.name, TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -160, 0, 12), Position = UDim2.new(0, 18, 0, 22),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = opts.desc, TextColor3 = Color3.fromRGB(130, 130, 155),
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local keyChip = Create("TextButton", {
        Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -114, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(30, 30, 46),
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 5)}, keyChip)
    Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, keyChip)
    local keyLbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = tostring(Config[opts.key].Key or "—"),
        TextColor3 = Color3.fromRGB(180, 180, 210), TextSize = 10,
    }, keyChip)

    local suppressTog = false
    local tog, togUpdate = makeToggle(card,
        function() return opts.getEnabled() end,
        function(v)
            opts.setEnabled(v)
            if applyAll then applyAll() end
            saveCfg(true)
            if opts.onChange then opts.onChange(v) end
        end,
        function()
            if suppressTog then suppressTog = false; return true end
            return false
        end)
    tog.Position = UDim2.new(1, -72, 0.5, -9)
    tog.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then suppressTog = false end
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

    card.MouseEnter:Connect(function()
        Tw(card, EASE_OUT, {BackgroundColor3 = Color3.fromRGB(26, 26, 40)})
    end)
    card.MouseLeave:Connect(function()
        Tw(card, EASE_OUT, {BackgroundColor3 = Color3.fromRGB(21, 21, 33)})
    end)

    local function openSelf() if openSettings then openSettings(opts.key) end end
    bindOpenContext(card, openSelf)
    bindOpenContext(tog, function() suppressTog = true; openSelf() end)
    keyChip.MouseButton1Click:Connect(function() sfxClick(); openSelf() end)
    return card
end

--=====================================================================
--  SETTINGS POPUP
--=====================================================================
local SettingsPopup = Create("Frame", {
    Size = UDim2.new(0, 260, 0, 300),
    Position = UDim2.new(0.5, -130, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(16, 16, 26),
    BorderSizePixel = 0, Visible = false, ZIndex = 50,
}, ScreenGui)
Create("UICorner", {CornerRadius = UDim.new(0, 11)}, SettingsPopup)
Create("UIStroke", {Color = Color3.fromRGB(80, 60, 140), Thickness = 1,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, SettingsPopup)

local popTitle = Create("TextLabel", {
    Size = UDim2.new(1, -50, 0, 30), Position = UDim2.new(0, 14, 0, 4),
    BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
    Text = "Settings", TextColor3 = Color3.fromRGB(235, 235, 245),
    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
}, SettingsPopup)

local popClose = Create("TextButton", {
    Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -30, 0, 8),
    BackgroundColor3 = Color3.fromRGB(35, 35, 52),
    BorderSizePixel = 0, Text = "✕", Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(220, 220, 235), TextSize = 11, AutoButtonColor = false,
}, SettingsPopup)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, popClose)

closePopup = function()
    SettingsPopup.Visible = false
    listeningKey = false
    activeSliderUpdate = nil
    if activeKBConn then pcall(function() activeKBConn:Disconnect() end); activeKBConn = nil end
end
popClose.MouseButton1Click:Connect(function() sfxClose(); closePopup() end)

local popScroll = Create("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -44), Position = UDim2.new(0, 8, 0, 38),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110),
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, SettingsPopup)
Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, popScroll)
Create("UIPadding", {PaddingTop = UDim.new(0, 2), PaddingLeft = UDim.new(0, 2),
    PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)}, popScroll)

local function popRow(label, height)
    height = height or 26
    local row = Create("Frame", {
        Size = UDim2.new(1, -2, 0, height),
        BackgroundColor3 = Color3.fromRGB(22, 22, 35), BorderSizePixel = 0,
    }, popScroll)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, row)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, row)
    if label ~= "" then
        Create("TextLabel", {
            Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
            Text = label, TextColor3 = Color3.fromRGB(200, 200, 220),
            TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
        }, row)
    end
    return row
end

openSettings = function(fnKey)
    if not Config[fnKey] then return end
    listeningKey = false; activeSliderUpdate = nil
    if activeKBConn then pcall(function() activeKBConn:Disconnect() end); activeKBConn = nil end
    popScroll.CanvasPosition = Vector2.new(0, 0)

    popTitle.Text = fnKey .. "  •  Settings"
    SettingsPopup.Visible = true
    SettingsPopup.Size = UDim2.new(0, 240, 0, 275)
    SettingsPopup.Position = UDim2.new(0.5, -120, 0.5, -137)
    Tw(SettingsPopup, EASE_SOFT, {
        Size = UDim2.new(0, 260, 0, 300), Position = UDim2.new(0.5, -130, 0.5, -150),
    })

    for _, c in pairs(popScroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
    end

    local data = Config[fnKey]

    local rowE = popRow("Enabled")
    local tog = makeToggle(rowE, function() return data.Enabled end,
        function(v)
            data.Enabled = v
            if applyAll then applyAll() end
            refreshCard(fnKey); saveCfg(true)
        end)
    tog.Position = UDim2.new(1, -42, 0.5, -9)

    local function addSlider(label, min, max, step, key, fmt)
        if type(data[key]) ~= "number" then return end
        local row = popRow(label, 40)
        local lbl = Create("TextLabel", {
            Size = UDim2.new(0, 50, 0, 18), Position = UDim2.new(1, -56, 0, 4),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
            Text = fmt(data[key]), TextColor3 = Color3.fromRGB(180, 140, 255),
            TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right,
        }, row)
        local sl = makeSlider(row, min, max, step,
            function() return data[key] end,
            function(v)
                data[key] = v
                lbl.Text = fmt(v)
                if applyAll then applyAll() end
                saveCfgDebounced()
            end, UDim2.new(1, -20, 0, 5))
        sl.Position = UDim2.new(0, 10, 1, -10)
    end

    addSlider("Value", 16, 250, 1, "Value", function(v) return tostring(math.floor(v)) end)
    addSlider("Brightness", 0.5, 8, 0.1, "Brightness", function(v) return string.format("%.1f", v) end)
    addSlider("Time of Day", 0, 24, 0.5, "TimeOfDay", function(v) return string.format("%.1f", v) end)
    addSlider("FOV", 30, 500, 5, "FOV", function(v) return tostring(math.floor(v)) end)
    addSlider("Smooth", 0.05, 1, 0.05, "Smooth", function(v) return string.format("%.2f", v) end)
    addSlider("Power", 10, 500, 5, "Power", function(v) return tostring(math.floor(v)) end)

    if type(data.TeamCheck) == "boolean" then
        local r = popRow("Team Check")
        local t2 = makeToggle(r, function() return data.TeamCheck end,
            function(v) data.TeamCheck = v; saveCfg(true) end)
        t2.Position = UDim2.new(1, -42, 0.5, -9)
    end
    if type(data.ShowFOV) == "boolean" then
        local r = popRow("Show FOV")
        local t2 = makeToggle(r, function() return data.ShowFOV end,
            function(v) data.ShowFOV = v; saveCfg(true) end)
        t2.Position = UDim2.new(1, -42, 0.5, -9)
    end

    do
        local row = popRow("Keybind")
        local kb = Create("TextButton", {
            Size = UDim2.new(0, 60, 0, 18), Position = UDim2.new(1, -68, 0.5, -9),
            BackgroundColor3 = Color3.fromRGB(30, 30, 46),
            BorderSizePixel = 0, Text = "", AutoButtonColor = false,
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}, kb)
        Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, kb)
        local kbLbl = Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, Text = tostring(data.Key or "—"),
            TextColor3 = Color3.fromRGB(200, 200, 230), TextSize = 10,
        }, kb)
        kb.MouseButton1Click:Connect(function()
            if listeningKey then return end
            sfxClick(); listeningKey = true
            kbLbl.Text = "· · ·"
            kbLbl.TextColor3 = Color3.fromRGB(180, 140, 255)
            if activeKBConn then pcall(function() activeKBConn:Disconnect() end) end
            activeKBConn = UIS.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local nk = input.KeyCode.Name
                    data.Key = nk
                    for ok2, od in pairs(Config) do
                        if ok2 ~= fnKey and type(od) == "table" and od.Key == nk then
                            od.Key = "None"; refreshCard(ok2)
                        end
                    end
                    kbLbl.Text = nk
                    kbLbl.TextColor3 = Color3.fromRGB(200, 200, 230)
                    listeningKey = false
                    refreshCard(fnKey); saveCfg(true); sfxToggleOn()
                    if activeKBConn then pcall(function() activeKBConn:Disconnect() end); activeKBConn = nil end
                end
            end)
        end)
    end

    do
        local row = popRow("Mode")
        local dd = Create("TextButton", {
            Size = UDim2.new(0, 70, 0, 18), Position = UDim2.new(1, -78, 0.5, -9),
            BackgroundColor3 = Color3.fromRGB(30, 30, 46),
            BorderSizePixel = 0, Text = "", AutoButtonColor = false,
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}, dd)
        Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, dd)
        local lbl = Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, Text = data.Mode or "Toggle",
            TextColor3 = Color3.fromRGB(200, 200, 230), TextSize = 10,
        }, dd)
        local opts = {"Toggle", "Hold"}
        dd.MouseButton1Click:Connect(function()
            sfxClick()
            local i = 1
            for k, v in ipairs(opts) do if v == data.Mode then i = k end end
            i = i % #opts + 1
            data.Mode = opts[i]; lbl.Text = data.Mode; saveCfg(true)
        end)
    end

    local rowB = Create("Frame", {
        Size = UDim2.new(1, -2, 0, 26), BackgroundTransparency = 1,
    }, popScroll)
    local save = Create("TextButton", {
        Size = UDim2.new(0.5, -3, 1, 0), BackgroundColor3 = Color3.fromRGB(70, 45, 150),
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, rowB)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, save)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = T("save"),
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10,
    }, save)
    save.MouseButton1Click:Connect(function() sfxToggleOn(); saveCfg() end)

    local close = Create("TextButton", {
        Size = UDim2.new(0.5, -3, 1, 0), Position = UDim2.new(0.5, 3, 0, 0),
        BackgroundColor3 = Color3.fromRGB(45, 25, 60),
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, rowB)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, close)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = T("close"),
        TextColor3 = Color3.fromRGB(220, 180, 200), TextSize = 10,
    }, close)
    close.MouseButton1Click:Connect(function() sfxClose(); closePopup() end)
end

--=====================================================================
--  PAGES
--=====================================================================
local MainPage     = makeTab("Main",     "★", T("tab_main"))
local MovementPage = makeTab("Movement", "➤", T("tab_movement"))
local VisualsPage  = makeTab("Visuals",  "◈", T("tab_visuals"))
local ShadersPage  = makeTab("Shaders",  "◆", T("tab_shaders"))
local SettingsPage = makeTab("Settings", "⚙", T("tab_settings"))

--=====================================================================
--  MAIN — Player info panel
--=====================================================================
do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 68),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, MainPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(60, 45, 110), Thickness = 1}, card)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 25, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(21, 21, 33)),
        }, Rotation = 90,
    }, card)

    local avatar = Create("ImageLabel", {
        Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0, 10, 0.5, -26),
        BackgroundColor3 = Color3.fromRGB(30, 30, 46),
        BorderSizePixel = 0, Image = "",
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, avatar)
    Create("UIStroke", {Color = Color3.fromRGB(155, 108, 255), Thickness = 1.5}, avatar)

    task.spawn(function()
        local ok, url = pcall(function()
            return Players:GetUserThumbnailAsync(
                LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and url then avatar.Image = url end
    end)

    Create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 18), Position = UDim2.new(0, 72, 0, 8),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = LP.DisplayName, TextColor3 = Color3.fromRGB(240, 240, 250),
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 14), Position = UDim2.new(0, 72, 0, 26),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "@" .. LP.Name, TextColor3 = Color3.fromRGB(130, 130, 155),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local verLbl = Create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 12), Position = UDim2.new(0, 72, 0, 42),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "NL " .. SCRIPT_VERSION .. " · by " .. CREATOR,
        TextColor3 = Color3.fromRGB(180, 140, 255),
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
end

-- Info card (players, game, server, fps, ping)
local infoCard = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 96),
    BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
}, MainPage)
Create("UICorner", {CornerRadius = UDim.new(0, 9)}, infoCard)
Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, infoCard)

local function infoRow(y, label, getVal)
    local l = Create("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 18), Position = UDim2.new(0, 12, 0, y),
        BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
        Text = label, TextColor3 = Color3.fromRGB(150, 150, 175),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    }, infoCard)
    local v = Create("TextLabel", {
        Size = UDim2.new(0.5, -12, 0, 18), Position = UDim2.new(0.5, 0, 0, y),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = "—", TextColor3 = Color3.fromRGB(220, 220, 235),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right,
    }, infoCard)
    return v
end

local playersLbl = infoRow(6, T("players_online"), nil)
local gameLbl    = infoRow(26, T("game_name"), nil)
local serverLbl  = infoRow(46, T("server_id"), nil)
local fpsLbl     = infoRow(66, T("fps"), nil)
local pingLbl    = Create("TextLabel", {
    Size = UDim2.new(0.5, -12, 0, 18), Position = UDim2.new(0.5, 0, 0, 66),
    BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
    Text = "—", TextColor3 = Color3.fromRGB(220, 220, 235),
    TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right,
}, infoCard)

-- обновляем инфу
task.spawn(function()
    -- game + server
    pcall(function()
        gameLbl.Text = game.Name
        serverLbl.Text = game.JobId ~= "" and game.JobId:sub(1, 12) or "N/A"
    end)
    -- players + fps + ping
    local frames = 0
    local lastT = tick()
    while running do
        task.wait(1)
        if not running then break end
        playersLbl.Text = tostring(#Players:GetPlayers()) .. " / " .. Players.MaxPlayers
        local curT = tick()
        local fps = math.floor(frames / (curT - lastT))
        fpsLbl.Text = tostring(fps) .. " " .. T("fps")
        local ping = 0
        pcall(function() ping = math.floor(LP:GetNetworkPing() * 1000) end)
        pingLbl.Text = tostring(ping) .. " ms"
        frames = 0; lastT = curT
    end
end)

RunService.RenderStepped:Connect(function()
    frames = (frames or 0) + 1
end)

-- Nav cards
local function makeNavCard(parent_, text, desc, targetTab, c1, c2)
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, parent_)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 16), Position = UDim2.new(0, 16, 0, 5),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = text, TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 12), Position = UDim2.new(0, 16, 0, 21),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = desc, TextColor3 = Color3.fromRGB(130, 130, 155),
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local btn = Create("TextButton", {
        Size = UDim2.new(0, 76, 0, 24), Position = UDim2.new(1, -88, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(70, 45, 150),
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, btn)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2),
        },
    }, btn)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = T("open"),
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10,
    }, btn)
    btn.MouseButton1Click:Connect(function() sfxSwitch(); switchTab(targetTab) end)
end

makeNavCard(MainPage, T("tab_movement"), "Speed / Jump / Aimbot / TP / Invis", "Movement",
    Color3.fromRGB(100, 200, 130), Color3.fromRGB(60, 150, 100))
makeNavCard(MainPage, T("tab_visuals"), "Fullbright / No Fog / ESP", "Visuals",
    Color3.fromRGB(155, 108, 255), Color3.fromRGB(90, 200, 255))
makeNavCard(MainPage, T("tab_shaders"), "Sunset / Night / Day / Noon", "Shaders",
    Color3.fromRGB(255, 140, 100), Color3.fromRGB(200, 80, 60))
makeNavCard(MainPage, T("tab_settings"), "Config / Language / Sound", "Settings",
    Color3.fromRGB(200, 100, 180), Color3.fromRGB(140, 70, 200))

--=====================================================================
--  BASIC FUNCTION CARDS
--=====================================================================
buildCard(VisualsPage, {
    name = T("fullbright"), desc = T("fullbright_d"), key = "Fullbright",
    getEnabled = function() return Config.Fullbright.Enabled end,
    setEnabled = function(v) Config.Fullbright.Enabled = v end,
})
buildCard(VisualsPage, {
    name = T("nofog"), desc = "Removes world fog", key = "NoFog",
    getEnabled = function() return Config.NoFog.Enabled end,
    setEnabled = function(v) Config.NoFog.Enabled = v end,
})
buildCard(VisualsPage, {
    name = T("esp"), desc = "Highlight all players", key = "PlayerESP",
    getEnabled = function() return Config.PlayerESP.Enabled end,
    setEnabled = function(v) Config.PlayerESP.Enabled = v end,
})
buildCard(MovementPage, {
    name = T("walkspeed"), desc = "Adjust walk speed", key = "WalkSpeed",
    getEnabled = function() return Config.WalkSpeed.Enabled end,
    setEnabled = function(v) Config.WalkSpeed.Enabled = v end,
})
buildCard(MovementPage, {
    name = T("jumppower"), desc = "Adjust jump height", key = "JumpPower",
    getEnabled = function() return Config.JumpPower.Enabled end,
    setEnabled = function(v) Config.JumpPower.Enabled = v end,
})
buildCard(MovementPage, {
    name = T("infjump"), desc = "Jump mid-air", key = "InfiniteJump",
    getEnabled = function() return Config.InfiniteJump.Enabled end,
    setEnabled = function(v) Config.InfiniteJump.Enabled = v end,
})
buildCard(MovementPage, {
    name = T("aimbot"), desc = "Auto-aim at nearest player", key = "Aimbot",
    getEnabled = function() return Config.Aimbot.Enabled end,
    setEnabled = function(v) Config.Aimbot.Enabled = v end,
})
buildCard(MovementPage, {
    name = T("walkfling"), desc = "Fling while walking (Hold)", key = "WalkFling",
    getEnabled = function() return Config.WalkFling.Enabled end,
    setEnabled = function(v) Config.WalkFling.Enabled = v end,
})
buildCard(MovementPage, {
    name = T("antibang"), desc = "Protect from being banged", key = "AntiBang",
    getEnabled = function() return Config.AntiBang.Enabled end,
    setEnabled = function(v) Config.AntiBang.Enabled = v end,
})
buildCard(VisualsPage, {
    name = T("zoom"), desc = "Adjust camera zoom", key = "Zoom",
    getEnabled = function() return Config.Zoom.Enabled end,
    setEnabled = function(v) Config.Zoom.Enabled = v end,
})

--=====================================================================
--  FOV CIRCLE
--=====================================================================
local fovCircle = Create("Frame", {
    Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ZIndex = 5, Visible = false, Parent = ScreenGui,
}, ScreenGui)
Create("UICorner", {CornerRadius = UDim.new(1, 0)}, fovCircle)
Create("UIStroke", {Color = Color3.fromRGB(155, 108, 255), Thickness = 1.5, Transparency = 0.3}, fovCircle)

task.spawn(function()
    while running do
        RunService.RenderStepped:Wait()
        if Config.Aimbot.Enabled and Config.Aimbot.ShowFOV then
            fovCircle.Visible = true
            local size = Config.Aimbot.FOV * 2
            fovCircle.Size = UDim2.new(0, size, 0, size)
        else
            fovCircle.Visible = false
        end
    end
end)

--=====================================================================
--  INVISIBILITY
--=====================================================================
local invis = { active=false, savedCFrame=nil, camPos=nil, origCamType=nil }

local function enableInvis()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    invis.active = true
    invis.savedCFrame = hrp.CFrame
    invis.camPos = camera.CFrame
    invis.origCamType = camera.CameraType

    hrp.CFrame = CFrame.new(0, 100000, 0)
    hrp.Anchored = true

    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = invis.camPos
end

local function disableInvis()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored = false
        hrp.CFrame = invis.savedCFrame or CFrame.new(0, 5, 0)
    end
    camera.CameraType = invis.origCamType or Enum.CameraType.Custom
    invis.active = false
end

-- движение камеры в невид.
local invisSpeed = 60
task.spawn(function()
    while running do
        local dt = RunService.RenderStepped:Wait()
        if invis.active then
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
            if move.Magnitude > 0 then
                invis.camPos = invis.camPos + move.Unit * invisSpeed * dt
                camera.CFrame = invis.camPos
            end
        end
    end
end)

-- Invis card
do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, MovementPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 16), Position = UDim2.new(0, 16, 0, 5),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = T("invis"), TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 12), Position = UDim2.new(0, 16, 0, 21),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "Ghost mode · WASD to fly", TextColor3 = Color3.fromRGB(130, 130, 155),
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local btn = Create("TextButton", {
        Size = UDim2.new(0, 76, 0, 24), Position = UDim2.new(1, -88, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(70, 45, 150),
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, btn)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 80, 240)),
            Color3SequenceKeypoint and ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 130, 240))
                or ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 130, 240)),
        },
    }, btn)
    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = "ON",
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10,
    }, btn)
    btn.MouseButton1Click:Connect(function()
        sfxToggleOn()
        if invis.active then
            disableInvis(); lbl.Text = "ON"
            notify(T("invis"), "OFF", 1.5)
        else
            enableInvis(); lbl.Text = "OFF"
            notify(T("invis"), "ON", 1.5)
        end
    end)
end

--=====================================================================
--  ZOOM CONTROL
--=====================================================================
local defaultFOV = 70
do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, MovementPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 16), Position = UDim2.new(0, 16, 0, 5),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = T("zoom"), TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local valLbl = Create("TextLabel", {
        Size = UDim2.new(0, 50, 0, 18), Position = UDim2.new(1, -56, 0, 6),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = tostring(Config.Zoom.Value), TextColor3 = Color3.fromRGB(180, 140, 255),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right,
    }, card)
    local sl = makeSlider(card, 20, 120, 1,
        function() return Config.Zoom.Value end,
        function(v)
            Config.Zoom.Value = v
            valLbl.Text = tostring(math.floor(v))
            if Config.Zoom.Enabled then
                camera.FieldOfView = v
            end
            saveCfgDebounced()
        end, UDim2.new(1, -24, 0, 5))
    sl.Position = UDim2.new(0, 12, 0, 40)
end

--=====================================================================
--  WALKFLING
--=====================================================================
local wfVel = nil
local function applyWalkFling()
    if not Config.WalkFling.Enabled then
        -- reset
        if wfVel then pcall(function() wfVel:Destroy() end); wfVel = nil end
        return
    end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not wfVel then
        wfVel = Instance.new("BodyAngularVelocity")
        wfVel.AngularVelocity = Vector3.new(0, Config.WalkFling.Power, 0)
        wfVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        wfVel.P = 1e5
        wfVel.Parent = hrp
    else
        wfVel.AngularVelocity = Vector3.new(0, Config.WalkFling.Power, 0)
    end
end

--=====================================================================
--  TP TOOL & TP PLAYER
--=====================================================================
local function giveTPTool()
    local bp = LP:FindFirstChildOfClass("Backpack")
    local char = LP.Character
    if bp then for _, it in ipairs(bp:GetChildren()) do
        if it.Name == "NL_TPTool" then it:Destroy() end
    end end
    if char then for _, it in ipairs(char:GetChildren()) do
        if it.Name == "NL_TPTool" then it:Destroy() end
    end end
    local tool = Instance.new("Tool")
    tool.Name = "NL_TPTool"; tool.RequiresHandle = false
    tool.CanBeDropped = false; tool.ToolTip = "Click to teleport"
    tool.Activated:Connect(function()
        pcall(function()
            local mouse = LP:GetMouse()
            local t = mouse.Hit
            if t then
                local c = LP.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(t.Position + Vector3.new(0, 3, 0)) end
            end
        end)
    end)
    tool.Parent = bp or char
    sfxToggleOn(); notify("TP Tool", "OK", 2)
end

local function tpToPlayer(plr)
    if not plr then return end
    local myChar = LP.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local theirChar = plr.Character
    local theirHRP = theirChar and theirChar:FindFirstChild("HumanoidRootPart")
    if myHRP and theirHRP then
        myHRP.CFrame = theirHRP.CFrame * CFrame.new(0, 3, -3)
        sfxToggleOn(); notify("Teleport", "→ " .. plr.Name, 1.5)
    end
end

local function findPlayerFuzzy(query)
    query = (query or ""):lower()
    if query == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Name:lower() == query then return p end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Name:lower():sub(1, #query) == query then return p end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Name:lower():find(query, 1, true) then return p end
    end
    return nil
end

-- Bang
local function doBang(target)
    if not target or not target.Character then return end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-5,5), math.random(-5,5), math.random(-5,5))
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(
            math.random(-500,500), math.random(200,800), math.random(-500,500))
        bv.Parent = hrp
        task.delay(0.3, function() pcall(function() bv:Destroy() end) end)
    end)
end

-- Sit on head
local function sitOnHead(target)
    if not target or not target.Character then return end
    local theirHead = target.Character:FindFirstChild("Head")
    local myChar = LP.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if not theirHead or not myHRP then return end
    myHRP.CFrame = theirHead.CFrame * CFrame.new(0, 2, 0)
    if myHum then myHum.Sit = false end
end

-- TP Tool card
do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, MovementPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 16), Position = UDim2.new(0, 16, 0, 5),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = T("tptool"), TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local btn = Create("TextButton", {
        Size = UDim2.new(0, 76, 0, 24), Position = UDim2.new(1, -88, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(70, 45, 150),
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, btn)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = T("give"),
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10,
    }, btn)
    btn.MouseButton1Click:Connect(function() sfxClick(); giveTPTool() end)
end

-- Player list (TP / Bang / Sit)
local selectedPlayer = nil
do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 300),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, MovementPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 16, 0, 6),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = T("tpplayer"), TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local selLbl = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 12), Position = UDim2.new(0, 16, 0, 22),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "—", TextColor3 = Color3.fromRGB(180, 140, 255),
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local search = Create("TextBox", {
        Size = UDim2.new(1, -20, 0, 24), Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = Color3.fromRGB(30, 30, 46), BorderSizePixel = 0,
        Font = Enum.Font.Gotham, PlaceholderText = T("search_player"),
        PlaceholderColor3 = Color3.fromRGB(120, 120, 145), Text = "",
        TextColor3 = Color3.fromRGB(230, 230, 240), TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 6)}, search)
    Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, search)
    Create("UIPadding", {PaddingLeft = UDim.new(0, 8)}, search)

    -- Action buttons row
    local actRow = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 0, 68),
        BackgroundTransparency = 1,
    }, card)
    Create("UIListLayout", {
        Padding = UDim.new(0, 4), FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, actRow)

    local function actBtn(text, c1, c2, onClick)
        local b = Create("TextButton", {
            Size = UDim2.new(0, 74, 1, 0), BackgroundColor3 = Color3.fromRGB(70, 45, 150),
            BorderSizePixel = 0, Text = "", AutoButtonColor = false,
        }, actRow)
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}, b)
        Create("UIGradient", {Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2),
        }}, b)
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, Text = text,
            TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9,
        }, b)
        b.MouseButton1Click:Connect(function()
            sfxClick()
            if not selectedPlayer then
                notify("!", "Select a player", 2); return
            end
            onClick(selectedPlayer)
        end)
    end

    actBtn(T("teleport"), Color3.fromRGB(120, 80, 240), Color3.fromRGB(70, 130, 240),
        function(p) tpToPlayer(p) end)
    actBtn(T("bang"), Color3.fromRGB(240, 90, 90), Color3.fromRGB(180, 50, 50),
        function(p)
            notify(T("bang"), T("bang_warn"), 5)
            task.delay(5, function() doBang(p) end)
        end)
    actBtn(T("sithead"), Color3.fromRGB(120, 200, 130), Color3.fromRGB(60, 150, 100),
        function(p)
            notify(T("sithead"), "5 sec...", 5)
            task.delay(5, function() sitOnHead(p) end)
        end)

    local list = Create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 196), Position = UDim2.new(0, 10, 0, 96),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110),
    }, card)
    Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, list)

    local function rebuild(q)
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
        end
        q = (q or ""):lower()
        local plist = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and (q == "" or p.Name:lower():find(q, 1, true)) then
                table.insert(plist, p)
            end
        end
        if #plist == 0 then
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1,
                Font = Enum.Font.Gotham, Text = T("no_players"),
                TextColor3 = Color3.fromRGB(120, 120, 145), TextSize = 11,
            }, list)
            return
        end
        for _, p in ipairs(plist) do
            local isSel = (selectedPlayer == p)
            local item = Create("TextButton", {
                Size = UDim2.new(1, -4, 0, 26),
                BackgroundColor3 = isSel and Color3.fromRGB(60, 45, 110) or Color3.fromRGB(26, 26, 40),
                BorderSizePixel = 0, Text = "", AutoButtonColor = false,
            }, list)
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}, item)
            Create("TextLabel", {
                Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
                Text = p.Name, TextColor3 = Color3.fromRGB(220, 220, 235),
                TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
            }, item)
            item.MouseButton1Click:Connect(function()
                selectedPlayer = p
                selLbl.Text = T("selected") .. ": " .. p.Name
                sfxClick()
                rebuild(search.Text)
            end)
        end
    end
    search:GetPropertyChangedSignal("Text"):Connect(function() rebuild(search.Text) end)
    search.FocusLost:Connect(function(enter)
        if enter then
            local f = findPlayerFuzzy(search.Text)
            if f then
                selectedPlayer = f; selLbl.Text = T("selected") .. ": " .. f.Name
                rebuild(search.Text)
            end
        end
    end)
    rebuild("")
    task.spawn(function()
        while running do task.wait(2); if list.Parent then rebuild(search.Text) end end
    end)
end

--=====================================================================
--  SHADERS TAB
--=====================================================================
local shaderEffects = {}

local function clearShaders()
    for _, e in ipairs(shaderEffects) do
        if e and e.Parent then pcall(function() e:Destroy() end) end
    end
    shaderEffects = {}
end

local function applyShader(name)
    clearShaders()
    Config.Shader = name
    saveCfg(true)

    if name == "none" then return end

    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "NL_Shader_CC"
    cc.Parent = Lighting
    table.insert(shaderEffects, cc)

    local atmo = Instance.new("Atmosphere")
    atmo.Name = "NL_Shader_Atmo"
    atmo.Parent = Lighting
    table.insert(shaderEffects, atmo)

    if name == "sunset" then
        Lighting.ClockTime = 18
        Lighting.Brightness = 2
        cc.TintColor = Color3.fromRGB(255, 180, 130)
        cc.Contrast = 0.15
        cc.Saturation = 0.25
        atmo.Color = Color3.fromRGB(255, 150, 100)
        atmo.Decay = Color3.fromRGB(120, 60, 80)
        atmo.Density = 0.35
        atmo.Haze = 1.5
    elseif name == "night" then
        Lighting.ClockTime = 0
        Lighting.Brightness = 1
        cc.TintColor = Color3.fromRGB(120, 140, 220)
        cc.Contrast = 0.2
        cc.Saturation = -0.15
        atmo.Color = Color3.fromRGB(20, 30, 60)
        atmo.Decay = Color3.fromRGB(0, 0, 20)
        atmo.Density = 0.4
    elseif name == "evening" then
        Lighting.ClockTime = 20
        Lighting.Brightness = 1.5
        cc.TintColor = Color3.fromRGB(200, 150, 200)
        cc.Contrast = 0.1
        atmo.Color = Color3.fromRGB(180, 140, 200)
        atmo.Density = 0.3
    elseif name == "day" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 3
        cc.TintColor = Color3.fromRGB(255, 255, 255)
        cc.Saturation = 0.1
        atmo.Color = Color3.fromRGB(199, 199, 199)
        atmo.Density = 0.2
        atmo.Haze = 0.5
    elseif name == "noon" then
        Lighting.ClockTime = 12
        Lighting.Brightness = 4
        cc.TintColor = Color3.fromRGB(255, 250, 230)
        cc.Contrast = 0.1
        cc.Saturation = 0.15
        atmo.Density = 0.1
        atmo.Haze = 0
    end
    sfxToggleOn()
end

local shaderOpts = {
    {"none", T("shader_none")}, {"sunset", T("shader_sunset")},
    {"night", T("shader_night")}, {"evening", T("shader_evening")},
    {"day", T("shader_day")}, {"noon", T("shader_noon")},
}
for _, opt in ipairs(shaderOpts) do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, ShadersPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    local nm = opt[2]
    Create("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = nm, TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local apply = Create("TextButton", {
        Size = UDim2.new(0, 70, 0, 24), Position = UDim2.new(1, -82, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(70, 45, 150),
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, apply)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = "ON",
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10,
    }, apply)
    apply.MouseButton1Click:Connect(function()
        applyShader(opt[1])
        notify("Shader", nm, 1.5)
    end)
end

--=====================================================================
--  CUSTOM KEYS
--=====================================================================
local jumpBtn, eBtn

local function buildCustomKeys()
    if jumpBtn then jumpBtn:Destroy() end
    if eBtn then eBtn:Destroy() end

    if Config.CustomKeys.Jump.Enabled then
        jumpBtn = Create("TextButton", {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(Config.CustomKeys.Jump.XS, Config.CustomKeys.Jump.XO,
                Config.CustomKeys.Jump.YS, Config.CustomKeys.Jump.YO),
            BackgroundColor3 = Color3.fromRGB(155, 108, 255),
            BackgroundTransparency = 0.25, BorderSizePixel = 0, Text = "",
            AutoButtonColor = false, ZIndex = 80, Active = true,
        }, ScreenGui)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, jumpBtn)
        Create("UIStroke", {Color = Color3.fromRGB(200, 160, 255), Thickness = 2}, jumpBtn)
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, Text = "⤒",
            TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 22,
        }, jumpBtn)

        local d, s, o, moved = false, nil, nil, false
        jumpBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                d = true; moved = false
                s = input.Position; o = jumpBtn.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not d then return end
            if input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - s
                if delta.Magnitude > 6 then moved = true end
                jumpBtn.Position = UDim2.new(
                    o.X.Scale, o.X.Offset + delta.X, o.Y.Scale, o.Y.Offset + delta.Y)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if not d then return end
            if input.UserInputType == Enum.UserInputType.Touch then
                d = false
                if not moved then
                    local char = LP.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                else
                    Config.CustomKeys.Jump.XS = jumpBtn.Position.X.Scale
                    Config.CustomKeys.Jump.XO = jumpBtn.Position.X.Offset
                    Config.CustomKeys.Jump.YS = jumpBtn.Position.Y.Scale
                    Config.CustomKeys.Jump.YO = jumpBtn.Position.Y.Offset
                    saveCfgDebounced()
                end
            end
        end)
    end

    if Config.CustomKeys.E.Enabled then
        eBtn = Create("TextButton", {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(Config.CustomKeys.E.XS, Config.CustomKeys.E.XO,
                Config.CustomKeys.E.YS, Config.CustomKeys.E.YO),
            BackgroundColor3 = Color3.fromRGB(90, 200, 255),
            BackgroundTransparency = 0.25, BorderSizePixel = 0, Text = "",
            AutoButtonColor = false, ZIndex = 80, Active = true,
        }, ScreenGui)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, eBtn)
        Create("UIStroke", {Color = Color3.fromRGB(140, 220, 255), Thickness = 2}, eBtn)
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, Text = "E",
            TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 22,
        }, eBtn)

        local d, s, o, moved = false, nil, nil, false
        eBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                d = true; moved = false
                s = input.Position; o = eBtn.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not d then return end
            if input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - s
                if delta.Magnitude > 6 then moved = true end
                eBtn.Position = UDim2.new(
                    o.X.Scale, o.X.Offset + delta.X, o.Y.Scale, o.Y.Offset + delta.Y)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if not d then return end
            if input.UserInputType == Enum.UserInputType.Touch then
                d = false
                if not moved then
                    -- эмулируем клавишу E
                    pcall(function()
                        local vim = game:GetService("VirtualInputManager")
                        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.05)
                        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end)
                else
                    Config.CustomKeys.E.XS = eBtn.Position.X.Scale
                    Config.CustomKeys.E.XO = eBtn.Position.X.Offset
                    Config.CustomKeys.E.YS = eBtn.Position.Y.Scale
                    Config.CustomKeys.E.YO = eBtn.Position.Y.Offset
                    saveCfgDebounced()
                end
            end
        end)
    end
end

-- Card в настройках
do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 84),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, SettingsPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 16, 0, 6),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = T("custom_keys"), TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local r1 = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 26), Position = UDim2.new(0, 10, 0, 26),
        BackgroundTransparency = 1,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = T("jump_btn"), TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    }, r1)
    local jt = makeToggle(r1, function() return Config.CustomKeys.Jump.Enabled end,
        function(v)
            Config.CustomKeys.Jump.Enabled = v
            buildCustomKeys(); saveCfg(true)
        end)
    jt.Position = UDim2.new(1, -42, 0.5, -9)

    local r2 = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 26), Position = UDim2.new(0, 10, 0, 54),
        BackgroundTransparency = 1,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = T("e_btn"), TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    }, r2)
    local et = makeToggle(r2, function() return Config.CustomKeys.E.Enabled end,
        function(v)
            Config.CustomKeys.E.Enabled = v
            buildCustomKeys(); saveCfg(true)
        end)
    et.Position = UDim2.new(1, -42, 0.5, -9)
end
buildCustomKeys()

--=====================================================================
--  SETTINGS — Language (collapsible) + Sound slider + Credits
--=====================================================================
do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, SettingsPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 16), Position = UDim2.new(0, 16, 0, 5),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = T("language"), TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local curLbl = Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 12), Position = UDim2.new(0, 16, 0, 21),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "auto", TextColor3 = Color3.fromRGB(130, 130, 155),
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    for _, l in ipairs(LANG_LIST) do
        if l.code == Config.Lang then curLbl.Text = l.name end
    end
    local arrow = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -82, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(30, 30, 46),
        BorderSizePixel = 0, Text = "▼", Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(200, 200, 230), TextSize = 12, AutoButtonColor = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 6)}, arrow)

    -- dropdown list
    local dd = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), Visible = false, ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(16, 16, 26), BorderSizePixel = 0,
    }, SettingsPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, dd)
    Create("UIStroke", {Color = Color3.fromRGB(60, 45, 110), Thickness = 1}, dd)

    local ddSearch = Create("TextBox", {
        Size = UDim2.new(1, -16, 0, 24), Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Color3.fromRGB(30, 30, 46), BorderSizePixel = 0,
        Font = Enum.Font.Gotham, PlaceholderText = T("search_lang"),
        PlaceholderColor3 = Color3.fromRGB(120, 120, 145), Text = "",
        TextColor3 = Color3.fromRGB(230, 230, 240), TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
    }, dd)
    Create("UICorner", {CornerRadius = UDim.new(0, 6)}, ddSearch)
    Create("UIStroke", {Color = Color3.fromRGB(55, 55, 80), Thickness = 1}, ddSearch)
    Create("UIPadding", {PaddingLeft = UDim.new(0, 8)}, ddSearch)

    local ddList = Create("ScrollingFrame", {
        Size = UDim2.new(1, -16, 0, 200), Position = UDim2.new(0, 8, 0, 38),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110),
    }, dd)
    Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, ddList)

    local open = false
    local function rebuild(q)
        for _, c in ipairs(ddList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        q = (q or ""):lower()
        -- auto
        if q == "" then
            local autoItem = Create("TextButton", {
                Size = UDim2.new(1, -4, 0, 28),
                BackgroundColor3 = (Config.Lang == "auto") and Color3.fromRGB(50, 40, 80)
                    or Color3.fromRGB(26, 26, 40),
                BorderSizePixel = 0, Text = "", AutoButtonColor = false,
            }, ddList)
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}, autoItem)
            Create("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
                Text = "Auto (" .. detectUserLang() .. ")",
                TextColor3 = Color3.fromRGB(220, 220, 235), TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, autoItem)
            autoItem.MouseButton1Click:Connect(function()
                Config.Lang = "auto"; saveCfg(true); sfxToggleOn()
                curLbl.Text = "Auto (" .. detectUserLang() .. ")"
                rebuild(ddSearch.Text)
                notify("Language", T("lang_note"), 3)
            end)
        end
        for _, l in ipairs(LANG_LIST) do
            if q == "" or l.name:lower():find(q, 1, true) or l.code:lower():find(q, 1, true) then
                local isActive = (Config.Lang == l.code)
                local item = Create("TextButton", {
                    Size = UDim2.new(1, -4, 0, 28),
                    BackgroundColor3 = isActive and Color3.fromRGB(50, 40, 80)
                        or Color3.fromRGB(26, 26, 40),
                    BorderSizePixel = 0, Text = "", AutoButtonColor = false,
                }, ddList)
                Create("UICorner", {CornerRadius = UDim.new(0, 6)}, item)
                Create("TextLabel", {
                    Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
                    Text = l.name .. (isLangSupported(l.code) and "" or " (EN)"),
                    TextColor3 = Color3.fromRGB(220, 220, 235), TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, item)
                item.MouseButton1Click:Connect(function()
                    Config.Lang = isLangSupported(l.code) and l.code or "en"
                    saveCfg(true); sfxToggleOn()
                    curLbl.Text = l.name
                    rebuild(ddSearch.Text)
                    notify("Language", T("lang_note"), 3)
                end)
            end
        end
    end

    arrow.MouseButton1Click:Connect(function()
        open = not open
        if open then
            dd.Visible = true
            dd.Size = UDim2.new(1, 0, 0, 0)
            Tw(dd, EASE_SOFT, {Size = UDim2.new(1, 0, 0, 250)})
            arrow.Text = "▲"
            rebuild(ddSearch.Text)
        else
            Tw(dd, EASE_SOFT, {Size = UDim2.new(1, 0, 0, 0)})
            arrow.Text = "▼"
            task.delay(0.35, function() if not open then dd.Visible = false end end)
        end
        sfxClick()
    end)
    ddSearch:GetPropertyChangedSignal("Text"):Connect(function() rebuild(ddSearch.Text) end)
end

-- Sound volume slider
do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, SettingsPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 16), Position = UDim2.new(0, 16, 0, 6),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = T("sound_vol"), TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local volLbl = Create("TextLabel", {
        Size = UDim2.new(0, 50, 0, 18), Position = UDim2.new(1, -56, 0, 6),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = tostring(math.floor(Config.Sound.Volume * 100)) .. "%",
        TextColor3 = Color3.fromRGB(180, 140, 255), TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, card)
    local sl = makeSlider(card, 0, 1, 0.05,
        function() return Config.Sound.Volume end,
        function(v)
            Config.Sound.Volume = v
            volLbl.Text = tostring(math.floor(v * 100)) .. "%"
            saveCfgDebounced()
        end, UDim2.new(1, -24, 0, 5))
    sl.Position = UDim2.new(0, 12, 0, 40)
end

-- Credits card
do
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(30, 25, 50), BorderSizePixel = 0,
    }, SettingsPage)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(90, 60, 160), Thickness = 1}, card)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 30, 90)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 50)),
        }, Rotation = 90,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = "NL " .. SCRIPT_VERSION, TextColor3 = Color3.fromRGB(240, 220, 255),
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 14), Position = UDim2.new(0, 14, 0, 26),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "Create: " .. CREATOR, TextColor3 = Color3.fromRGB(200, 180, 255),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 14), Position = UDim2.new(0, 14, 0, 40),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "TikTok: " .. TIKTOK, TextColor3 = Color3.fromRGB(150, 200, 255),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
end

-- Settings buttons
local function makeActionButton(parent_, text, desc, color1, color2, onClick)
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(21, 21, 33), BorderSizePixel = 0,
    }, parent_)
    Create("UICorner", {CornerRadius = UDim.new(0, 9)}, card)
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 60), Thickness = 1}, card)
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 16), Position = UDim2.new(0, 16, 0, 5),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = text, TextColor3 = Color3.fromRGB(235, 235, 245),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local btn = Create("TextButton", {
        Size = UDim2.new(0, 76, 0, 24), Position = UDim2.new(1, -88, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(70, 45, 150),
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
    }, card)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, btn)
    Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(120, 80, 240)),
            ColorSequenceKeypoint.new(1, color2 or Color3.fromRGB(70, 130, 240)),
        },
    }, btn)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = T("apply"),
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10,
    }, btn)
    btn.MouseButton1Click:Connect(function() sfxClick(); onClick() end)
end

makeActionButton(SettingsPage, T("save_cfg"), "", Color3.fromRGB(100, 200, 130),
    Color3.fromRGB(60, 150, 100), function() saveCfg() end)
makeActionButton(SettingsPage, T("load_cfg"), "", Color3.fromRGB(130, 100, 240),
    Color3.fromRGB(80, 150, 240), function()
        loadCfg()
        if applyAll then applyAll() end
        for k in pairs(cardRefreshers) do refreshCard(k) end
    end)
makeActionButton(SettingsPage, T("reset_cfg"), "", Color3.fromRGB(240, 100, 130),
    Color3.fromRGB(180, 60, 100), function()
        resetCfg()
        if applyAll then applyAll() end
        for k in pairs(cardRefreshers) do refreshCard(k) end
    end)
makeActionButton(SettingsPage, T("reset_binds"), "", Color3.fromRGB(240, 170, 100),
    Color3.fromRGB(200, 120, 60), function()
        resetBinds()
        for k in pairs(cardRefreshers) do refreshCard(k) end
    end)
makeActionButton(SettingsPage, T("toggle_sound"), "", Color3.fromRGB(120, 180, 220),
    Color3.fromRGB(80, 130, 200), function()
        Config.Sound.Enabled = not Config.Sound.Enabled
        saveCfg(true)
        notify("Sound", Config.Sound.Enabled and "ON" or "OFF", 1.5)
    end)
makeActionButton(SettingsPage, T("unload"), "", Color3.fromRGB(220, 90, 110),
    Color3.fromRGB(160, 50, 70), function()
        if restoreAll then restoreAll() end
        running = false
        if activeKBConn then pcall(function() activeKBConn:Disconnect() end); activeKBConn = nil end
        if SoundFolder then SoundFolder:Destroy() end
        if ScreenGui then ScreenGui:Destroy() end
    end)

--=====================================================================
--  FEATURE LOGIC
--=====================================================================
local _fbSaved = nil

local function applyFullbright()
    if Config.Fullbright.Enabled then
        if not _fbSaved then
            _fbSaved = {
                Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
                Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
            }
        end
        Lighting.Brightness = Config.Fullbright.Brightness
        Lighting.ClockTime = Config.Fullbright.TimeOfDay
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    else
        if _fbSaved then
            Lighting.Brightness = _fbSaved.Brightness
            Lighting.ClockTime = _fbSaved.ClockTime
            Lighting.Ambient = _fbSaved.Ambient
            Lighting.OutdoorAmbient = _fbSaved.OutdoorAmbient
            _fbSaved = nil
        end
    end
end

local function applyWalkSpeed()
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    h.WalkSpeed = Config.WalkSpeed.Enabled and Config.WalkSpeed.Value or 16
end

local function applyJumpPower()
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    pcall(function() h.UseJumpPower = true end)
    h.JumpPower = Config.JumpPower.Enabled and Config.JumpPower.Value or 50
end

local function applyNoFog()
    pcall(function()
        Lighting.FogEnd = Config.NoFog.Enabled and 100000 or 100000
        Lighting.FogStart = Config.NoFog.Enabled and 100000 or 0
    end)
end

local function applyZoom()
    if Config.Zoom.Enabled then
        camera.FieldOfView = Config.Zoom.Value
    else
        camera.FieldOfView = defaultFOV
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
            local e = espHighlights[plr]
            if not e or not e.Parent then
                local hl = Instance.new("Highlight")
                hl.Name = "NL_ESP"; hl.Adornee = plr.Character
                hl.FillColor = Color3.fromRGB(155, 108, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.6; hl.OutlineTransparency = 0.1
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = plr.Character; espHighlights[plr] = hl
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

-- Aimbot
local function getAimbotTarget()
    local lc = LP.Character
    if not lc then return nil end
    local lh = lc:FindFirstChildOfClass("Humanoid")
    if not lh or lh.Health <= 0 then return nil end
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closest, closestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if head and h and h.Health > 0 then
                local skip = false
                if Config.Aimbot.TeamCheck and plr.Team and LP.Team and plr.Team == LP.Team then
                    skip = true
                end
                if not skip then
                    local pos, on = camera:WorldToViewportPoint(head.Position)
                    if on then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d <= Config.Aimbot.FOV and d < closestDist then
                            closest = head; closestDist = d
                        end
                    end
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while running do
        RunService.RenderStepped:Wait()
        if Config.Aimbot.Enabled then
            local t = getAimbotTarget()
            if t then
                local cur = camera.CFrame
                local want = CFrame.new(cur.Position, t.Position)
                camera.CFrame = cur:Lerp(want, Config.Aimbot.Smooth)
            end
        end
    end
end)

applyAll = function()
    applyFullbright()
    applyWalkSpeed()
    applyJumpPower()
    applyNoFog()
    applyESP()
    applyZoom()
    applyWalkFling()
end

restoreAll = function()
    local saved = {}
    for k, v in pairs(Config) do
        if type(v) == "table" and v.Enabled ~= nil and k ~= "Sound" and k ~= "CustomKeys" then
            saved[k] = v.Enabled; v.Enabled = false
        end
    end
    applyFullbright()
    applyWalkSpeed()
    applyJumpPower()
    applyNoFog()
    applyESP()
    applyZoom()
    if wfVel then pcall(function() wfVel:Destroy() end); wfVel = nil end
    for k, s in pairs(saved) do if Config[k] then Config[k].Enabled = s end end
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    for k in pairs(Config) do
        if type(Config[k]) == "table" and Config[k].Enabled and Config[k].Mode == "Hold" then
            Config[k].Enabled = false; refreshCard(k)
        end
    end
    _fbSaved = nil
    if running and applyAll then applyAll() end
end)

-- Loops
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
                Lighting.Brightness = Config.Fullbright.Brightness end
            if Lighting.ClockTime ~= Config.Fullbright.TimeOfDay then
                Lighting.ClockTime = Config.Fullbright.TimeOfDay end
        end
        if Config.Zoom.Enabled and camera.FieldOfView ~= Config.Zoom.Value then
            camera.FieldOfView = Config.Zoom.Value
        end
        if Config.WalkFling.Enabled then applyWalkFling() end
    end
end)

-- Anti-bang
task.spawn(function()
    while running do
        task.wait(0.5)
        if not running then break end
        if Config.AntiBang.Enabled then
            pcall(function()
                local char = LP.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                for _, obj in ipairs(hrp:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity")
                        or obj:IsA("BodyThrust") or obj:IsA("BodyPosition") then
                        obj:Destroy()
                    end
                end
            end)
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not running or not Config.InfiniteJump.Enabled then return end
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

--=====================================================================
--  KEYBIND
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
        Main.Size = UDim2.new(0, 460, 0, 306)
        Tw(Main, EASE_SOFT, {Size = UDim2.new(0, 480, 0, 320)})
    else
        sfxClose(); closePopup()
    end
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe or listeningKey then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleMainVisibility(); return
    end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local kn = input.KeyCode.Name
        for fk, d in pairs(Config) do
            if type(d) == "table" and d.Key == kn and d.Key ~= "None" then
                if d.Mode == "Hold" then
                    if not heldState[fk] then
                        heldState[fk] = true; setFunctionState(fk, true, false)
                    end
                else
                    setFunctionState(fk, not d.Enabled, true)
                end
            end
        end
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local kn = input.KeyCode.Name
        for fk, d in pairs(Config) do
            if type(d) == "table" and d.Key == kn and d.Mode == "Hold" then
                if heldState[fk] then
                    heldState[fk] = false; setFunctionState(fk, false, false)
                end
            end
        end
    end
end)

--=====================================================================
--  DRAG
--=====================================================================
local function clampMain()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
        or Vector2.new(1920, 1080)
    if vp.X <= 0 then vp = Vector2.new(1920, 1080) end
    local ax = Main.Position.X.Scale * vp.X + Main.Position.X.Offset
    local ay = Main.Position.Y.Scale * vp.Y + Main.Position.Y.Offset
    local sx = Main.AbsoluteSize.X > 0 and Main.AbsoluteSize.X or 480
    local sy = Main.AbsoluteSize.Y > 0 and Main.AbsoluteSize.Y or 320
    ax = math.clamp(ax, -sx + 80, math.max(80, vp.X - 80))
    ay = math.clamp(ay, 0, math.max(0, vp.Y - 40))
    Main.Position = UDim2.new(0, ax, 0, ay)
    Config.UI.XS = 0; Config.UI.XO = ax; Config.UI.YS = 0; Config.UI.YO = ay
end

do
    local drag, ds, sp
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            drag = true; ds = input.Position; sp = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not drag then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - ds
            Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X,
                sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if drag then drag = false; clampMain(); saveCfgDebounced() end
        end
    end)
end

MinBtn.MouseButton1Click:Connect(function()
    sfxClose(); Main.Visible = false; closePopup()
end)
CloseBtn.MouseButton1Click:Connect(function()
    if restoreAll then restoreAll() end
    running = false
    if activeKBConn then pcall(function() activeKBConn:Disconnect() end); activeKBConn = nil end
    if SoundFolder then SoundFolder:Destroy() end
    ScreenGui:Destroy()
end)

--=====================================================================
--  MOBILE FAB
--=====================================================================
if isTouchDevice() then
    local fab = Create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(Config.FAB.XS, Config.FAB.XO, Config.FAB.YS, Config.FAB.YO),
        BackgroundColor3 = Color3.fromRGB(30, 25, 55), BackgroundTransparency = 0.2,
        BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 90, Active = true,
    }, ScreenGui)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, fab)
    Create("UIStroke", {Color = Color3.fromRGB(120, 90, 220), Thickness = 1}, fab)
    local g = Create("Frame", {
        Size = UDim2.new(1, -6, 1, -6), Position = UDim2.new(0, 3, 0, 3),
        BackgroundColor3 = Color3.fromRGB(155, 108, 255),
        BackgroundTransparency = 0.85, BorderSizePixel = 0, ZIndex = 0,
    }, fab)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, g)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = "NL",
        TextColor3 = Color3.fromRGB(220, 200, 255), TextSize = 9, ZIndex = 2,
    }, fab)

    local fd, fs, fo, fm = false, nil, nil, false
    local function clampFab()
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
            or Vector2.new(1920, 1080)
        if vp.X <= 0 then vp = Vector2.new(1920, 1080) end
        local ax = fab.Position.X.Scale * vp.X + fab.Position.X.Offset
        local ay = fab.Position.Y.Scale * vp.Y + fab.Position.Y.Offset
        local sz = fab.AbsoluteSize.X > 0 and fab.AbsoluteSize.X or 26
        ax = math.clamp(ax, 4, vp.X - sz - 4)
        ay = math.clamp(ay, 4, vp.Y - sz - 4)
        fab.Position = UDim2.new(0, ax, 0, ay)
        Config.FAB.XS = 0; Config.FAB.XO = ax; Config.FAB.YS = 0; Config.FAB.YO = ay
    end
    fab.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            fd = true; fm = false; fs = input.Position; fo = fab.Position
            Tw(fab, EASE_OUT, {BackgroundTransparency = 0})
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not fd then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - fs
            if d.Magnitude > 6 then fm = true end
            fab.Position = UDim2.new(fo.X.Scale, fo.X.Offset + d.X,
                fo.Y.Scale, fo.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and fd then
            fd = false
            Tw(fab, EASE_OUT, {BackgroundTransparency = 0.2})
            if fm then clampFab(); saveCfgDebounced()
            else toggleMainVisibility() end
        end
    end)
end

--=====================================================================
--  BOOT
--=====================================================================
loadCfg(true)
clampMain()
Main.Position = UDim2.new(Config.UI.XS, Config.UI.XO, Config.UI.YS, Config.UI.YO)
Main.Visible = true
switchTab("Main")
applyAll()
if Config.Shader and Config.Shader ~= "none" then
    pcall(function() applyShader(Config.Shader) end)
end
for k in pairs(cardRefreshers) do refreshCard(k) end

local fp = UDim2.new(Config.UI.XS, Config.UI.XO, Config.UI.YS, Config.UI.YO)
Main.Size = UDim2.new(0, 460, 0, 306)
Main.Position = UDim2.new(fp.X.Scale, fp.X.Offset, fp.Y.Scale, fp.Y.Offset - 10)
Tw(Main, TweenInfo.new(0.42, Enum.EasingStyle.Quint), {
    Size = UDim2.new(0, 480, 0, 320), Position = fp,
})

task.delay(1.2, function()
    if running and notify then
        notify("NL " .. SCRIPT_VERSION, "by " .. CREATOR .. " · TikTok: " .. TIKTOK, 4)
    end
end)
