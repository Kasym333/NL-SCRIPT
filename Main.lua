-- NL v13 | Create: szzzff10 | TikTok: szzzffpvp
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local TweenService=game:GetService("TweenService")
local HttpService=game:GetService("HttpService")
local Localization=game:GetService("LocalizationService")
local MPS=game:GetService("MarketplaceService")
local TS=game:GetService("TeleportService")
local LP=Players.LocalPlayer
local camera=workspace.CurrentCamera
local VER="v13" local CREATOR="szzzff10" local TIKTOK="szzzffpvp"

function C(c,p,par) local i=Instance.new(c) for k,v in pairs(p or {})do i[k]=v end if par then i.Parent=par end return i end
local EO=TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
local ES=TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
function Tw(o,i,p) if not o or not o.Parent then return end local t=TweenService:Create(o,i,p) t:Play() return t end
function rd(n,s) s=s or 1 return math.floor(n/s+0.5)*s end
function isTouch() return UIS.TouchEnabled end

local LLIST={{code="ru",name="Русский"},{code="en",name="English"},{code="uk",name="Українська"},{code="be",name="Беларуская"},{code="kk",name="Қазақша"},{code="de",name="Deutsch"},{code="fr",name="Français"},{code="es",name="Español"},{code="pt",name="Português"},{code="tr",name="Türkçe"},{code="pl",name="Polski"},{code="zh",name="中文"},{code="ja",name="日本語"},{code="ko",name="한국어"}}
local LS={ru={tab_main="Главная",tab_movement="Движение",tab_tools="Инструменты",tab_visuals="Визуалы",tab_shaders="Шейдеры",tab_animations="Анимации",tab_settings="Настройки",fullbright="Яркость",walkspeed="Скорость",jumppower="Прыжок",infjump="Беск.прыжок",nofog="Убрать туман",esp="ESP",esp_skeleton="Скелет",esp_names="Ники",esp_distance="Дистанция",aimbot="Аимбот",tptool="TP Tool",tpplayer="Телепорт",invis="Невидимость",zoom="Zoom",walkfling="WalkFling",bang="Bang",antibang="Анти-Bang",sithead="На голову",godmode="Бессмертие",language="Язык",sound_vol="Громкость",save_cfg="Сохранить",load_cfg="Загрузить",reset_cfg="Сброс",reset_binds="Сброс биндов",toggle_sound="Звуки",unload="Выгрузить",give="Выдать",open="Открыть",close="Закрыть",save="ОК",apply="ОК",players_online="Игроков",game_name="Игра",server_id="Server",fps="FPS",ping="Пинг",search_player="Поиск...",search_lang="Поиск...",no_players="Не найдено",bang_warn="Bang через 5с",lang_note="Язык применяется после перезапуска"},en={tab_main="Main",tab_movement="Movement",tab_tools="Tools",tab_visuals="Visuals",tab_shaders="Shaders",tab_animations="Animations",tab_settings="Settings",fullbright="Fullbright",walkspeed="Walk Speed",jumppower="Jump Power",infjump="Infinite Jump",nofog="No Fog",esp="ESP",esp_skeleton="Skeleton",esp_names="Names",esp_distance="Distance",aimbot="Aimbot",tptool="TP Tool",tpplayer="TP to Player",invis="Invisibility",zoom="Zoom",walkfling="WalkFling",bang="Bang",antibang="Anti-Bang",sithead="Sit on Head",godmode="God Mode",language="Language",sound_vol="Volume",save_cfg="Save",load_cfg="Load",reset_cfg="Reset",reset_binds="Reset Binds",toggle_sound="Sounds",unload="Unload",give="Give",open="Open",close="Close",save="OK",apply="OK",players_online="Players",game_name="Game",server_id="Server",fps="FPS",ping="Ping",search_player="Search...",search_lang="Search...",no_players="Not found",bang_warn="Bang in 5s",lang_note="Lang after restart"}}
local LF={ru="ru",uk="ru",be="ru",kk="ru",en="en",de="en",fr="en",es="en",pt="en",tr="en",pl="en",zh="en",ja="en",ko="en"}
function isLangS(c) return LF[c]~=nil end
function detectLang() local ok,l=pcall(function() return Localization.RobloxLocaleId end) if not ok or not l then return "en" end local c=l:sub(1,2):lower() if isLangS(c) then return c end return "en" end

local DEF={Fullbright={Enabled=false,Brightness=2,TimeOfDay=14,Key="F",Mode="Toggle"},WalkSpeed={Enabled=false,Value=32,Key="V",Mode="Toggle"},JumpPower={Enabled=false,Value=60,Key="J",Mode="Toggle"},InfiniteJump={Enabled=false,Key="I",Mode="Toggle"},NoFog={Enabled=false,Key="H",Mode="Toggle"},PlayerESP={Enabled=false,Key="E",Mode="Toggle"},ESPSkeleton={Enabled=false,Key="R",Mode="Toggle"},ESPNames={Enabled=false,Key="T",Mode="Toggle"},ESPDistance={Enabled=false,Key="Y",Mode="Toggle"},Aimbot={Enabled=false,Key="Q",Mode="Hold",FOV=180,Smooth=0.3,TeamCheck=false,ShowFOV=true},WalkFling={Enabled=false,Power=50,Key="G",Mode="Hold"},AntiBang={Enabled=false,Key="B",Mode="Toggle"},GodMode={Enabled=false,Key="K",Mode="Toggle"},AntiAFK={Enabled=false,Key="None",Mode="Toggle"},FPSBoost={Enabled=false,Key="None",Mode="Toggle"},Ride={Enabled=false,Key="None",Mode="Toggle"},UI={XS=0.5,XO=-240,YS=0.5,YO=-170},FAB={XS=0,XO=14,YS=1,YO=-44},Sound={Enabled=true,Volume=0.8},Lang="auto",Shader="none",Zoom={Enabled=false,Value=70,Key="Z",Mode="Toggle"}}
local Config=HttpService:JSONDecode(HttpService:JSONEncode(DEF))
local CF="NL_Config.json"
local hasFS=(type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function")
local notify,applyAll,openSettings,closePopup,restoreAll,updateTabLabels,refreshCard
local cardRefreshers={}
refreshCard=function(k) if cardRefreshers[k] then cardRefreshers[k]() end end
function T(k) local c=Config.Lang if c=="auto" then c=detectLang() end local f=LF[c] or "en" local t=LS[f] or LS.en return t[k] or LS.en[k] or k end
function ensureUI()
  if type(Config.UI)~="table" then Config.UI={XS=0.5,XO=-240,YS=0.5,YO=-170} end
  for k,v in pairs({XS=0.5,XO=-240,YS=0.5,YO=-170}) do if type(Config.UI[k])~="number" then Config.UI[k]=v end end
  if type(Config.FAB)~="table" then Config.FAB={XS=0,XO=14,YS=1,YO=-44} end
  for k,v in pairs({XS=0,XO=14,YS=1,YO=-44}) do if type(Config.FAB[k])~="number" then Config.FAB[k]=v end end
  if type(Config.Sound)~="table" then Config.Sound={Enabled=true,Volume=0.8} end
  for _,k in ipairs({"Aimbot","WalkFling","AntiBang","GodMode","AntiAFK","FPSBoost","Ride","Zoom","ESPSkeleton","ESPNames","ESPDistance"}) do if type(Config[k])~="table" then Config[k]=DEF[k] end end
  if type(Config.Lang)~="string" then Config.Lang="auto" end
  if type(Config.Shader)~="string" then Config.Shader="none" end
end
local sP=false
function saveDb() if sP then return end sP=true task.delay(0.6,function() sP=false if hasFS then pcall(function() writefile(CF,HttpService:JSONEncode(Config)) end) end end) end
function saveCfg() if hasFS then pcall(function() writefile(CF,HttpService:JSONEncode(Config)) end) end end
function loadCfg() if not hasFS then return end pcall(function() if isfile(CF) then local d=HttpService:JSONDecode(readfile(CF)) for k,v in pairs(d) do if type(Config[k])=="table" and type(v)=="table" then for k2,v2 in pairs(v) do Config[k][k2]=v2 end else Config[k]=v end end end end) ensureUI() end
function resetCfg() local sUI,sFB,sS,sL=Config.UI,Config.FAB,Config.Sound,Config.Lang Config=HttpService:JSONDecode(HttpService:JSONEncode(DEF)) Config.UI=sUI or DEF.UI Config.FAB=sFB or DEF.FAB Config.Sound=sS or DEF.Sound Config.Lang=sL or "auto" ensureUI() saveCfg() end
function resetBinds() for k,v in pairs(DEF) do if Config[k] and type(v)=="table" and v.Key then Config[k].Key=v.Key Config[k].Mode=v.Mode end end saveCfg() end
ensureUI()

function resolveParent()
  if type(gethui)=="function" then local ok,r=pcall(gethui) if ok and typeof(r)=="Instance" then return r end end
  local pg=LP:FindFirstChildOfClass("PlayerGui") if pg then return pg end
  local ok,cg=pcall(function() return game:GetService("CoreGui") end) if ok and cg then return cg end
  return game:GetService("Players")
end
local parent=resolveParent()
local running=true local listeningKey=false local activeKBConn=nil local activeSliderUpdate=nil

local SG=C("ScreenGui",{Name="NL_UI",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true,DisplayOrder=999},parent)

for _,c in ipairs(Lighting:GetChildren()) do if c.Name:find("^NL_") then pcall(function() c:Destroy() end) end end
local _os=workspace:FindFirstChild("NL_SoundFolder") if _os then _os:Destroy() end

local _blur=nil
function enBlur() pcall(function() if _blur then return end _blur=Instance.new("BlurEffect") _blur.Size=0 _blur.Parent=Lighting TweenService:Create(_blur,TweenInfo.new(0.35,Enum.EasingStyle.Quart),{Size=14}):Play() end) end
function disBlur() pcall(function() if not _blur then return end local b=_blur _blur=nil local t=TweenService:Create(b,TweenInfo.new(0.3),{Size=0}) t:Play() t.Completed:Connect(function() b:Destroy() end) end) end

local Ld=C("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(8,8,14),BorderSizePixel=0,ZIndex=500},SG)
local lt=C("TextLabel",{Size=UDim2.new(1,0,0,40),Position=UDim2.new(0,0,0.35,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="NL · Modern UI",TextColor3=Color3.fromRGB(240,240,250),TextSize=24,ZIndex=501},Ld)
C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(200,160,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,200,255))}},lt)
local lbg=C("Frame",{Size=UDim2.new(0,300,0,6),Position=UDim2.new(0.5,-150,0.5,30),BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,ZIndex=501},Ld)
C("UICorner",{CornerRadius=UDim.new(1,0)},lbg)
local lb=C("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=Color3.fromRGB(155,108,255),BorderSizePixel=0,ZIndex=502},lbg)
C("UICorner",{CornerRadius=UDim.new(1,0)},lb)
C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(155,108,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,200,255))}},lb)
local lp=C("TextLabel",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,0.5,50),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="0%",TextColor3=Color3.fromRGB(180,180,210),TextSize=14,ZIndex=501},Ld)
C("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0.9,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="Create: "..CREATOR.." · TikTok: "..TIKTOK,TextColor3=Color3.fromRGB(120,120,145),TextSize=11,ZIndex=501},Ld)
task.spawn(function()
  for i=0,100 do if not Ld.Parent then return end lb.Size=UDim2.new(i/100,0,1,0) lp.Text=i.."%" task.wait(0.01) end
  task.wait(0.2)
  for _,o in ipairs({Ld,lt,lbg,lb,lp}) do if o then Tw(o,ES,{BackgroundTransparency=1,TextTransparency=1}) end end
  task.wait(0.5) if Ld.Parent then Ld:Destroy() end
end)

local SFolder=C("Folder",{Name="NL_SoundFolder"},workspace)
local SFX={Click={"rbxassetid://8743723012","rbxasset://sounds/clickfast.wav"},ToggleOn={"rbxassetid://8743718235","rbxasset://sounds/electronicpingshort.wav"},ToggleOff={"rbxassetid://8743699346","rbxasset://sounds/electronicpingshort.wav"},Switch={"rbxassetid://8743700476","rbxasset://sounds/clickfast.wav"},Open={"rbxassetid://8743696654","rbxasset://sounds/electronicpingshort.wav"},Close={"rbxassetid://8743705750","rbxasset://sounds/electronicpingshort.wav"},Notify={"rbxassetid://9125402238","rbxasset://sounds/electronicpingshort.wav"},TP={"rbxassetid://8743696654","rbxasset://sounds/electronicpingshort.wav"},Bang={"rbxassetid://9125402238","rbxasset://sounds/impact_water.mp3"},Sit={"rbxassetid://8743718235","rbxasset://sounds/action_jump.mp3"},Hover={"rbxassetid://8743700476","rbxasset://sounds/clickfast.wav"}}
function playS(idL,v,p)
  pcall(function()
    if not Config.Sound.Enabled or not SFolder.Parent then return end
    local ids=type(idL)=="table" and idL or {idL}
    local s=Instance.new("Sound") s.SoundId=ids[1] s.Volume=math.clamp((Config.Sound.Volume or 0.8)*(v or 1)*1.4,0,10) s.PlaybackSpeed=p or 1 s.Parent=SFolder
    local ld=false task.delay(0.4,function() if not ld and s and s.Parent then pcall(function() s.SoundId=ids[2] or ids[1] s:Play() end) end end)
    s.Loaded:Connect(function() ld=true end)
    s:Play()
    local d=false local function cl() if d then return end d=true pcall(function() s:Destroy() end) end
    pcall(function() s.Ended:Connect(cl) end) task.delay(3,cl)
  end)
end
function sC() playS(SFX.Click,1.0,1.0) end
function sTO() playS(SFX.ToggleOn,0.9,1.1) end
function sTF() playS(SFX.ToggleOff,0.9,0.95) end
function sSw() playS(SFX.Switch,0.8,1.15) end
function sOp() playS(SFX.Open,0.9,1.05) end
function sCl() playS(SFX.Close,0.9,0.9) end
function sN() playS(SFX.Notify,0.7,1.2) end
function sTp() playS(SFX.TP,1.0,1.25) end
function sBg() playS(SFX.Bang,1.2,0.7) end
function sSt() playS(SFX.Sit,1.0,1.15) end
function sHv() playS(SFX.Hover,0.35,1.2) end

local nHolder=C("Frame",{Size=UDim2.new(0,240,1,-30),Position=UDim2.new(1,-250,0,15),BackgroundTransparency=1,ZIndex=100},SG)
C("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Top},nHolder)
notify=function(t,x,d)
  if not nHolder or not nHolder.Parent then return end
  d=d or 2.5 sN()
  local c=C("Frame",{Size=UDim2.new(0,240,0,46),BackgroundColor3=Color3.fromRGB(20,20,32),BorderSizePixel=0,BackgroundTransparency=1,ZIndex=100},nHolder)
  C("UICorner",{CornerRadius=UDim.new(0,10)},c)
  local st=C("UIStroke",{Color=Color3.fromRGB(70,60,130),Thickness=1,Transparency=1},c)
  local ac=C("Frame",{Size=UDim2.new(0,3,1,-14),Position=UDim2.new(0,7,0,7),BackgroundColor3=Color3.fromRGB(155,108,255),BorderSizePixel=0,BackgroundTransparency=1},c)
  C("UICorner",{CornerRadius=UDim.new(0,2)},ac)
  local t1=C("TextLabel",{Size=UDim2.new(1,-24,0,16),Position=UDim2.new(0,18,0,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=t,TextColor3=Color3.fromRGB(240,240,250),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=1},c)
  local t2=C("TextLabel",{Size=UDim2.new(1,-24,0,14),Position=UDim2.new(0,18,0,22),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text=x,TextColor3=Color3.fromRGB(150,150,175),TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=1},c)
  Tw(c,ES,{BackgroundTransparency=0}) Tw(st,ES,{Transparency=0}) Tw(ac,ES,{BackgroundTransparency=0}) Tw(t1,ES,{TextTransparency=0}) Tw(t2,ES,{TextTransparency=0})
  task.delay(d,function()
    if not c.Parent then return end
    Tw(c,ES,{BackgroundTransparency=1}) Tw(st,ES,{Transparency=1}) Tw(ac,ES,{BackgroundTransparency=1}) Tw(t1,ES,{TextTransparency=1}) Tw(t2,ES,{TextTransparency=1})
    task.wait(0.34) if c.Parent then c:Destroy() end
  end)
end

local Main=C("Frame",{Name="Main",Size=UDim2.new(0,480,0,340),Position=UDim2.new(Config.UI.XS,Config.UI.XO,Config.UI.YS,Config.UI.YO),BackgroundColor3=Color3.fromRGB(14,14,21),BorderSizePixel=0,Visible=true,ZIndex=10},SG)
C("UICorner",{CornerRadius=UDim.new(0,14)},Main)
C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(22,22,34)),ColorSequenceKeypoint.new(1,Color3.fromRGB(12,12,20))},Rotation=90},Main)
C("UISizeConstraint",{MinSize=Vector2.new(290,300),MaxSize=Vector2.new(560,420)},Main)

-- === ЛАЗЕРНОЕ СВЕЧЕНИЕ ===
local laserC1=Color3.fromRGB(155,108,255)
local laserC2=Color3.fromRGB(90,200,255)
local laserC3=Color3.fromRGB(200,100,255)
local laserC4=Color3.fromRGB(120,255,220)
local lOut1=C("Frame",{Size=UDim2.new(1,14,1,14),Position=UDim2.new(0,-7,0,-7),BackgroundColor3=laserC1,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=9},Main)
C("UICorner",{CornerRadius=UDim.new(0,18)},lOut1)
local lGrad1=C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,laserC1),ColorSequenceKeypoint.new(0.33,laserC2),ColorSequenceKeypoint.new(0.66,laserC3),ColorSequenceKeypoint.new(1,laserC4)},Rotation=0},lOut1)
local lOut2=C("Frame",{Size=UDim2.new(1,28,1,28),Position=UDim2.new(0,-14,0,-14),BackgroundColor3=laserC2,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=8},Main)
C("UICorner",{CornerRadius=UDim.new(0,24)},lOut2)
local lGrad2=C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,laserC2),ColorSequenceKeypoint.new(0.5,laserC1),ColorSequenceKeypoint.new(1,laserC3)},Rotation=0},lOut2)
local lLine=C("Frame",{Size=UDim2.new(0,60,0,2),Position=UDim2.new(0,0,0,-1),BackgroundColor3=laserC2,BorderSizePixel=0,ZIndex=15},Main)
C("UICorner",{CornerRadius=UDim.new(1,0)},lLine)
C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.5,laserC2),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))},Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0.3),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(1,0.3)}},lLine)
task.spawn(function() while running do lLine.Position=UDim2.new(-0.5,0,0,-1) local t=TweenService:Create(lLine,TweenInfo.new(2.5,Enum.EasingStyle.Linear),{Position=UDim2.new(1,0,0,-1)}) t:Play() t.Completed:Wait() end end)
task.spawn(function() local tt=0 while running do local dt=RunService.RenderStepped:Wait() if not lOut1.Parent then break end tt=tt+dt*0.8 local pl=(math.sin(tt)+1)/2 lOut1.BackgroundTransparency=0.9-pl*0.08 lOut2.BackgroundTransparency=0.95-pl*0.03 lGrad1.Rotation=(lGrad1.Rotation+dt*30)%360 lGrad2.Rotation=(lGrad2.Rotation-dt*25)%360 end end)
local lStroke=C("UIStroke",{Color=laserC1,Thickness=1.5,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Transparency=0.2},Main)
local lSg=C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,laserC1),ColorSequenceKeypoint.new(0.25,laserC2),ColorSequenceKeypoint.new(0.5,laserC3),ColorSequenceKeypoint.new(0.75,laserC4),ColorSequenceKeypoint.new(1,laserC1)},Rotation=0},Main)
lStroke.Color=Color3.fromRGB(255,255,255)
task.spawn(function() while running do if not lSg.Parent then break end lSg.Rotation=(lSg.Rotation+0.8)%360 task.wait() end end)

-- === Дальше всё как в v12 ===

local pat=C("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ClipsDescendants=true,ZIndex=1},Main)
for x=0,20 do C("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(0,x*24,0,0),BackgroundColor3=Color3.fromRGB(155,108,255),BackgroundTransparency=0.94,BorderSizePixel=0,ZIndex=1},pat) end
for y=0,14 do C("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,y*24),BackgroundColor3=Color3.fromRGB(155,108,255),BackgroundTransparency=0.94,BorderSizePixel=0,ZIndex=1},pat) end

local gl=C("Frame",{Size=UDim2.new(1,-24,0,1),Position=UDim2.new(0,12,0,38),BackgroundColor3=Color3.fromRGB(155,108,255),BorderSizePixel=0,ZIndex=3},Main)
C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(155,108,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(90,200,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(155,108,255))},Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0.25),NumberSequenceKeypoint.new(1,1)}},gl)

local TB=C("Frame",{Size=UDim2.new(1,0,0,38),BackgroundTransparency=1,ZIndex=5,Active=true},Main)
local logo=C("TextLabel",{Size=UDim2.new(0,40,1,0),Position=UDim2.new(0,14,0,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="NL",TextColor3=Color3.fromRGB(240,240,250),TextSize=17,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5},TB)
local lg=C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(200,160,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(100,200,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(155,108,255))},Rotation=0},logo)
task.spawn(function() while running do task.wait() if lg and lg.Parent then lg.Rotation=(lg.Rotation+0.6)%360 end end end)
local pulse=C("Frame",{Size=UDim2.new(0,6,0,6),Position=UDim2.new(0,44,0.5,-3),BackgroundColor3=Color3.fromRGB(100,255,140),BorderSizePixel=0,ZIndex=6},TB)
C("UICorner",{CornerRadius=UDim.new(1,0)},pulse)
task.spawn(function() while running do Tw(pulse,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0.75,Size=UDim2.new(0,10,0,10),Position=UDim2.new(0,42,0.5,-5)}) task.wait(1) Tw(pulse,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0,Size=UDim2.new(0,6,0,6),Position=UDim2.new(0,44,0.5,-3)}) task.wait(1) end end)
C("TextLabel",{Size=UDim2.new(0,200,1,0),Position=UDim2.new(0,54,0,1),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="• "..VER,TextColor3=Color3.fromRGB(120,120,145),TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5},TB)

function mTB(t,xo,dg)
  local b=C("TextButton",{Size=UDim2.new(0,24,0,24),Position=UDim2.new(1,xo,0,7),BackgroundColor3=Color3.fromRGB(26,26,40),BackgroundTransparency=0.2,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=6},TB)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("UIStroke",{Color=Color3.fromRGB(55,55,80),Thickness=1},b)
  local l=C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=t,TextColor3=Color3.fromRGB(200,200,220),TextSize=12},b)
  b.MouseEnter:Connect(function() Tw(b,EO,{BackgroundTransparency=0,BackgroundColor3=dg and Color3.fromRGB(90,30,45) or Color3.fromRGB(45,45,65)}) Tw(l,EO,{TextColor3=Color3.fromRGB(255,255,255)}) end)
  b.MouseLeave:Connect(function() Tw(b,EO,{BackgroundTransparency=0.2,BackgroundColor3=Color3.fromRGB(26,26,40)}) Tw(l,EO,{TextColor3=Color3.fromRGB(200,200,220)}) end)
  b.MouseButton1Click:Connect(sC)
  return b
end
local CloseB=mTB("✕",-32,true)
local MinB=mTB("—",-60,false)

local Sb=C("Frame",{Size=UDim2.new(0,132,1,-50),Position=UDim2.new(0,10,0,42),BackgroundColor3=Color3.fromRGB(19,19,30),BackgroundTransparency=0.15,BorderSizePixel=0,ZIndex=2},Main)
C("UICorner",{CornerRadius=UDim.new(0,10)},Sb)
C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},Sb)
C("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center},Sb)
C("UIPadding",{PaddingTop=UDim.new(0,8),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)},Sb)

local Ct=C("Frame",{Size=UDim2.new(1,-160,1,-56),Position=UDim2.new(0,150,0,46),BackgroundTransparency=1,ZIndex=2,ClipsDescendants=true},Main)

local pages,tabs,tGlows={},{},{}
local aTab=nil
function switchTab(name)
  if aTab==name then return end
  aTab=name
  for n,p in pairs(pages) do if n==name then p.Visible=true p.Position=UDim2.new(0,10,0,0) Tw(p,ES,{Position=UDim2.new(0,0,0,0)}) else p.Visible=false end end
  for n,i in pairs(tGlows) do local a=(n==name)
    Tw(i.btn,EO,{BackgroundTransparency=a and 0 or 0.35,BackgroundColor3=a and Color3.fromRGB(34,30,55) or Color3.fromRGB(22,22,34)})
    Tw(i.stroke,EO,{Transparency=a and 0 or 0.3,Color=a and Color3.fromRGB(155,108,255) or Color3.fromRGB(42,42,62)})
    Tw(i.bar,EO,{BackgroundTransparency=a and 0 or 1})
    Tw(i.lbl,EO,{TextColor3=a and Color3.fromRGB(240,240,250) or Color3.fromRGB(150,150,175)})
    Tw(i.ico,EO,{TextColor3=a and Color3.fromRGB(220,200,255) or Color3.fromRGB(180,180,210)})
    Tw(i.glow,EO,{Size=a and UDim2.new(0,40,1,0) or UDim2.new(0,0,1,0)})
  end
end
function makeTab(name,icon,label)
  local b=C("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundColor3=Color3.fromRGB(22,22,34),BackgroundTransparency=0.35,BorderSizePixel=0,Text="",AutoButtonColor=false},Sb)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  local st=C("UIStroke",{Color=Color3.fromRGB(42,42,62),Thickness=1,Transparency=0.3},b)
  local br=C("Frame",{Size=UDim2.new(0,3,0,14),Position=UDim2.new(0,5,0.5,-7),BackgroundColor3=Color3.fromRGB(155,108,255),BorderSizePixel=0,BackgroundTransparency=1,ZIndex=2},b)
  C("UICorner",{CornerRadius=UDim.new(0,2)},br)
  C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(200,160,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,200,255))},Rotation=90},br)
  local ic=C("TextLabel",{Size=UDim2.new(0,16,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=icon,TextColor3=Color3.fromRGB(180,180,210),TextSize=12,ZIndex=2},b)
  local lb=C("TextLabel",{Size=UDim2.new(1,-28,1,0),Position=UDim2.new(0,28,0,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=label,TextColor3=Color3.fromRGB(150,150,175),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2},b)
  local gF=C("Frame",{Size=UDim2.new(0,0,1,0),Position=UDim2.new(1,0,0,0),AnchorPoint=Vector2.new(1,0),BackgroundColor3=Color3.fromRGB(155,108,255),BackgroundTransparency=0.75,BorderSizePixel=0,ZIndex=1},b)
  b.MouseEnter:Connect(function() if aTab~=name then Tw(b,EO,{BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(28,28,44)}) Tw(st,EO,{Transparency=0,Color=Color3.fromRGB(80,70,140)}) end sHv() end)
  b.MouseLeave:Connect(function() if aTab~=name then Tw(b,EO,{BackgroundTransparency=0.35,BackgroundColor3=Color3.fromRGB(22,22,34)}) Tw(st,EO,{Transparency=0.3,Color=Color3.fromRGB(42,42,62)}) end end)
  b.MouseButton1Click:Connect(function() if aTab==name then return end sSw() switchTab(name) end)
  tGlows[name]={btn=b,stroke=st,bar=br,ico=ic,lbl=lb,glow=gF}
  local p=C("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=3,ScrollBarImageColor3=Color3.fromRGB(80,80,110),ScrollBarImageTransparency=0.4,AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},Ct)
  C("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},p)
  C("UIPadding",{PaddingRight=UDim.new(0,4),PaddingBottom=UDim.new(0,10)},p)
  pages[name]=p tabs[name]={bg=b,bar=br,lbl=lb}
  return p
end

function makeToggle(par,getV,setV,shouldSup)
  local t=C("TextButton",{Size=UDim2.new(0,36,0,18),BackgroundColor3=Color3.fromRGB(35,35,52),BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=4},par)
  C("UICorner",{CornerRadius=UDim.new(1,0)},t)
  local st=C("UIStroke",{Color=Color3.fromRGB(60,60,85),Thickness=1},t)
  local tg=C("Frame",{Size=UDim2.new(1,6,1,6),Position=UDim2.new(0,-3,0,-3),BackgroundColor3=Color3.fromRGB(155,108,255),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=0},t)
  C("UICorner",{CornerRadius=UDim.new(1,0)},tg)
  local fl=C("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(120,80,230),BorderSizePixel=0,BackgroundTransparency=1,ZIndex=1},t)
  C("UICorner",{CornerRadius=UDim.new(1,0)},fl)
  local kn=C("Frame",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(0,2,0.5,-7),BackgroundColor3=Color3.fromRGB(200,200,220),BorderSizePixel=0,ZIndex=3},t)
  C("UICorner",{CornerRadius=UDim.new(1,0)},kn)
  local function upd(an)
    if not t or not t.Parent then return end
    local on=getV()
    local kp=on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
    local kc=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,220)
    local sc=on and Color3.fromRGB(155,108,255) or Color3.fromRGB(60,60,85)
    local bc=on and Color3.fromRGB(30,25,50) or Color3.fromRGB(35,35,52)
    if an then Tw(t,EO,{BackgroundColor3=bc}) Tw(kn,EO,{Position=kp,BackgroundColor3=kc}) Tw(st,EO,{Color=sc}) Tw(fl,EO,{BackgroundTransparency=on and 0 or 1}) Tw(tg,EO,{BackgroundTransparency=on and 0.7 or 1})
    else t.BackgroundColor3=bc kn.Position=kp kn.BackgroundColor3=kc st.Color=sc fl.BackgroundTransparency=on and 0 or 1 tg.BackgroundTransparency=on and 0.7 or 1 end
  end
  t.MouseButton1Click:Connect(function() if shouldSup and shouldSup() then return end local ns=not getV() if ns then sTO() else sTF() end setV(ns) upd(true) end)
  upd(false) return t,upd
end

UIS.InputChanged:Connect(function(i) if not activeSliderUpdate then return end if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then activeSliderUpdate(i.Position.X) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then activeSliderUpdate=nil end end)
function makeSlider(par,mn,mx,st,gV,sV,sz)
  sz=sz or UDim2.new(0,120,0,5)
  local wr=C("Frame",{Size=sz,BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,Active=true,ClipsDescendants=false},par)
  C("UICorner",{CornerRadius=UDim.new(1,0)},wr)
  local fl=C("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=Color3.fromRGB(120,80,230),BorderSizePixel=0},wr)
  C("UICorner",{CornerRadius=UDim.new(1,0)},fl)
  local kn=C("Frame",{Size=UDim2.new(0,11,0,11),Position=UDim2.new(0,0,0.5,-5.5),BackgroundColor3=Color3.fromRGB(240,240,250),BorderSizePixel=0,ZIndex=3},wr)
  C("UICorner",{CornerRadius=UDim.new(1,0)},kn)
  local function rf() if not wr.Parent then return end local v=gV() local pc=(mx~=mn) and math.clamp((v-mn)/(mx-mn),0,1) or 0 fl.Size=UDim2.new(pc,0,1,0) kn.Position=UDim2.new(pc,-5.5,0.5,-5.5) end
  local function uX(x) if not wr or not wr.Parent then activeSliderUpdate=nil return end local w=wr.AbsoluteSize.X if w<=0 then return end local r=math.clamp((x-wr.AbsolutePosition.X)/w,0,1) local v=rd(mn+r*(mx-mn),st) v=math.clamp(v,mn,mx) sV(v) rf() end
  wr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then activeSliderUpdate=uX uX(i.Position.X) end end)
  rf() return wr,rf
end

function bindCtx(o,fn)
  o.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton2 then sSw() fn() end end)
  local pt,sp=nil,nil
  o.InputBegan:Connect(function(i) if i.UserInputType~=Enum.UserInputType.Touch then return end sp=i.Position if pt then task.cancel(pt) end pt=task.delay(0.45,function() pt=nil sSw() fn() end) end)
  o.InputChanged:Connect(function(i) if i.UserInputType~=Enum.UserInputType.Touch then return end if not sp then return end if (i.Position-sp).Magnitude>8 then if pt then task.cancel(pt) pt=nil end end end)
  o.InputEnded:Connect(function(i) if i.UserInputType~=Enum.UserInputType.Touch then return end if pt then task.cancel(pt) pt=nil end sp=nil end)
end

function buildCard(par,opts)
  local sh=C("Frame",{Size=UDim2.new(1,0,0,48),Position=UDim2.new(0,2,0,3),BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.85,BorderSizePixel=0,ZIndex=0},par)
  C("UICorner",{CornerRadius=UDim.new(0,9)},sh)
  local c=C("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0,Active=true,ZIndex=1},par)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  local st=C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(23,23,36)),ColorSequenceKeypoint.new(1,Color3.fromRGB(18,18,28))},Rotation=90},c)
  local hg=C("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(155,108,255),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1},c)
  C("UICorner",{CornerRadius=UDim.new(0,9)},hg)
  local ind=C("Frame",{Size=UDim2.new(0,3,0,20),Position=UDim2.new(0,8,0.5,-10),BackgroundColor3=Color3.fromRGB(155,108,255),BorderSizePixel=0,BackgroundTransparency=1,ZIndex=2},c)
  C("UICorner",{CornerRadius=UDim.new(1,0)},ind)
  C("TextLabel",{Size=UDim2.new(1,-160,0,16),Position=UDim2.new(0,18,0,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=opts.name,TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3},c)
  C("TextLabel",{Size=UDim2.new(1,-160,0,12),Position=UDim2.new(0,18,0,22),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text=opts.desc or "",TextColor3=Color3.fromRGB(130,130,155),TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3},c)
  local kc=C("TextButton",{Size=UDim2.new(0,34,0,18),Position=UDim2.new(1,-114,0.5,-9),BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=3},c)
  C("UICorner",{CornerRadius=UDim.new(0,5)},kc)
  C("UIStroke",{Color=Color3.fromRGB(55,55,80),Thickness=1},kc)
  local kl=C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=tostring(Config[opts.key].Key or "—"),TextColor3=Color3.fromRGB(180,180,210),TextSize=10,ZIndex=4},kc)
  local supT=false
  local tg,tU=makeToggle(c,function() return opts.getEnabled() end,function(v) opts.setEnabled(v) if applyAll then applyAll() end saveCfg() if opts.onChange then opts.onChange(v) end end,function() if supT then supT=false return true end return false end)
  tg.Position=UDim2.new(1,-72,0.5,-9)
  tg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then supT=false end end)
  local function rv()
    local on=opts.getEnabled()
    Tw(ind,EO,{BackgroundTransparency=on and 0 or 1})
    Tw(st,EO,{Color=on and Color3.fromRGB(80,60,140) or Color3.fromRGB(40,40,60),Transparency=on and 0 or 0.2})
    tU(false) kl.Text=tostring(Config[opts.key].Key or "—")
  end
  cardRefreshers[opts.key]=rv rv()
  c.MouseEnter:Connect(function() Tw(c,EO,{BackgroundColor3=Color3.fromRGB(26,26,40)}) Tw(hg,EO,{BackgroundTransparency=0.9}) Tw(st,EO,{Color=Color3.fromRGB(80,70,140),Transparency=0}) end)
  c.MouseLeave:Connect(function() Tw(c,EO,{BackgroundColor3=Color3.fromRGB(21,21,33)}) Tw(hg,EO,{BackgroundTransparency=1}) if not opts.getEnabled() then Tw(st,EO,{Color=Color3.fromRGB(40,40,60),Transparency=0.2}) end end)
  local function oS() if openSettings then openSettings(opts.key) end end
  bindCtx(c,oS) bindCtx(tg,function() supT=true oS() end)
  kc.MouseButton1Click:Connect(function() sC() oS() end)
  return c
end

local SP=C("Frame",{Size=UDim2.new(0,260,0,300),Position=UDim2.new(0.5,-130,0.5,-150),BackgroundColor3=Color3.fromRGB(16,16,26),BorderSizePixel=0,Visible=false,ZIndex=50},SG)
C("UICorner",{CornerRadius=UDim.new(0,11)},SP)
C("UIStroke",{Color=Color3.fromRGB(80,60,140),Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},SP)
local pT=C("TextLabel",{Size=UDim2.new(1,-50,0,30),Position=UDim2.new(0,14,0,4),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Settings",TextColor3=Color3.fromRGB(235,235,245),TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},SP)
local pC=C("TextButton",{Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-30,0,8),BackgroundColor3=Color3.fromRGB(35,35,52),BorderSizePixel=0,Text="✕",Font=Enum.Font.GothamBold,TextColor3=Color3.fromRGB(220,220,235),TextSize=11,AutoButtonColor=false},SP)
C("UICorner",{CornerRadius=UDim.new(0,6)},pC)
closePopup=function() SP.Visible=false listeningKey=false activeSliderUpdate=nil if activeKBConn then pcall(function() activeKBConn:Disconnect() end) activeKBConn=nil end end
pC.MouseButton1Click:Connect(function() sCl() closePopup() end)
local pS=C("ScrollingFrame",{Size=UDim2.new(1,-16,1,-44),Position=UDim2.new(0,8,0,38),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=Color3.fromRGB(80,80,110),CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},SP)
C("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},pS)
C("UIPadding",{PaddingTop=UDim.new(0,2),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,6),PaddingBottom=UDim.new(0,6)},pS)
function pR(lb,ht)
  ht=ht or 26
  local r=C("Frame",{Size=UDim2.new(1,-2,0,ht),BackgroundColor3=Color3.fromRGB(22,22,35),BorderSizePixel=0},pS)
  C("UICorner",{CornerRadius=UDim.new(0,7)},r)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},r)
  if lb~="" then C("TextLabel",{Size=UDim2.new(0.6,0,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=lb,TextColor3=Color3.fromRGB(200,200,220),TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},r) end
  return r
end
openSettings=function(fnK)
  if not Config[fnK] then return end
  listeningKey=false activeSliderUpdate=nil
  if activeKBConn then pcall(function() activeKBConn:Disconnect() end) activeKBConn=nil end
  pS.CanvasPosition=Vector2.new(0,0)
  pT.Text=fnK.."  •  Settings"
  SP.Visible=true SP.Size=UDim2.new(0,240,0,275) SP.Position=UDim2.new(0.5,-120,0.5,-137)
  Tw(SP,ES,{Size=UDim2.new(0,260,0,300),Position=UDim2.new(0.5,-130,0.5,-150)})
  for _,ch in ipairs(pS:GetChildren()) do if ch:IsA("Frame") or ch:IsA("TextButton") then ch:Destroy() end end
  local d=Config[fnK]
  local rE=pR("Enabled")
  local tg=makeToggle(rE,function() return d.Enabled end,function(v) d.Enabled=v if applyAll then applyAll() end refreshCard(fnK) saveCfg() end)
  tg.Position=UDim2.new(1,-42,0.5,-9)
  local function addS(lb,mn,mx,st,k,fm)
    if type(d[k])~="number" then return end
    local r=pR(lb,40)
    local vl=C("TextLabel",{Size=UDim2.new(0,50,0,18),Position=UDim2.new(1,-56,0,4),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=fm(d[k]),TextColor3=Color3.fromRGB(180,140,255),TextSize=10,TextXAlignment=Enum.TextXAlignment.Right},r)
    local sl=makeSlider(r,mn,mx,st,function() return d[k] end,function(v) d[k]=v vl.Text=fm(v) if applyAll then applyAll() end saveDb() end,UDim2.new(1,-20,0,5))
    sl.Position=UDim2.new(0,10,1,-10)
  end
  addS("Value",16,250,1,"Value",function(v) return tostring(math.floor(v)) end)
  addS("Brightness",0.5,8,0.1,"Brightness",function(v) return string.format("%.1f",v) end)
  addS("Time",0,24,0.5,"TimeOfDay",function(v) return string.format("%.1f",v) end)
  addS("FOV",30,500,5,"FOV",function(v) return tostring(math.floor(v)) end)
  addS("Smooth",0.05,1,0.05,"Smooth",function(v) return string.format("%.2f",v) end)
  addS("Power",10,500,5,"Power",function(v) return tostring(math.floor(v)) end)
  if type(d.TeamCheck)=="boolean" then local r=pR("Team Check") local t=makeToggle(r,function() return d.TeamCheck end,function(v) d.TeamCheck=v saveCfg() end) t.Position=UDim2.new(1,-42,0.5,-9) end
  if type(d.ShowFOV)=="boolean" then local r=pR("Show FOV") local t=makeToggle(r,function() return d.ShowFOV end,function(v) d.ShowFOV=v saveCfg() end) t.Position=UDim2.new(1,-42,0.5,-9) end
  do
    local r=pR("Keybind")
    local kb=C("TextButton",{Size=UDim2.new(0,60,0,18),Position=UDim2.new(1,-68,0.5,-9),BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,Text="",AutoButtonColor=false},r)
    C("UICorner",{CornerRadius=UDim.new(0,5)},kb)
    C("UIStroke",{Color=Color3.fromRGB(55,55,80),Thickness=1},kb)
    local kl=C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=tostring(d.Key or "—"),TextColor3=Color3.fromRGB(200,200,230),TextSize=10},kb)
    kb.MouseButton1Click:Connect(function()
      if listeningKey then return end
      sC() listeningKey=true kl.Text="· · ·" kl.TextColor3=Color3.fromRGB(180,140,255)
      if activeKBConn then pcall(function() activeKBConn:Disconnect() end) end
      activeKBConn=UIS.InputBegan:Connect(function(i,gpe) if gpe then return end if i.UserInputType==Enum.UserInputType.Keyboard then local nk=i.KeyCode.Name d.Key=nk for ok,od in pairs(Config) do if ok~=fnK and type(od)=="table" and od.Key==nk then od.Key="None" refreshCard(ok) end end kl.Text=nk kl.TextColor3=Color3.fromRGB(200,200,230) listeningKey=false refreshCard(fnK) saveCfg() sTO() if activeKBConn then pcall(function() activeKBConn:Disconnect() end) activeKBConn=nil end end end)
    end)
  end
  do
    local r=pR("Mode")
    local dd=C("TextButton",{Size=UDim2.new(0,70,0,18),Position=UDim2.new(1,-78,0.5,-9),BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,Text="",AutoButtonColor=false},r)
    C("UICorner",{CornerRadius=UDim.new(0,5)},dd)
    C("UIStroke",{Color=Color3.fromRGB(55,55,80),Thickness=1},dd)
    local dl=C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=d.Mode or "Toggle",TextColor3=Color3.fromRGB(200,200,230),TextSize=10},dd)
    local opts={"Toggle","Hold"}
    dd.MouseButton1Click:Connect(function()
      sC() local i=1 for k,v in ipairs(opts) do if v==d.Mode then i=k end end i=i%#opts+1 d.Mode=opts[i] dl.Text=d.Mode saveCfg()
    end)
  end
  local rB=C("Frame",{Size=UDim2.new(1,-2,0,26),BackgroundTransparency=1},pS)
  local sv=C("TextButton",{Size=UDim2.new(0.5,-3,1,0),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},rB)
  C("UICorner",{CornerRadius=UDim.new(0,7)},sv)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("save"),TextColor3=Color3.fromRGB(255,255,255),TextSize=10},sv)
  sv.MouseButton1Click:Connect(function() sTO() saveCfg() end)
  local cl=C("TextButton",{Size=UDim2.new(0.5,-3,1,0),Position=UDim2.new(0.5,3,0,0),BackgroundColor3=Color3.fromRGB(45,25,60),BorderSizePixel=0,Text="",AutoButtonColor=false},rB)
  C("UICorner",{CornerRadius=UDim.new(0,7)},cl)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("close"),TextColor3=Color3.fromRGB(220,180,200),TextSize=10},cl)
  cl.MouseButton1Click:Connect(function() sCl() closePopup() end)
end

local MainPage=makeTab("Main","★",T("tab_main"))
local MovementPage=makeTab("Movement","➤",T("tab_movement"))
local ToolsPage=makeTab("Tools","⚔",T("tab_tools"))
local VisualsPage=makeTab("Visuals","◈",T("tab_visuals"))
local ShadersPage=makeTab("Shaders","◆",T("tab_shaders"))
local AnimationsPage=makeTab("Animations","🎭",T("tab_animations"))
local SettingsPage=makeTab("Settings","⚙",T("tab_settings"))
updateTabLabels=function()
  if tabs.Main and tabs.Main.lbl then tabs.Main.lbl.Text=T("tab_main") end
  if tabs.Movement and tabs.Movement.lbl then tabs.Movement.lbl.Text=T("tab_movement") end
  if tabs.Tools and tabs.Tools.lbl then tabs.Tools.lbl.Text=T("tab_tools") end
  if tabs.Visuals and tabs.Visuals.lbl then tabs.Visuals.lbl.Text=T("tab_visuals") end
  if tabs.Shaders and tabs.Shaders.lbl then tabs.Shaders.lbl.Text=T("tab_shaders") end
  if tabs.Animations and tabs.Animations.lbl then tabs.Animations.lbl.Text=T("tab_animations") end
  if tabs.Settings and tabs.Settings.lbl then tabs.Settings.lbl.Text=T("tab_settings") end
end

do
  local c=C("Frame",{Size=UDim2.new(1,0,0,68),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},MainPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(60,45,110),Thickness=1},c)
  C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(30,25,50)),ColorSequenceKeypoint.new(1,Color3.fromRGB(21,21,33))},Rotation=90},c)
  local av=C("ImageLabel",{Size=UDim2.new(0,52,0,52),Position=UDim2.new(0,10,0.5,-26),BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,Image=""},c)
  C("UICorner",{CornerRadius=UDim.new(1,0)},av)
  C("UIStroke",{Color=Color3.fromRGB(155,108,255),Thickness=1.5},av)
  task.spawn(function() local ok,u=pcall(function() return Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end) if ok and u then av.Image=u end end)
  C("TextLabel",{Size=UDim2.new(1,-80,0,18),Position=UDim2.new(0,72,0,8),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=LP.DisplayName,TextColor3=Color3.fromRGB(240,240,250),TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},c)
  C("TextLabel",{Size=UDim2.new(1,-80,0,14),Position=UDim2.new(0,72,0,26),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="@"..LP.Name,TextColor3=Color3.fromRGB(130,130,155),TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},c)
  C("TextLabel",{Size=UDim2.new(1,-80,0,12),Position=UDim2.new(0,72,0,42),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="NL "..VER.." · by "..CREATOR,TextColor3=Color3.fromRGB(180,140,255),TextSize=9,TextXAlignment=Enum.TextXAlignment.Left},c)
end

local iC=C("Frame",{Size=UDim2.new(1,0,0,96),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},MainPage)
C("UICorner",{CornerRadius=UDim.new(0,9)},iC)
C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},iC)
local function iR(y,lb)
  C("TextLabel",{Size=UDim2.new(0.5,0,0,18),Position=UDim2.new(0,12,0,y),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=lb,TextColor3=Color3.fromRGB(150,150,175),TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},iC)
  return C("TextLabel",{Size=UDim2.new(0.5,-12,0,18),Position=UDim2.new(0.5,0,0,y),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="—",TextColor3=Color3.fromRGB(220,220,235),TextSize=10,TextXAlignment=Enum.TextXAlignment.Right},iC)
end
local pL=iR(6,T("players_online"))
local gL=iR(26,T("game_name"))
local sL=iR(46,T("server_id"))
local fL=iR(66,T("fps"))
local piL=iR(66,T("ping"))
local _fr=0
local _fc=RunService.RenderStepped:Connect(function() _fr=_fr+1 end)
task.spawn(function()
  pcall(function() gL.Text=game.Name sL.Text=game.JobId~="" and game.JobId:sub(1,12) or "N/A" end)
  local lt=tick()
  while running do
    task.wait(1) if not running then break end
    pL.Text=tostring(#Players:GetPlayers()).." / "..Players.MaxPlayers
    local ct=tick() local dt=ct-lt if dt<=0 then dt=1 end
    local fps=math.clamp(math.floor(_fr/dt),0,999)
    fL.Text=tostring(fps)
    local pg=0 pcall(function() pg=math.floor(LP:GetNetworkPing()*1000) end)
    piL.Text=tostring(math.max(0,pg)).." ms"
    _fr=0 lt=ct
  end
end)

function navC(par,txt,ds,tab,c1,c2)
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},par)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=txt,TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,12),Position=UDim2.new(0,16,0,21),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text=ds,TextColor3=Color3.fromRGB(130,130,155),TextSize=9,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,24),Position=UDim2.new(1,-88,0.5,-12),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)}},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("open"),TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function() sSw() switchTab(tab) end)
end
navC(MainPage,T("tab_movement"),"Speed/Jump/Invis","Movement",Color3.fromRGB(100,200,130),Color3.fromRGB(60,150,100))
navC(MainPage,T("tab_tools"),"TP/Bang/Ride/GP","Tools",Color3.fromRGB(240,90,90),Color3.fromRGB(180,50,50))
navC(MainPage,T("tab_visuals"),"Fullbright/ESP","Visuals",Color3.fromRGB(155,108,255),Color3.fromRGB(90,200,255))
navC(MainPage,T("tab_shaders"),"Cinematic/Sunset","Shaders",Color3.fromRGB(255,140,100),Color3.fromRGB(200,80,60))
navC(MainPage,T("tab_animations"),"adidas Community","Animations",Color3.fromRGB(255,200,100),Color3.fromRGB(200,140,60))
navC(MainPage,T("tab_settings"),"Config/Language","Settings",Color3.fromRGB(200,100,180),Color3.fromRGB(140,70,200))

buildCard(VisualsPage,{name=T("fullbright"),desc="",key="Fullbright",getEnabled=function() return Config.Fullbright.Enabled end,setEnabled=function(v) Config.Fullbright.Enabled=v end})
buildCard(VisualsPage,{name=T("nofog"),desc="",key="NoFog",getEnabled=function() return Config.NoFog.Enabled end,setEnabled=function(v) Config.NoFog.Enabled=v end})
buildCard(VisualsPage,{name=T("esp"),desc="",key="PlayerESP",getEnabled=function() return Config.PlayerESP.Enabled end,setEnabled=function(v) Config.PlayerESP.Enabled=v end})
buildCard(VisualsPage,{name=T("esp_skeleton"),desc="",key="ESPSkeleton",getEnabled=function() return Config.ESPSkeleton.Enabled end,setEnabled=function(v) Config.ESPSkeleton.Enabled=v end})
buildCard(VisualsPage,{name=T("esp_names"),desc="",key="ESPNames",getEnabled=function() return Config.ESPNames.Enabled end,setEnabled=function(v) Config.ESPNames.Enabled=v end})
buildCard(VisualsPage,{name=T("esp_distance"),desc="",key="ESPDistance",getEnabled=function() return Config.ESPDistance.Enabled end,setEnabled=function(v) Config.ESPDistance.Enabled=v end})
buildCard(MovementPage,{name=T("walkspeed"),desc="",key="WalkSpeed",getEnabled=function() return Config.WalkSpeed.Enabled end,setEnabled=function(v) Config.WalkSpeed.Enabled=v end})
buildCard(MovementPage,{name=T("jumppower"),desc="",key="JumpPower",getEnabled=function() return Config.JumpPower.Enabled end,setEnabled=function(v) Config.JumpPower.Enabled=v end})
buildCard(MovementPage,{name=T("infjump"),desc="",key="InfiniteJump",getEnabled=function() return Config.InfiniteJump.Enabled end,setEnabled=function(v) Config.InfiniteJump.Enabled=v end})
buildCard(MovementPage,{name=T("aimbot"),desc="",key="Aimbot",getEnabled=function() return Config.Aimbot.Enabled end,setEnabled=function(v) Config.Aimbot.Enabled=v end})
buildCard(MovementPage,{name=T("zoom"),desc="",key="Zoom",getEnabled=function() return Config.Zoom.Enabled end,setEnabled=function(v) Config.Zoom.Enabled=v end})
buildCard(MovementPage,{name=T("godmode"),desc="Multi-layer",key="GodMode",getEnabled=function() return Config.GodMode.Enabled end,setEnabled=function(v) Config.GodMode.Enabled=v end})
buildCard(ToolsPage,{name=T("walkfling"),desc="",key="WalkFling",getEnabled=function() return Config.WalkFling.Enabled end,setEnabled=function(v) Config.WalkFling.Enabled=v end})
buildCard(ToolsPage,{name=T("antibang"),desc="",key="AntiBang",getEnabled=function() return Config.AntiBang.Enabled end,setEnabled=function(v) Config.AntiBang.Enabled=v end})

local _fbS=nil
function applyFB()
  if Config.Fullbright.Enabled then
    if not _fbS then _fbS={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient} end
    Lighting.Brightness=Config.Fullbright.Brightness Lighting.ClockTime=Config.Fullbright.TimeOfDay
    Lighting.Ambient=Color3.fromRGB(178,178,178) Lighting.OutdoorAmbient=Color3.fromRGB(178,178,178)
  else if _fbS then Lighting.Brightness=_fbS.Brightness Lighting.ClockTime=_fbS.ClockTime Lighting.Ambient=_fbS.Ambient Lighting.OutdoorAmbient=_fbS.OutdoorAmbient _fbS=nil end end
end
function applyWS() local c=LP.Character if not c then return end local h=c:FindFirstChildOfClass("Humanoid") if not h then return end h.WalkSpeed=Config.WalkSpeed.Enabled and Config.WalkSpeed.Value or 16 end
function applyJP() local c=LP.Character if not c then return end local h=c:FindFirstChildOfClass("Humanoid") if not h then return end pcall(function() h.UseJumpPower=true end) h.JumpPower=Config.JumpPower.Enabled and Config.JumpPower.Value or 50 end
function applyNoFog() pcall(function() Lighting.FogEnd=100000 Lighting.FogStart=Config.NoFog.Enabled and 100000 or 0 end) end
local _dFOV=(workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView) or 70
function applyZoom() pcall(function() local c=workspace.CurrentCamera if not c then return end c.FieldOfView=Config.Zoom.Enabled and Config.Zoom.Value or _dFOV end) end

local espH,espB,espS={},{},{}
local skF=C("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=3,ClipsDescendants=false},SG)
local SKC={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
local lp2={}
function getL(i) if lp2[i] and lp2[i].Parent then return lp2[i] end local f=C("Frame",{BackgroundColor3=Color3.fromRGB(155,108,255),BorderSizePixel=0,ZIndex=4,Visible=false},skF) lp2[i]=f return f end
function applyHL(p)
  if not Config.PlayerESP.Enabled then if espH[p] and espH[p].Parent then espH[p]:Destroy() end espH[p]=nil return end
  if not p.Character then return end
  local e=espH[p]
  if not e or not e.Parent then local hl=Instance.new("Highlight") hl.Name="NL_ESP" hl.Adornee=p.Character hl.FillColor=Color3.fromRGB(155,108,255) hl.OutlineColor=Color3.fromRGB(255,255,255) hl.FillTransparency=0.6 hl.OutlineTransparency=0.1 hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop hl.Parent=p.Character espH[p]=hl else e.Adornee=p.Character end
end
function applyBB(p)
  if not (Config.ESPNames.Enabled or Config.ESPDistance.Enabled) then if espB[p] and espB[p].Parent then espB[p]:Destroy() end espB[p]=nil return end
  local ch=p.Character if not ch then return end local hd=ch:FindFirstChild("Head") if not hd then return end
  local bb=espB[p]
  if not bb or not bb.Parent or bb.Adornee~=hd then
    if bb and bb.Parent then bb:Destroy() end
    bb=C("BillboardGui",{Name="NL_NT",Size=UDim2.new(0,240,0,60),StudsOffset=Vector3.new(0,3.4,0),AlwaysOnTop=true,LightInfluence=0,MaxDistance=500,Adornee=hd,Parent=hd})
    local nh=C("Frame",{Name="NH",Size=UDim2.new(1,0,0,26),BackgroundTransparency=1},bb)
    for i=1,4 do C("TextLabel",{Name="NG"..i,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=p.Name,TextColor3=Color3.fromRGB(155,108,255),TextTransparency=0.85-i*0.05,TextSize=22+i*2,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,ZIndex=1},nh) end
    local nl=C("TextLabel",{Name="NL",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=p.Name,TextColor3=Color3.fromRGB(255,255,255),TextStrokeColor3=Color3.fromRGB(80,40,180),TextStrokeTransparency=0,TextSize=22,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,ZIndex=3},nh)
    C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(200,160,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,200,255))}},nl)
    local dh=C("Frame",{Name="DH",Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,0,26),BackgroundTransparency=1},bb)
    for i=1,3 do C("TextLabel",{Name="DG"..i,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="0m",TextColor3=Color3.fromRGB(90,200,255),TextTransparency=0.85-i*0.05,TextSize=15+i*2,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,ZIndex=1},dh) end
    C("TextLabel",{Name="DL",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="0m",TextColor3=Color3.fromRGB(255,255,255),TextStrokeColor3=Color3.fromRGB(0,80,150),TextStrokeTransparency=0,TextSize=15,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,ZIndex=3},dh)
    espB[p]=bb
  end
end
task.spawn(function()
  while running do
    task.wait(0.1) if not running then break end
    local any=Config.PlayerESP.Enabled or Config.ESPSkeleton.Enabled or Config.ESPNames.Enabled or Config.ESPDistance.Enabled
    for p,_ in pairs(espH) do if p==LP or not p.Parent then if espH[p] and espH[p].Parent then espH[p]:Destroy() end espH[p]=nil end end
    for p,_ in pairs(espB) do if p==LP or not p.Parent then if espB[p] and espB[p].Parent then espB[p]:Destroy() end espB[p]=nil end end
    if any then for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then applyHL(p) applyBB(p) end end end
  end
end)
task.spawn(function()
  while running do
    RunService.RenderStepped:Wait()
    if not running then break end
    if Config.ESPSkeleton.Enabled then
      local cam=workspace.CurrentCamera if not cam then continue end
      for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
          local ch=p.Character
          local d=espS[p] if not d then d={lines={}} espS[p]=d end
          for i,cn in ipairs(SKC) do
            local p1=ch:FindFirstChild(cn[1]) local p2=ch:FindFirstChild(cn[2])
            if p1 and p2 and p1:IsA("BasePart") and p2:IsA("BasePart") then
              local v1,o1=cam:WorldToViewportPoint(p1.Position)
              local v2,o2=cam:WorldToViewportPoint(p2.Position)
              local ln=d.lines[i]
              if not ln or not ln.Parent then ln=getL(#lp2+1) d.lines[i]=ln end
              if o1 and o2 and v1.Z>0 and v2.Z>0 then
                local df=Vector2.new(v2.X-v1.X,v2.Y-v1.Y)
                local le=df.Magnitude
                local ce=Vector2.new((v1.X+v2.X)/2,(v1.Y+v2.Y)/2)
                local an=math.deg(math.atan2(df.Y,df.X))
                ln.Visible=true ln.Position=UDim2.new(0,ce.X,0,ce.Y) ln.Size=UDim2.new(0,le,0,1.5) ln.Rotation=an ln.AnchorPoint=Vector2.new(0.5,0.5)
              else ln.Visible=false end
            end
          end
        end
      end
    else
      for _,d in pairs(espS) do for _,l in pairs(d.lines or {}) do if l and l.Parent then l.Visible=false end end end
    end
  end
end)
task.spawn(function()
  while running do
    task.wait(0.15) if not running then break end
    local mc=LP.Character local mh=mc and mc:FindFirstChild("HumanoidRootPart")
    for p,bb in pairs(espB) do
      if bb and bb.Parent then
        local nh=bb:FindFirstChild("NH") local dh=bb:FindFirstChild("DH")
        if nh then nh.Visible=Config.ESPNames.Enabled for _,ch in ipairs(nh:GetChildren()) do if ch:IsA("TextLabel") then ch.Text=p.Name end end end
        if dh then
          dh.Visible=Config.ESPDistance.Enabled
          if mh and p.Character then local th=p.Character:FindFirstChild("HumanoidRootPart")
            if th then
              local d=(th.Position-mh.Position).Magnitude
              local txt=string.format("%.0fm",d)
              local col= d<30 and Color3.fromRGB(255,80,80) or (d<100 and Color3.fromRGB(255,180,80)) or (d<250 and Color3.fromRGB(255,255,100)) or Color3.fromRGB(90,200,255)
              for _,ch in ipairs(dh:GetChildren()) do if ch:IsA("TextLabel") then ch.Text=txt if ch.Name~="DL" then ch.TextColor3=col end end end
            end
          end
        end
      end
    end
  end
end)
Players.PlayerRemoving:Connect(function(p) if espH[p] and espH[p].Parent then espH[p]:Destroy() end espH[p]=nil if espB[p] and espB[p].Parent then espB[p]:Destroy() end espB[p]=nil espS[p]=nil end)
function applyESP() end

function getAT()
  local lc=LP.Character if not lc then return nil end
  local lh=lc:FindFirstChildOfClass("Humanoid") if not lh or lh.Health<=0 then return nil end
  local ct=Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
  local cl,cd=nil,math.huge
  for _,p in ipairs(Players:GetPlayers()) do
    if p~=LP and p.Character then
      local hd=p.Character:FindFirstChild("Head") local h=p.Character:FindFirstChildOfClass("Humanoid")
      if hd and h and h.Health>0 then
        local sk=false
        if Config.Aimbot.TeamCheck and p.Team and LP.Team and p.Team==LP.Team then sk=true end
        if not sk then
          local po,on=camera:WorldToViewportPoint(hd.Position)
          if on then local d=(Vector2.new(po.X,po.Y)-ct).Magnitude if d<=Config.Aimbot.FOV and d<cd then cl=hd cd=d end end
        end
      end
    end
  end
  return cl
end
task.spawn(function()
  while running do
    RunService.RenderStepped:Wait()
    if Config.Aimbot.Enabled then
      local t=getAT() if t then local cu=camera.CFrame local wa=CFrame.new(cu.Position,t.Position) camera.CFrame=cu:Lerp(wa,Config.Aimbot.Smooth) end
    end
  end
end)
local fovC=C("Frame",{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=5,Visible=false},SG)
C("UICorner",{CornerRadius=UDim.new(1,0)},fovC)
C("UIStroke",{Color=Color3.fromRGB(155,108,255),Thickness=1.5,Transparency=0.3},fovC)
task.spawn(function()
  while running do
    RunService.RenderStepped:Wait()
    if Config.Aimbot.Enabled and Config.Aimbot.ShowFOV then
      fovC.Visible=true
      local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
      local ms=math.min(vp.X,vp.Y)-20
      local sz=math.min(Config.Aimbot.FOV*2,ms)
      fovC.Size=UDim2.new(0,sz,0,sz)
    else fovC.Visible=false end
  end
end)

local _gm=false local _gmC=nil local _gmH=false local _gmO=nil local cCon={}
function clrCon() for _,c in ipairs(cCon) do if c and c.Connected then pcall(function() c:Disconnect() end) end end table.clear(cCon) end
function isMyH(o) if not o or typeof(o)~="Instance" then return false end if not o:IsA("Humanoid") then return false end local c=o.Parent if not c then return false end return Players:GetPlayerFromCharacter(c)==LP end
function instHook()
  if _gmH then return end _gmH=true
  pcall(function()
    if type(getrawmetatable)~="function" then return end
    local mt=getrawmetatable(game) local oI=mt.__index local oN=mt.__newindex local oNC=mt.__namecall
    if type(setreadonly)=="function" then setreadonly(mt,false) end
    mt.__index=newcclosure(function(s,k) if _gm and isMyH(s) and k=="Health" then return s.MaxHealth end return oI(s,k) end)
    mt.__newindex=newcclosure(function(s,k,v) if _gm and isMyH(s) and k=="Health" then if typeof(v)=="number" and v<s.MaxHealth then return oN(s,k,s.MaxHealth) end end return oN(s,k,v) end)
    mt.__namecall=newcclosure(function(s,...) local m=getnamecallmethod() if _gm and isMyH(s) and (m=="TakeDamage" or m=="BreakJoints") then return nil end return oNC(s,...) end)
    if type(setreadonly)=="function" then setreadonly(mt,true) end
  end)
end
function enGM()
  local c=LP.Character local h=c and c:FindFirstChildOfClass("Humanoid") if not h then notify("God","N/A",2) return end
  _gm=true instHook()
  pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Dead,false) end)
  pcall(function() h.BreakJointsOnDeath=false end)
  _gmO=h.MaxHealth
  pcall(function() h.MaxHealth=1e9 h.Health=1e9 end)
  table.insert(cCon,h.Died:Connect(function() if _gm then pcall(function() h.MaxHealth=1e9 h.Health=1e9 end) end end))
  table.insert(cCon,h.HealthChanged:Connect(function(n) if _gm and n<1e9 then pcall(function() h.Health=1e9 end) end end))
  table.insert(cCon,h.StateChanged:Connect(function(_,n) if _gm and n==Enum.HumanoidStateType.Landed then pcall(function() local r=c:FindFirstChild("HumanoidRootPart") if r then local v=r.AssemblyLinearVelocity if v.Y<-50 then r.AssemblyLinearVelocity=Vector3.new(v.X,0,v.Z) end end end) end end))
  if _gmC then _gmC:Disconnect() end
  _gmC=RunService.Heartbeat:Connect(function() if not _gm then return end local cc=LP.Character if not cc then return end local hh=cc:FindFirstChildOfClass("Humanoid") if hh then if hh.MaxHealth~=1e9 then pcall(function() hh.MaxHealth=1e9 end) end if hh.Health~=1e9 then pcall(function() hh.Health=1e9 end) end end end)
  notify("God","ON",2) sTO()
end
function disGM()
  _gm=false if _gmC then _gmC:Disconnect() _gmC=nil end clrCon()
  local c=LP.Character local h=c and c:FindFirstChildOfClass("Humanoid")
  if h then pcall(function() h.MaxHealth=_gmO or 100 if h.Health>_gmO then h.Health=_gmO end end) end
  _gmO=nil notify("God","OFF",1.5) sTF()
end

local wf=nil
function applyWF()
  if not Config.WalkFling.Enabled then if wf then pcall(function() wf:Destroy() end) wf=nil end return end
  local c=LP.Character local r=c and c:FindFirstChild("HumanoidRootPart") if not r then return end
  if not wf then wf=Instance.new("BodyAngularVelocity") wf.AngularVelocity=Vector3.new(0,Config.WalkFling.Power,0) wf.MaxTorque=Vector3.new(1e6,1e6,1e6) wf.P=5000 wf.Parent=r else wf.AngularVelocity=Vector3.new(0,Config.WalkFling.Power,0) end
end

function applyAFK() pcall(function() LP.Idled:Connect(function() if Config.AntiAFK.Enabled then local vu=game:GetService("VirtualUser") vu:CaptureController() vu:ClickButton2(Vector2.new()) end end) end) end
applyAFK()

local _fbs=nil
function applyFPSB()
  if not Config.FPSBoost.Enabled then
    if _fbs then pcall(function() Lighting.GlobalShadows=_fbs.gs Lighting.Brightness=_fbs.br workspace.Terrain.Decoration=_fbs.dec end) for p,_ in pairs(_fbs.pt) do pcall(function() if p.Parent then p.Enabled=true end end) end _fbs=nil end
    return
  end
  _fbs={gs=Lighting.GlobalShadows,br=Lighting.Brightness,dec=workspace.Terrain.Decoration,pt={}}
  pcall(function() Lighting.GlobalShadows=false Lighting.Brightness=1 workspace.Terrain.Decoration=false end)
  for _,p in ipairs(workspace:GetDescendants()) do if p:IsA("ParticleEmitter") and not p.Name:find("^NL_") then _fbs.pt[p]=p.Enabled pcall(function() p.Enabled=false end) end end
end

function giveTP()
  local bp=LP:FindFirstChildOfClass("Backpack") local c=LP.Character
  if bp then for _,it in ipairs(bp:GetChildren()) do if it.Name=="NL_TPTool" then it:Destroy() end end end
  if c then for _,it in ipairs(c:GetChildren()) do if it.Name=="NL_TPTool" then it:Destroy() end end end
  local t=Instance.new("Tool") t.Name="NL_TPTool" t.RequiresHandle=false t.CanBeDropped=false t.ToolTip="TP"
  t.Activated:Connect(function() pcall(function() local m=LP:GetMouse() local h=m.Hit if h then local cc=LP.Character local r=cc and cc:FindFirstChild("HumanoidRootPart") if r then r.CFrame=CFrame.new(h.Position+Vector3.new(0,3,0)) end end end) end)
  t.Parent=bp or c sTO() notify("TP Tool","OK",2)
end
function tpTo(p)
  if not p then return end
  local mc=LP.Character local mh=mc and mc:FindFirstChild("HumanoidRootPart")
  local th=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
  if mh and th then mh.CFrame=th.CFrame*CFrame.new(0,3,-3) sTp() notify("TP","→ "..p.Name,1.5) end
end
function fuzzy(q) q=(q or ""):lower() if q=="" then return nil end for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Name:lower()==q then return p end end for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Name:lower():sub(1,#q)==q then return p end end for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Name:lower():find(q,1,true) then return p end end return nil end
function doBang(t) if not t or not t.Character then return end local r=t.Character:FindFirstChild("HumanoidRootPart") if not r then return end pcall(function() local bv=Instance.new("BodyVelocity") bv.MaxForce=Vector3.new(1e5,1e5,1e5) bv.Velocity=Vector3.new(math.random(-200,200),math.random(100,400),math.random(-200,200)) bv.Parent=r task.delay(0.25,function() pcall(function() bv:Destroy() end) end) end) end
local _sC,_sT=nil,nil
function sitH(t)
  if not t or not t.Character then return end
  local th=t.Character:FindFirstChild("Head") local mc=LP.Character local mh=mc and mc:FindFirstChild("HumanoidRootPart")
  if not th or not mh then return end
  if _sC then _sC:Disconnect() _sC=nil end
  _sT=t
  _sC=RunService.Heartbeat:Connect(function()
    if not running or not _sT then if _sC then _sC:Disconnect() _sC=nil end return end
    local h=_sT.Character and _sT.Character:FindFirstChild("Head") local mh2=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not h or not mh2 then if _sC then _sC:Disconnect() _sC=nil end return end
    mh2.CFrame=h.CFrame*CFrame.new(0,2.5,0)
  end)
  task.delay(30,function() if _sC then _sC:Disconnect() _sC=nil end end)
end

local _fp={} local _fpH=false
function hasFP(id) return _fp[tostring(id)]==true end
function instFP()
  if _fpH then return end _fpH=true
  pcall(function()
    if type(hookfunction)~="function" then error("no") end
    local o=MPS.UserOwnsGamePassAsync
    hookfunction(o,function(s,u,g) if hasFP(g) then return true end return o(s,u,g) end)
  end)
  pcall(function()
    if type(getrawmetatable)~="function" then return end
    local mt=getrawmetatable(game) local oN=mt.__namecall
    if type(setreadonly)=="function" then setreadonly(mt,false) end
    mt.__namecall=newcclosure(function(s,...)
      local m=getnamecallmethod() local a={...}
      if s==MPS then if m=="UserOwnsGamePassAsync" and hasFP(a[2]) then return true end if m=="PlayerOwnsAsset" and hasFP(a[2]) then return true end if m=="CheckUserOwnsAsset" and hasFP(a[2]) then return true end end
      return oN(s,...)
    end)
    if type(setreadonly)=="function" then setreadonly(mt,true) end
  end)
end
function freeFP(id)
  id=tostring(id):gsub("%s","")
  if id=="" then notify("Fake GP","Enter ID",2) return false end
  instFP() _fp[id]=true
  pcall(function() if MPS.SignalPromptGamePassPurchaseFinished then MPS:SignalPromptGamePassPurchaseFinished(LP,tonumber(id),true) end end)
  notify("Fake GP","Activated: "..id,2.5) sTO() return true
end
function clearFP(id)
  id=tostring(id):gsub("%s","")
  if id=="" then for k in pairs(_fp) do _fp[k]=nil end notify("Fake GP","All cleared",2) else _fp[id]=nil notify("Fake GP","Removed: "..id,2) end
  sTF()
end

local _pA=false local _pS={}
function panicRestore()
  if _pA then
    _pA=false
    for k,s in pairs(_pS) do if Config[k] then Config[k].Enabled=s end end
    _pS={}
    Main.Visible=true enBlur() if applyAll then applyAll() end
    for k in pairs(cardRefreshers) do refreshCard(k) end
    notify("RESTORE","Features restored",2)
    return
  end
  _pA=true _pS={}
  for k,v in pairs(Config) do if type(v)=="table" and v.Enabled~=nil then _pS[k]=v.Enabled end end
  for k in pairs(_pS) do Config[k].Enabled=false end
  if restoreAll then restoreAll() end
  if _gm then disGM() end
  if Config.Shader~="none" then pcall(function() for _,e in ipairs(Lighting:GetChildren()) do if e.Name:find("^NL_") then e:Destroy() end end end) Config.Shader="none" end
  Main.Visible=false closePopup() disBlur() fovC.Visible=false
  if ride and ride.active then disableRide() end
  for p,h in pairs(espH) do if h and h.Parent then h:Destroy() end end espH={}
  for p,b in pairs(espB) do if b and b.Parent then b:Destroy() end end espB={}
  for _,d in pairs(espS) do for _,l in pairs(d.lines or {}) do if l and l.Parent then l.Visible=false end end end
  notify("PANIC","All off · End to restore",2)
end

local ride={active=false,target=nil,speed=60,tiltMax=25,input={},dpad=nil,conn=nil,analogX=0,analogY=0}
function buildJoy()
  if ride.dpad then ride.dpad:Destroy() end
  local pad=C("Frame",{Size=UDim2.new(0,140,0,140),Position=UDim2.new(1,-170,1,-170),AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.fromRGB(15,15,25),BackgroundTransparency=0.35,BorderSizePixel=0,ZIndex=88,Active=true},SG)
  ride.dpad=pad
  C("UICorner",{CornerRadius=UDim.new(1,0)},pad)
  C("UIStroke",{Color=Color3.fromRGB(155,108,255),Thickness=2,Transparency=0.2},pad)
  C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(30,25,55)),ColorSequenceKeypoint.new(1,Color3.fromRGB(20,20,35))},Rotation=135},pad)
  local ah=C("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=89},pad)
  for _,a in ipairs({{text="▲",pos=UDim2.new(0.5,0,0,10),anc=Vector2.new(0.5,0)},{text="▼",pos=UDim2.new(0.5,0,1,-10),anc=Vector2.new(0.5,1)},{text="◀",pos=UDim2.new(0,10,0.5,0),anc=Vector2.new(0,0.5)},{text="▶",pos=UDim2.new(1,-10,0.5,0),anc=Vector2.new(1,0.5)}}) do
    C("TextLabel",{Size=UDim2.new(0,14,0,14),Position=a.pos,AnchorPoint=a.anc,BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=a.text,TextColor3=Color3.fromRGB(155,108,255),TextTransparency=0.55,TextSize=10,ZIndex=89},ah)
  end
  local ir=C("Frame",{Size=UDim2.new(0,90,0,90),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=89},pad)
  C("UICorner",{CornerRadius=UDim.new(1,0)},ir)
  C("UIStroke",{Color=Color3.fromRGB(155,108,255),Thickness=1,Transparency=0.7},ir)
  local kS=56
  local kn=C("Frame",{Size=UDim2.new(0,kS,0,kS),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.fromRGB(155,108,255),BorderSizePixel=0,ZIndex=91},pad)
  C("UICorner",{CornerRadius=UDim.new(1,0)},kn)
  C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(200,160,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,150,240))},Rotation=135},kn)
  C("UIStroke",{Color=Color3.fromRGB(255,255,255),Thickness=1.5,Transparency=0.3},kn)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="✥",TextColor3=Color3.fromRGB(255,255,255),TextTransparency=0.15,TextSize=22,ZIndex=92},kn)
  local kG=C("Frame",{Size=UDim2.new(1,14,1,14),Position=UDim2.new(0,-7,0,-7),BackgroundColor3=Color3.fromRGB(155,108,255),BackgroundTransparency=0.8,BorderSizePixel=0,ZIndex=90},kn)
  C("UICorner",{CornerRadius=UDim.new(1,0)},kG)
  local drag=false local mD=45
  local function uK(ip)
    local pa=pad.AbsolutePosition local ps=pad.AbsoluteSize
    local cx=pa.X+ps.X/2 local cy=pa.Y+ps.Y/2
    local dx=ip.X-cx local dy=ip.Y-cy
    local d=math.sqrt(dx*dx+dy*dy)
    if d>mD then dx=dx/d*mD dy=dy/d*mD end
    kn.Position=UDim2.new(0.5,dx,0.5,dy)
    local nx=dx/mD local ny=dy/mD
    if math.abs(nx)<0.15 then nx=0 end if math.abs(ny)<0.15 then ny=0 end
    ride.analogX=nx ride.analogY=ny
    ride.input.forward=ny<-0.15 ride.input.back=ny>0.15 ride.input.left=nx<-0.15 ride.input.right=nx>0.15
  end
  local function rK() Tw(kn,TweenInfo.new(0.15,Enum.EasingStyle.Quad),{Position=UDim2.new(0.5,0,0.5,0)}) ride.analogX=0 ride.analogY=0 ride.input.forward=false ride.input.back=false ride.input.left=false ride.input.right=false end
  pad.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then drag=true Tw(pad,EO,{BackgroundTransparency=0.15}) uK(i.Position) end end)
  UIS.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.Touch then uK(i.Position) end end)
  UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then drag=false Tw(pad,EO,{BackgroundTransparency=0.35}) rK() end end)
end
function enRide(t)
  if not t or not t.Character then notify("Ride","N/A",2) return false end
  local th=t.Character:FindFirstChild("HumanoidRootPart") local mc=LP.Character local mh=mc and mc:FindFirstChild("HumanoidRootPart")
  if not th or not mh then notify("Ride","No HRP",2) return false end
  ride.active=true ride.target=t
  mh.CFrame=th.CFrame*CFrame.new(0,3.5,0)
  local mh2=mc:FindFirstChildOfClass("Humanoid") if mh2 then pcall(function() mh2.PlatformStand=true mh2.AutoRotate=false end) end
  if isTouch() then buildJoy() end
  if ride.conn then ride.conn:Disconnect() end
  ride.conn=RunService.Heartbeat:Connect(function(dt)
    if not ride.active then return end
    local tg=ride.target
    if not tg or not tg.Character then disableRide() return end
    local tHRP=tg.Character:FindFirstChild("HumanoidRootPart")
    local myC=LP.Character local myH=myC and myC:FindFirstChild("HumanoidRootPart")
    if not tHRP or not myH then return end
    local move=Vector3.new()
    local cam=workspace.CurrentCamera
    local cl=cam.CFrame.LookVector local cr=cam.CFrame.RightVector
    local fw=Vector3.new(cl.X,0,cl.Z) if fw.Magnitude>0 then fw=fw.Unit end
    local rt=Vector3.new(cr.X,0,cr.Z) if rt.Magnitude>0 then rt=rt.Unit end
    local ax=ride.analogX or 0 local ay=ride.analogY or 0
    if math.abs(ax)>0.15 or math.abs(ay)>0.15 then move=move+fw*(-ay)+rt*ax end
    if UIS:IsKeyDown(Enum.KeyCode.W) then move=move+fw end
    if UIS:IsKeyDown(Enum.KeyCode.S) then move=move-fw end
    if UIS:IsKeyDown(Enum.KeyCode.A) then move=move-rt end
    if UIS:IsKeyDown(Enum.KeyCode.D) then move=move+rt end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then move=move+Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move=move-Vector3.new(0,1,0) end
    if move.Magnitude>0 then
      local st=move.Unit*ride.speed*dt
      local np=tHRP.Position+st
      tHRP.CFrame=CFrame.new(np)*(tHRP.CFrame-tHRP.Position)
    end
    local base=tHRP.CFrame*CFrame.new(0,3.5,0)
    local tX,tZ=0,0
    if move.Magnitude>0.01 then
      local ld=tHRP.CFrame:VectorToObjectSpace(move)
      tZ=math.clamp(-ld.X,-1,1)*math.rad(ride.tiltMax)
      tX=math.clamp(ld.Z,-1,1)*math.rad(ride.tiltMax)
    end
    local tlt=CFrame.Angles(tX,0,tZ)
    myH.CFrame=base*tlt
    myH.AssemblyLinearVelocity=Vector3.new(0,0,0)
    myH.AssemblyAngularVelocity=Vector3.new(0,0,0)
  end)
  notify("Ride","→ "..t.Name,2) sTO() return true
end
function disableRide()
  ride.active=false
  if ride.conn then ride.conn:Disconnect() ride.conn=nil end
  if ride.dpad then ride.dpad:Destroy() ride.dpad=nil end
  local mc=LP.Character local mh=mc and mc:FindFirstChildOfClass("Humanoid")
  if mh then pcall(function() mh.PlatformStand=false mh.AutoRotate=true end) end
  ride.target=nil notify("Ride","OFF",1.5) sTF()
end

local inv={active=false,camPos=Vector3.new(0,0,0),yaw=0,pitch=0,speed=70,prev=nil,dpad=nil,input={}}
local IH=Vector3.new(0,100000,0)
function updCam() camera.CFrame=CFrame.new(inv.camPos)*CFrame.fromEulerAnglesYXZ(inv.pitch,inv.yaw,0) end
function buildInvDpad()
  if inv.dpad then inv.dpad:Destroy() end
  local pad=C("Frame",{Size=UDim2.new(0,130,0,130),Position=UDim2.new(0,20,1,-150),BackgroundTransparency=1,ZIndex=88},SG)
  inv.dpad=pad
  local function mk(t,x,y,k)
    local b=C("TextButton",{Size=UDim2.new(0,40,0,40),Position=UDim2.new(0,x,0,y),BackgroundColor3=Color3.fromRGB(30,25,55),BackgroundTransparency=0.35,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=89,Active=true},pad)
    C("UICorner",{CornerRadius=UDim.new(1,0)},b)
    C("UIStroke",{Color=Color3.fromRGB(120,90,220),Thickness=1.5},b)
    C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=t,TextColor3=Color3.fromRGB(220,200,255),TextSize=16,ZIndex=90},b)
    b.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then inv.input[k]=true b.BackgroundTransparency=0.1 end end)
    b.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then inv.input[k]=false b.BackgroundTransparency=0.35 end end)
  end
  mk("↑",45,0,"w") mk("↓",45,90,"s") mk("←",0,45,"a") mk("→",90,45,"d")
end
function enInv()
  local c=LP.Character local r=c and c:FindFirstChild("HumanoidRootPart") if not r then return end
  inv.active=true inv.camPos=camera.CFrame.Position
  local lk=camera.CFrame.LookVector
  inv.yaw=math.atan2(-lk.X,-lk.Z) inv.pitch=math.asin(math.clamp(lk.Y,-1,1))
  r.Anchored=true r.CFrame=CFrame.new(IH)
  for _,d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then pcall(function() d.LocalTransparencyModifier=1 end) end end
  camera.CameraType=Enum.CameraType.Scriptable updCam()
  if isTouch() then buildInvDpad() end
end
function disInv()
  inv.active=false
  local c=LP.Character local r=c and c:FindFirstChild("HumanoidRootPart")
  if r then r.Anchored=false r.CFrame=CFrame.new(inv.camPos) end
  if c then for _,d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then pcall(function() d.LocalTransparencyModifier=0 end) end end end
  camera.CameraType=Enum.CameraType.Custom
  if inv.dpad then inv.dpad:Destroy() inv.dpad=nil end
end
UIS.InputBegan:Connect(function(i,g) if not inv.active then return end if i.UserInputType==Enum.UserInputType.Touch and not g then inv.prev=i.Position end end)
UIS.InputChanged:Connect(function(i)
  if not inv.active then return end
  if i.UserInputType==Enum.UserInputType.Touch then
    if inv.prev then local d=i.Position-inv.prev inv.yaw=inv.yaw-d.X*0.006 inv.pitch=math.clamp(inv.pitch-d.Y*0.006,-1.4,1.4) inv.prev=i.Position updCam() end
  elseif i.UserInputType==Enum.UserInputType.MouseMovement then
    inv.yaw=inv.yaw-i.Delta.X*0.005 inv.pitch=math.clamp(inv.pitch-i.Delta.Y*0.005,-1.4,1.4) updCam()
  end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then inv.prev=nil end end)
task.spawn(function()
  while running do
    local dt=RunService.RenderStepped:Wait()
    if inv.active then
      local fw=Vector3.new(-math.sin(inv.yaw),0,-math.cos(inv.yaw))
      local rt=Vector3.new(math.cos(inv.yaw),0,-math.sin(inv.yaw))
      local m=Vector3.new()
      if UIS:IsKeyDown(Enum.KeyCode.W) or inv.input.w then m=m+fw end
      if UIS:IsKeyDown(Enum.KeyCode.S) or inv.input.s then m=m-fw end
      if UIS:IsKeyDown(Enum.KeyCode.A) or inv.input.a then m=m-rt end
      if UIS:IsKeyDown(Enum.KeyCode.D) or inv.input.d then m=m+rt end
      if UIS:IsKeyDown(Enum.KeyCode.Space) then m=m+Vector3.new(0,1,0) end
      if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then m=m-Vector3.new(0,1,0) end
      if m.Magnitude>0 then inv.camPos=inv.camPos+m.Unit*inv.speed*dt end
      updCam()
    end
  end
end)

local shE={} local _shO=nil local _shDis={}
function saveSHO()
  if _shO then return end
  local t=workspace.Terrain
  _shO={ClockTime=Lighting.ClockTime,Brightness=Lighting.Brightness,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient,GlobalShadows=Lighting.GlobalShadows,ShadowSoftness=Lighting.ShadowSoftness,EnvironmentDiffuseScale=Lighting.EnvironmentDiffuseScale,EnvironmentSpecularScale=Lighting.EnvironmentSpecularScale,ExposureCompensation=Lighting.ExposureCompensation,GeographicLatitude=Lighting.GeographicLatitude,FogEnd=Lighting.FogEnd,FogStart=Lighting.FogStart,FogColor=Lighting.FogColor,WaterColor=t.WaterColor,WaterTransparency=t.WaterTransparency,WaterReflectance=t.WaterReflectance,WaterWaveSize=t.WaterWaveSize,WaterWaveSpeed=t.WaterWaveSpeed}
  _shDis={}
  for _,ch in ipairs(Lighting:GetChildren()) do
    if ch:IsA("ColorCorrectionEffect") or ch:IsA("BloomEffect") or ch:IsA("SunRaysEffect") or ch:IsA("DepthOfFieldEffect") or ch:IsA("Atmosphere") or ch:IsA("BlurEffect") then
      if not ch.Name:find("^NL_") then _shDis[ch]=ch.Enabled end
    end
  end
end
function resSHO()
  if not _shO then return end
  local o=_shO
  Lighting.ClockTime=o.ClockTime Lighting.Brightness=o.Brightness Lighting.Ambient=o.Ambient Lighting.OutdoorAmbient=o.OutdoorAmbient Lighting.GlobalShadows=o.GlobalShadows
  pcall(function() Lighting.ShadowSoftness=o.ShadowSoftness end)
  pcall(function() Lighting.EnvironmentDiffuseScale=o.EnvironmentDiffuseScale end)
  pcall(function() Lighting.EnvironmentSpecularScale=o.EnvironmentSpecularScale end)
  pcall(function() Lighting.ExposureCompensation=o.ExposureCompensation end)
  pcall(function() Lighting.GeographicLatitude=o.GeographicLatitude end)
  pcall(function() Lighting.FogEnd=o.FogEnd Lighting.FogStart=o.FogStart Lighting.FogColor=o.FogColor end)
  pcall(function() local t=workspace.Terrain t.WaterColor=o.WaterColor t.WaterTransparency=o.WaterTransparency t.WaterReflectance=o.WaterReflectance t.WaterWaveSize=o.WaterWaveSize t.WaterWaveSpeed=o.WaterWaveSpeed end)
  for e,en in pairs(_shDis) do if e and e.Parent then pcall(function() e.Enabled=en end) end end
  _shDis={}
end
function clSH() for _,e in ipairs(shE) do if e and e.Parent then pcall(function() e:Destroy() end) end end shE={} end
function disExist() for e,_ in pairs(_shDis) do if e and e.Parent then pcall(function() e.Enabled=false end) end end end
function addE(cl,pr) local e=Instance.new(cl) for k,v in pairs(pr or {}) do e[k]=v end e.Parent=Lighting table.insert(shE,e) return e end
function setW(col,tr,rf,ws,wsp) pcall(function() local t=workspace.Terrain t.WaterColor=col t.WaterTransparency=tr t.WaterReflectance=rf t.WaterWaveSize=ws t.WaterWaveSpeed=wsp end) end
function applyShader(name)
  clSH() Config.Shader=name saveCfg()
  if name~="none" and Config.Fullbright.Enabled then Config.Fullbright.Enabled=false if cardRefreshers.Fullbright then cardRefreshers.Fullbright() end if _fbS then Lighting.Brightness=_fbS.Brightness Lighting.ClockTime=_fbS.ClockTime Lighting.Ambient=_fbS.Ambient Lighting.OutdoorAmbient=_fbS.OutdoorAmbient _fbS=nil end end
  if name=="none" then resSHO() sTF() return end
  saveSHO() disExist()
  Lighting.GlobalShadows=true
  pcall(function() Lighting.ShadowSoftness=0.35 end)
  pcall(function() Lighting.EnvironmentDiffuseScale=0.6 end)
  pcall(function() Lighting.EnvironmentSpecularScale=0.8 end)
  local cc=addE("ColorCorrectionEffect",{Name="NL_CC"})
  local bl=addE("BloomEffect",{Name="NL_Bloom",Intensity=0.7,Size=24,Threshold=1.1})
  local sr=addE("SunRaysEffect",{Name="NL_SunRays",Intensity=0.15,Spread=0.9})
  local atm=addE("Atmosphere",{Name="NL_Atmo",Density=0.3,Offset=0.1,Glare=0.4,Haze=1.2})
  local df=addE("DepthOfFieldEffect",{Name="NL_DOF",FarIntensity=0.05,FocusDistance=50,InFocusRadius=60,NearIntensity=0.1})
  if name=="sunset" then
    Lighting.ClockTime=18 Lighting.Brightness=2.5 Lighting.Ambient=Color3.fromRGB(120,90,80) Lighting.OutdoorAmbient=Color3.fromRGB(180,130,100)
    pcall(function() Lighting.GeographicLatitude=0 end)
    cc.TintColor=Color3.fromRGB(255,190,140) cc.Contrast=0.18 cc.Saturation=0.35
    bl.Intensity=1.1 bl.Size=32 bl.Threshold=1.0
    sr.Intensity=0.35 sr.Spread=1.0
    atm.Color=Color3.fromRGB(255,170,120) atm.Decay=Color3.fromRGB(140,70,60) atm.Density=0.38 atm.Glare=0.6 atm.Haze=1.8
    df.FarIntensity=0.12 setW(Color3.fromRGB(255,170,130),0.35,0.6,0.15,12)
  elseif name=="night" then
    Lighting.ClockTime=0 Lighting.Brightness=1.2 Lighting.Ambient=Color3.fromRGB(60,70,110) Lighting.OutdoorAmbient=Color3.fromRGB(90,110,160)
    pcall(function() Lighting.GeographicLatitude=45 end)
    cc.TintColor=Color3.fromRGB(130,150,220) cc.Contrast=0.22 cc.Saturation=-0.1
    bl.Intensity=0.9 bl.Size=28 bl.Threshold=1.0
    sr.Intensity=0.2 sr.Spread=0.7
    atm.Color=Color3.fromRGB(30,45,85) atm.Decay=Color3.fromRGB(5,10,30) atm.Density=0.42 atm.Glare=0.2 atm.Haze=0.5
    df.FarIntensity=0.18 setW(Color3.fromRGB(30,60,110),0.25,0.85,0.1,8)
  elseif name=="evening" then
    Lighting.ClockTime=20 Lighting.Brightness=1.8 Lighting.Ambient=Color3.fromRGB(100,90,130) Lighting.OutdoorAmbient=Color3.fromRGB(150,130,180)
    cc.TintColor=Color3.fromRGB(210,170,230) cc.Contrast=0.15 cc.Saturation=0.2
    bl.Intensity=1.0 bl.Size=30 bl.Threshold=1.05
    sr.Intensity=0.28 sr.Spread=0.95
    atm.Color=Color3.fromRGB(190,150,220) atm.Decay=Color3.fromRGB(80,50,110) atm.Density=0.35 atm.Glare=0.5 atm.Haze=1.4
    df.FarIntensity=0.1 setW(Color3.fromRGB(150,120,200),0.3,0.75,0.12,10)
  elseif name=="day" then
    Lighting.ClockTime=14 Lighting.Brightness=3 Lighting.Ambient=Color3.fromRGB(140,140,140) Lighting.OutdoorAmbient=Color3.fromRGB(170,170,180)
    cc.TintColor=Color3.fromRGB(255,255,255) cc.Contrast=0.1 cc.Saturation=0.18
    bl.Intensity=1.2 bl.Size=34 bl.Threshold=0.95
    sr.Intensity=0.4 sr.Spread=1.1
    atm.Color=Color3.fromRGB(210,220,240) atm.Decay=Color3.fromRGB(100,120,160) atm.Density=0.25 atm.Glare=0.7 atm.Haze=0.8
    df.FarIntensity=0.06 setW(Color3.fromRGB(120,190,230),0.2,0.9,0.1,14)
  elseif name=="noon" then
    Lighting.ClockTime=12 Lighting.Brightness=4 Lighting.Ambient=Color3.fromRGB(170,170,170) Lighting.OutdoorAmbient=Color3.fromRGB(190,190,195)
    cc.TintColor=Color3.fromRGB(255,252,240) cc.Contrast=0.08 cc.Saturation=0.22
    bl.Intensity=1.4 bl.Size=36 bl.Threshold=0.9
    sr.Intensity=0.5 sr.Spread=1.2
    atm.Color=Color3.fromRGB(230,235,245) atm.Decay=Color3.fromRGB(150,160,180) atm.Density=0.15 atm.Glare=0.9 atm.Haze=0.4
    df.FarIntensity=0.05 setW(Color3.fromRGB(90,180,230),0.15,0.95,0.08,16)
  elseif name=="cinematic" then
    Lighting.ClockTime=17 Lighting.Brightness=2.2 Lighting.Ambient=Color3.fromRGB(90,85,100) Lighting.OutdoorAmbient=Color3.fromRGB(140,130,150)
    pcall(function() Lighting.ShadowSoftness=0.5 end)
    pcall(function() Lighting.EnvironmentSpecularScale=1 end)
    pcall(function() Lighting.EnvironmentDiffuseScale=0.8 end)
    cc.TintColor=Color3.fromRGB(255,220,190) cc.Contrast=0.25 cc.Saturation=0.15
    bl.Intensity=1.3 bl.Size=40 bl.Threshold=0.9
    sr.Intensity=0.55 sr.Spread=1.3
    atm.Color=Color3.fromRGB(255,210,170) atm.Decay=Color3.fromRGB(100,70,60) atm.Density=0.4 atm.Glare=0.8 atm.Haze=2.2
    df.FarIntensity=0.35 df.InFocusRadius=40 df.NearIntensity=0.25
    setW(Color3.fromRGB(180,150,130),0.3,0.7,0.15,10)
  elseif name=="glass" then
    Lighting.ClockTime=15 Lighting.Brightness=3.5 Lighting.Ambient=Color3.fromRGB(180,190,200) Lighting.OutdoorAmbient=Color3.fromRGB(200,210,220)
    pcall(function() Lighting.ShadowSoftness=0.2 end)
    pcall(function() Lighting.EnvironmentSpecularScale=1 end)
    pcall(function() Lighting.EnvironmentDiffuseScale=1 end)
    pcall(function() Lighting.ExposureCompensation=0.15 end)
    cc.TintColor=Color3.fromRGB(240,250,255) cc.Contrast=0.35 cc.Saturation=0.2
    bl.Intensity=1.6 bl.Size=45 bl.Threshold=0.85
    sr.Intensity=0.7 sr.Spread=1.4
    atm.Color=Color3.fromRGB(230,240,250) atm.Decay=Color3.fromRGB(180,200,230) atm.Density=0.2 atm.Glare=1.0 atm.Haze=0.3
    df.FarIntensity=0.15 setW(Color3.fromRGB(200,240,255),0.05,1.0,0.05,20)
  end
  sTO()
end
do
  local opts={{"none","No Shader"},{"sunset","Sunset"},{"night","Night"},{"evening","Evening"},{"day","Day"},{"noon","Noon"},{"cinematic","Cinematic"},{"glass","Glass World"}}
  for _,o in ipairs(opts) do
    local c=C("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},ShadersPage)
    C("UICorner",{CornerRadius=UDim.new(0,9)},c)
    C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
    C("TextLabel",{Size=UDim2.new(1,-100,1,0),Position=UDim2.new(0,16,0,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=o[2],TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
    local b=C("TextButton",{Size=UDim2.new(0,70,0,24),Position=UDim2.new(1,-82,0.5,-12),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
    C("UICorner",{CornerRadius=UDim.new(0,7)},b)
    C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="ON",TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
    b.MouseButton1Click:Connect(function() applyShader(o[1]) notify("Shader",o[2],1.5) end)
  end
end

-- ... (остальные блоки — Tools, Player List, Movement, Animations, Settings, Boot — такие же как в v12)-- TOOLS CARDS
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},ToolsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("tptool"),TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,24),Position=UDim2.new(1,-88,0.5,-12),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("give"),TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function() sC() giveTP() end)
end
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,140),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},ToolsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(120,60,180),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-20,0,16),Position=UDim2.new(0,16,0,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Fake GamePass",TextColor3=Color3.fromRGB(240,220,255),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  C("TextLabel",{Size=UDim2.new(1,-20,0,12),Position=UDim2.new(0,16,0,22),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="ID → Free · Activate",TextColor3=Color3.fromRGB(140,120,180),TextSize=9,TextXAlignment=Enum.TextXAlignment.Left},c)
  local ib=C("TextBox",{Size=UDim2.new(1,-20,0,26),Position=UDim2.new(0,10,0,42),BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,Font=Enum.Font.Gotham,PlaceholderText="GamePass ID",PlaceholderColor3=Color3.fromRGB(120,120,145),Text="",TextColor3=Color3.fromRGB(230,230,240),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,6)},ib)
  C("UIStroke",{Color=Color3.fromRGB(70,50,110),Thickness=1},ib)
  C("UIPadding",{PaddingLeft=UDim.new(0,8)},ib)
  local ll=C("TextLabel",{Size=UDim2.new(1,-20,0,14),Position=UDim2.new(0,16,0,74),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="Active: none",TextColor3=Color3.fromRGB(180,140,255),TextSize=9,TextXAlignment=Enum.TextXAlignment.Left},c)
  local function rfl() local ids={} for k in pairs(_fp) do table.insert(ids,k) end ll.Text=#ids==0 and "Active: none" or ("Active: "..table.concat(ids,", ")) end
  local br=C("Frame",{Size=UDim2.new(1,-20,0,30),Position=UDim2.new(0,10,0,96),BackgroundTransparency=1},c)
  C("UIListLayout",{Padding=UDim.new(0,4),FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder},br)
  local function mkB(t,c1,c2,fn,w)
    local b=C("TextButton",{Size=UDim2.new(0,w or 88,1,0),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},br)
    C("UICorner",{CornerRadius=UDim.new(0,6)},b)
    C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)}},b)
    C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=t,TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
    b.MouseButton1Click:Connect(function() sC() fn() end)
    return b
  end
  mkB("Buy",Color3.fromRGB(60,60,90),Color3.fromRGB(40,40,60),function() local id=tonumber(ib.Text) if not id then notify("Fake GP","Enter ID",2) return end pcall(function() MPS:PromptGamePassPurchase(LP,id) end) end,60)
  mkB("Free",Color3.fromRGB(120,80,240),Color3.fromRGB(70,130,240),function() if freeFP(ib.Text) then rfl() ib.Text="" end end,100)
  mkB("Clear",Color3.fromRGB(200,70,70),Color3.fromRGB(140,40,40),function() clearFP(ib.Text) rfl() end,80)
  rfl()
end
local activeAction="teleport"
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,340),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},ToolsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-20,0,16),Position=UDim2.new(0,16,0,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("tpplayer"),TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local sl=C("TextLabel",{Size=UDim2.new(1,-20,0,12),Position=UDim2.new(0,16,0,22),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="Mode: Teleport · tap player",TextColor3=Color3.fromRGB(180,140,255),TextSize=9,TextXAlignment=Enum.TextXAlignment.Left},c)
  local sr=C("TextBox",{Size=UDim2.new(1,-20,0,24),Position=UDim2.new(0,10,0,40),BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,Font=Enum.Font.Gotham,PlaceholderText=T("search_player"),PlaceholderColor3=Color3.fromRGB(120,120,145),Text="",TextColor3=Color3.fromRGB(230,230,240),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,6)},sr)
  C("UIStroke",{Color=Color3.fromRGB(55,55,80),Thickness=1},sr)
  C("UIPadding",{PaddingLeft=UDim.new(0,8)},sr)
  local ar=C("Frame",{Size=UDim2.new(1,-20,0,26),Position=UDim2.new(0,10,0,68),BackgroundTransparency=1},c)
  C("UIListLayout",{Padding=UDim.new(0,4),FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder},ar)
  local ab={}
  local function mkA(id,txt,c1,c2)
    local b=C("TextButton",{Size=UDim2.new(0,76,1,0),BackgroundColor3=Color3.fromRGB(30,30,46),BackgroundTransparency=0.5,BorderSizePixel=0,Text="",AutoButtonColor=false},ar)
    C("UICorner",{CornerRadius=UDim.new(0,6)},b)
    local st=C("UIStroke",{Color=Color3.fromRGB(60,60,90),Thickness=1,Transparency=0.5},b)
    local gr=C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)},Enabled=false},b)
    local lb=C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=txt,TextColor3=Color3.fromRGB(200,200,220),TextSize=9},b)
    b.MouseEnter:Connect(sHv)
    b.MouseButton1Click:Connect(function()
      sSw() activeAction=id
      for aid,a2 in pairs(ab) do local act=(aid==id)
        Tw(a2.btn,EO,{BackgroundTransparency=act and 0 or 0.5})
        Tw(a2.stroke,EO,{Transparency=act and 0 or 0.5,Color=act and Color3.fromRGB(155,108,255) or Color3.fromRGB(60,60,90)})
        a2.grad.Enabled=act
        Tw(a2.lbl,EO,{TextColor3=act and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,220)})
      end
      sl.Text="Mode: "..txt.." · tap player"
    end)
    ab[id]={btn=b,stroke=st,grad=gr,lbl=lb}
  end
  mkA("teleport","TP",Color3.fromRGB(120,80,240),Color3.fromRGB(70,130,240))
  mkA("bang","Bang",Color3.fromRGB(240,90,90),Color3.fromRGB(180,50,50))
  mkA("sithead","Sit",Color3.fromRGB(120,200,130),Color3.fromRGB(60,150,100))
  mkA("ride","Ride",Color3.fromRGB(255,180,80),Color3.fromRGB(220,120,50))
  do local a=ab["teleport"] a.btn.BackgroundTransparency=0 a.stroke.Transparency=0 a.stroke.Color=Color3.fromRGB(155,108,255) a.grad.Enabled=true a.lbl.TextColor3=Color3.fromRGB(255,255,255) end
  local list=C("ScrollingFrame",{Size=UDim2.new(1,-20,0,236),Position=UDim2.new(0,10,0,100),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3,ScrollBarImageColor3=Color3.fromRGB(80,80,110)},c)
  C("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},list)
  local function runA(p)
    if not p then return end
    if activeAction=="teleport" then tpTo(p)
    elseif activeAction=="bang" then sBg() notify(T("bang"),T("bang_warn")..": "..p.Name,5) task.delay(5,function() doBang(p) end)
    elseif activeAction=="sithead" then sSt() notify(T("sithead"),"5s · "..p.Name,5) task.delay(5,function() sitH(p) end)
    elseif activeAction=="ride" then sTO() enRide(p) end
  end
  local function rb(q)
    for _,ch in ipairs(list:GetChildren()) do if ch:IsA("TextButton") or ch:IsA("TextLabel") then ch:Destroy() end end
    q=(q or ""):lower()
    local pl={}
    for _,p in ipairs(Players:GetPlayers()) do if p~=LP and (q=="" or p.Name:lower():find(q,1,true)) then table.insert(pl,p) end end
    if #pl==0 then C("TextLabel",{Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text=T("no_players"),TextColor3=Color3.fromRGB(120,120,145),TextSize=11},list) return end
    for _,p in ipairs(pl) do
      local it=C("TextButton",{Size=UDim2.new(1,-4,0,28),BackgroundColor3=Color3.fromRGB(26,26,40),BorderSizePixel=0,Text="",AutoButtonColor=false},list)
      C("UICorner",{CornerRadius=UDim.new(0,6)},it)
      C("TextLabel",{Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=p.Name,TextColor3=Color3.fromRGB(220,220,235),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left},it)
      it.MouseEnter:Connect(function() sHv() Tw(it,EO,{BackgroundColor3=Color3.fromRGB(40,35,60)}) end)
      it.MouseLeave:Connect(function() Tw(it,EO,{BackgroundColor3=Color3.fromRGB(26,26,40)}) end)
      it.MouseButton1Click:Connect(function() sC() runA(p) end)
    end
  end
  sr:GetPropertyChangedSignal("Text"):Connect(function() rb(sr.Text) end)
  sr.FocusLost:Connect(function(en) if en then local f=fuzzy(sr.Text) if f then sC() runA(f) sr.Text="" end end end)
  rb("")
  task.spawn(function() while running do task.wait(2) if list.Parent then rb(sr.Text) end end end)
end
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},ToolsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Copy Place ID",TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,24),Position=UDim2.new(1,-88,0.5,-12),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Copy",TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function() pcall(function() if setclipboard then setclipboard(tostring(game.PlaceId)) notify("Copied",tostring(game.PlaceId),2) end end) sC() end)
end
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},ToolsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Server Hop",TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,24),Position=UDim2.new(1,-88,0.5,-12),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Hop",TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function()
    sC() notify("Server Hop","Searching...",2)
    pcall(function()
      local h=game:GetService("HttpService")
      local u="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
      local d=h:JSONDecode(game:HttpGet(u))
      for _,s in ipairs(d.data) do if s.id~=game.JobId and s.playing<s.maxPlayers then TS:TeleportToPlaceInstance(game.PlaceId,s.id,LP) return end end
    end)
  end)
end
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},ToolsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Rejoin Server",TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,24),Position=UDim2.new(1,-88,0.5,-12),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Rejoin",TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function() sC() pcall(function() TS:Teleport(game.PlaceId,LP) end) end)
end
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},ToolsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Screenshot Mode",TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,24),Position=UDim2.new(1,-88,0.5,-12),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Hide",TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function()
    sC() Main.Visible=false fovC.Visible=false if nHolder then nHolder.Visible=false end
    notify("Screenshot","UI hidden · End to restore",2)
    task.delay(0.5,function() if nHolder then nHolder.Visible=false end end)
    task.delay(3,function() if nHolder then nHolder.Visible=true end end)
  end)
end

-- MOVEMENT: Invis + Zoom
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},MovementPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("invis"),TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,24),Position=UDim2.new(1,-88,0.5,-12),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(120,80,240)),ColorSequenceKeypoint.new(1,Color3.fromRGB(70,130,240))}},b)
  local lb=C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="ON",TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function()
    sTO()
    if inv.active then disInv() lb.Text="ON" notify(T("invis"),"OFF",1.5) else enInv() lb.Text="OFF" notify(T("invis"),"ON",1.5) end
  end)
end
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},MovementPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("zoom"),TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local vl=C("TextLabel",{Size=UDim2.new(0,50,0,18),Position=UDim2.new(1,-56,0,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=tostring(Config.Zoom.Value),TextColor3=Color3.fromRGB(180,140,255),TextSize=10,TextXAlignment=Enum.TextXAlignment.Right},c)
  local sl=makeSlider(c,20,120,1,function() return Config.Zoom.Value end,function(v) Config.Zoom.Value=v vl.Text=tostring(math.floor(v)) if Config.Zoom.Enabled then camera.FieldOfView=v end saveDb() end,UDim2.new(1,-24,0,5))
  sl.Position=UDim2.new(0,12,0,40)
end

-- ANIMATIONS
local animPacks={{name="adidas Community",idle="rbxassetid://126354114956642",walk="rbxassetid://106810508343012",run="rbxassetid://124765145869332",jump="rbxassetid://115715495289805",fall="rbxassetid://93993406355955",climb="rbxassetid://123695349157584",swim="rbxassetid://106537993816942"}}
local defAnim={idle="rbxassetid://507766666",walk="rbxassetid://507777826",run="rbxassetid://507767714",jump="rbxassetid://507765000",fall="rbxassetid://507767968",climb="rbxassetid://507765644",swim="rbxassetid://507784897"}
function appAnim(pk)
  local c=LP.Character if not c then return false end
  local h=c:FindFirstChildOfClass("Humanoid") if not h then return false end
  local a=h:WaitForChild("Animator",5) if not a then return false end
  local s=c:FindFirstChild("Animate") if not s then return false end
  local mp={idle=pk.idle,walk=pk.walk,run=pk.run,jump=pk.jump,fall=pk.fall,climb=pk.climb,swim=pk.swim}
  local ch=0
  for n,id in pairs(mp) do
    if id and id~="" then
      local f=s:FindFirstChild(n)
      if f then for _,an in ipairs(f:GetChildren()) do if an:IsA("Animation") then an.AnimationId=id ch=ch+1 end end end
    end
  end
  for _,t in ipairs(a:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0.1) end) end
  notify("Anim",pk.name.." · "..ch,2.5) sTO() return true
end
function resetAnim() return appAnim({name="Default",idle=defAnim.idle,walk=defAnim.walk,run=defAnim.run,jump=defAnim.jump,fall=defAnim.fall,climb=defAnim.climb,swim=defAnim.swim}) end
do
  local hd=C("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=Color3.fromRGB(30,25,50),BorderSizePixel=0},AnimationsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},hd)
  C("UIStroke",{Color=Color3.fromRGB(90,60,160),Thickness=1},hd)
  C("TextLabel",{Size=UDim2.new(1,-20,0,16),Position=UDim2.new(0,14,0,8),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="🎭 Animations",TextColor3=Color3.fromRGB(240,220,255),TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},hd)
  C("TextLabel",{Size=UDim2.new(1,-20,0,12),Position=UDim2.new(0,14,0,26),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="Replicated · R15 only",TextColor3=Color3.fromRGB(200,180,255),TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},hd)
  C("TextLabel",{Size=UDim2.new(1,-20,0,12),Position=UDim2.new(0,14,0,42),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="Rig: ?",TextColor3=Color3.fromRGB(150,150,180),TextSize=9,TextXAlignment=Enum.TextXAlignment.Left},hd)
end
for _,pk in ipairs(animPacks) do
  local c=C("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},AnimationsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=pk.name,TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,26),Position=UDim2.new(1,-88,0.5,-13),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,6)},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Play",TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function() sC() appAnim(pk) end)
end
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},AnimationsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Reset",TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,24),Position=UDim2.new(1,-88,0.5,-12),BackgroundColor3=Color3.fromRGB(200,70,70),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,6)},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Reset",TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function() sC() resetAnim() end)
end

-- SETTINGS CARDS
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},SettingsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("language"),TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local cl=C("TextLabel",{Size=UDim2.new(1,-110,0,12),Position=UDim2.new(0,16,0,21),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="auto",TextColor3=Color3.fromRGB(130,130,155),TextSize=9,TextXAlignment=Enum.TextXAlignment.Left},c)
  for _,l in ipairs(LLIST) do if l.code==Config.Lang then cl.Text=l.name end end
  local ar=C("TextButton",{Size=UDim2.new(0,30,0,30),Position=UDim2.new(1,-82,0.5,-15),BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,Text="▼",Font=Enum.Font.GothamBold,TextColor3=Color3.fromRGB(200,200,230),TextSize=12,AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,6)},ar)
  local dd=C("Frame",{Size=UDim2.new(1,0,0,0),Visible=false,ClipsDescendants=true,BackgroundColor3=Color3.fromRGB(16,16,26),BorderSizePixel=0},SettingsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},dd)
  C("UIStroke",{Color=Color3.fromRGB(60,45,110),Thickness=1},dd)
  local sr2=C("TextBox",{Size=UDim2.new(1,-16,0,24),Position=UDim2.new(0,8,0,8),BackgroundColor3=Color3.fromRGB(30,30,46),BorderSizePixel=0,Font=Enum.Font.Gotham,PlaceholderText=T("search_lang"),PlaceholderColor3=Color3.fromRGB(120,120,145),Text="",TextColor3=Color3.fromRGB(230,230,240),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false},dd)
  C("UICorner",{CornerRadius=UDim.new(0,6)},sr2)
  C("UIStroke",{Color=Color3.fromRGB(55,55,80),Thickness=1},sr2)
  C("UIPadding",{PaddingLeft=UDim.new(0,8)},sr2)
  local dl=C("ScrollingFrame",{Size=UDim2.new(1,-16,0,200),Position=UDim2.new(0,8,0,38),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3,ScrollBarImageColor3=Color3.fromRGB(80,80,110)},dd)
  C("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},dl)
  local op=false
  local function rb(q)
    for _,ch in ipairs(dl:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
    q=(q or ""):lower()
    if q=="" then
      local ai=C("TextButton",{Size=UDim2.new(1,-4,0,28),BackgroundColor3=(Config.Lang=="auto") and Color3.fromRGB(50,40,80) or Color3.fromRGB(26,26,40),BorderSizePixel=0,Text="",AutoButtonColor=false},dl)
      C("UICorner",{CornerRadius=UDim.new(0,6)},ai)
      C("TextLabel",{Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text="Auto ("..detectLang()..")",TextColor3=Color3.fromRGB(220,220,235),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left},ai)
      ai.MouseButton1Click:Connect(function() Config.Lang="auto" saveCfg() sTO() cl.Text="Auto ("..detectLang()..")" rb(sr2.Text) if updateTabLabels then updateTabLabels() end end)
    end
    for _,l in ipairs(LLIST) do
      if q=="" or l.name:lower():find(q,1,true) or l.code:lower():find(q,1,true) then
        local iA=(Config.Lang==l.code)
        local it=C("TextButton",{Size=UDim2.new(1,-4,0,28),BackgroundColor3=iA and Color3.fromRGB(50,40,80) or Color3.fromRGB(26,26,40),BorderSizePixel=0,Text="",AutoButtonColor=false},dl)
        C("UICorner",{CornerRadius=UDim.new(0,6)},it)
        C("TextLabel",{Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=l.name..(isLangS(l.code) and "" or " (EN)"),TextColor3=Color3.fromRGB(220,220,235),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left},it)
        it.MouseButton1Click:Connect(function() Config.Lang=isLangS(l.code) and l.code or "en" saveCfg() sTO() cl.Text=l.name rb(sr2.Text) if updateTabLabels then updateTabLabels() end notify("Language",T("lang_note"),3) end)
      end
    end
  end
  ar.MouseButton1Click:Connect(function()
    op=not op
    if op then dd.Visible=true dd.Size=UDim2.new(1,0,0,0) Tw(dd,ES,{Size=UDim2.new(1,0,0,250)}) ar.Text="▲" rb(sr2.Text)
    else Tw(dd,ES,{Size=UDim2.new(1,0,0,0)}) ar.Text="▼" task.delay(0.35,function() if not op then dd.Visible=false end end) end
    sC()
  end)
  sr2:GetPropertyChangedSignal("Text"):Connect(function() rb(sr2.Text) end)
end
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},SettingsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=T("sound_vol"),TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local vl=C("TextLabel",{Size=UDim2.new(0,50,0,18),Position=UDim2.new(1,-56,0,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=tostring(math.floor(Config.Sound.Volume*100)).."%",TextColor3=Color3.fromRGB(180,140,255),TextSize=10,TextXAlignment=Enum.TextXAlignment.Right},c)
  local sl=makeSlider(c,0,1,0.05,function() return Config.Sound.Volume end,function(v) Config.Sound.Volume=v vl.Text=tostring(math.floor(v*100)).."%" saveDb() end,UDim2.new(1,-24,0,5))
  sl.Position=UDim2.new(0,12,0,40)
end
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=Color3.fromRGB(60,15,25),BorderSizePixel=0},SettingsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(200,60,80),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,8),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="🚨 PANIC",TextColor3=Color3.fromRGB(255,220,220),TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,14),Position=UDim2.new(0,16,0,28),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="End / long-tap NL",TextColor3=Color3.fromRGB(255,180,180),TextSize=9,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,84,0,32),Position=UDim2.new(1,-96,0.5,-16),BackgroundColor3=Color3.fromRGB(200,50,70),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="PANIC",TextColor3=Color3.fromRGB(255,255,255),TextSize=11},b)
  b.MouseButton1Click:Connect(function() sC() panicRestore() end)
end
buildCard(SettingsPage,{name="Anti-AFK",desc="No kick for idle",key="AntiAFK",getEnabled=function() return Config.AntiAFK.Enabled end,setEnabled=function(v) Config.AntiAFK.Enabled=v end})
buildCard(SettingsPage,{name="FPS Boost",desc="Disable shadows/particles",key="FPSBoost",getEnabled=function() return Config.FPSBoost.Enabled end,setEnabled=function(v) Config.FPSBoost.Enabled=v end})
do
  local c=C("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=Color3.fromRGB(30,25,50),BorderSizePixel=0},SettingsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(90,60,160),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-20,0,16),Position=UDim2.new(0,14,0,8),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="NL "..VER,TextColor3=Color3.fromRGB(240,220,255),TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},c)
  C("TextLabel",{Size=UDim2.new(1,-20,0,14),Position=UDim2.new(0,14,0,26),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="Create: "..CREATOR,TextColor3=Color3.fromRGB(200,180,255),TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},c)
  C("TextLabel",{Size=UDim2.new(1,-20,0,14),Position=UDim2.new(0,14,0,40),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="TikTok: "..TIKTOK,TextColor3=Color3.fromRGB(150,200,255),TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},c)
end
function mkAB(txt,c1,c2,fn)
  local c=C("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(21,21,33),BorderSizePixel=0},SettingsPage)
  C("UICorner",{CornerRadius=UDim.new(0,9)},c)
  C("UIStroke",{Color=Color3.fromRGB(40,40,60),Thickness=1},c)
  C("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,16,0,5),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=txt,TextColor3=Color3.fromRGB(235,235,245),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},c)
  local b=C("TextButton",{Size=UDim2.new(0,76,0,24),Position=UDim2.new(1,-88,0.5,-12),BackgroundColor3=Color3.fromRGB(70,45,150),BorderSizePixel=0,Text="",AutoButtonColor=false},c)
  C("UICorner",{CornerRadius=UDim.new(0,7)},b)
  C("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,c1 or Color3.fromRGB(120,80,240)),ColorSequenceKeypoint.new(1,c2 or Color3.fromRGB(70,130,240))}},b)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="OK",TextColor3=Color3.fromRGB(255,255,255),TextSize=10},b)
  b.MouseButton1Click:Connect(function() sC() fn() end)
  return c
end
mkAB(T("save_cfg"),Color3.fromRGB(100,200,130),Color3.fromRGB(60,150,100),function() saveCfg() end)
mkAB(T("load_cfg"),Color3.fromRGB(130,100,240),Color3.fromRGB(80,150,240),function() loadCfg() if applyAll then applyAll() end for k in pairs(cardRefreshers) do refreshCard(k) end end)
mkAB(T("reset_cfg"),Color3.fromRGB(240,100,130),Color3.fromRGB(180,60,100),function() resetCfg() if applyAll then applyAll() end for k in pairs(cardRefreshers) do refreshCard(k) end end)
mkAB(T("reset_binds"),Color3.fromRGB(240,170,100),Color3.fromRGB(200,120,60),function() resetBinds() for k in pairs(cardRefreshers) do refreshCard(k) end end)
mkAB(T("toggle_sound"),Color3.fromRGB(120,180,220),Color3.fromRGB(80,130,200),function() Config.Sound.Enabled=not Config.Sound.Enabled saveCfg() notify("Sound",Config.Sound.Enabled and "ON" or "OFF",1.5) end)
mkAB("Test Sound",Color3.fromRGB(180,140,255),Color3.fromRGB(120,80,220),function() sC() task.wait(0.2) sTO() task.wait(0.2) sN() end)
mkAB(T("unload"),Color3.fromRGB(220,90,110),Color3.fromRGB(160,50,70),function()
  if restoreAll then restoreAll() end
  disBlur()
  running=false
  if _fc then pcall(function() _fc:Disconnect() end) end
  if activeKBConn then pcall(function() activeKBConn:Disconnect() end) activeKBConn=nil end
  for k in pairs(_fp) do _fp[k]=nil end
  if SFolder then SFolder:Destroy() end
  SG:Destroy()
end)

-- APPLY ALL
applyAll=function()
  applyFB() applyWS() applyJP() applyNoFog() applyESP() applyZoom() applyWF()
  if Config.GodMode.Enabled and not _gm then enGM() elseif not Config.GodMode.Enabled and _gm then disGM() end
  applyFPSB()
end
restoreAll=function()
  local sv={}
  for k,v in pairs(Config) do if type(v)=="table" and v.Enabled~=nil and k~="Sound" then sv[k]=v.Enabled v.Enabled=false end end
  applyFB() applyWS() applyJP() applyNoFog() applyESP() applyZoom()
  if wf then pcall(function() wf:Destroy() end) wf=nil end
  if _gm then disGM() end
  if inv.active then disInv() end
  if ride and ride.active then disableRide() end
  if Config.FPSBoost.Enabled then applyFPSB() end
  for k,s in pairs(sv) do if Config[k] then Config[k].Enabled=s end end
end

LP.CharacterAdded:Connect(function()
  clrCon()
  task.wait(1)
  for k in pairs(Config) do if type(Config[k])=="table" and Config[k].Enabled and Config[k].Mode=="Hold" then Config[k].Enabled=false refreshCard(k) end end
  _fbS=nil
  if running and applyAll then applyAll() end
end)

task.spawn(function()
  while running do
    task.wait(0.3) if not running then break end
    if Config.WalkSpeed.Enabled then applyWS() end
    if Config.JumpPower.Enabled then applyJP() end
    if Config.Fullbright.Enabled then
      if Lighting.Brightness~=Config.Fullbright.Brightness then Lighting.Brightness=Config.Fullbright.Brightness end
      if Lighting.ClockTime~=Config.Fullbright.TimeOfDay then Lighting.ClockTime=Config.Fullbright.TimeOfDay end
    end
    if Config.Zoom.Enabled and camera.FieldOfView~=Config.Zoom.Value then camera.FieldOfView=Config.Zoom.Value end
    if Config.WalkFling.Enabled then applyWF() end
  end
end)
task.spawn(function()
  while running do
    task.wait(0.5) if not running then break end
    if Config.AntiBang.Enabled then
      pcall(function()
        local c=LP.Character if not c then return end
        local r=c:FindFirstChild("HumanoidRootPart") if not r then return end
        for _,o in ipairs(r:GetChildren()) do if o:IsA("BodyVelocity") or o:IsA("BodyAngularVelocity") or o:IsA("BodyThrust") or o:IsA("BodyPosition") then o:Destroy() end end
      end)
    end
  end
end)
UIS.JumpRequest:Connect(function() if not running or not Config.InfiniteJump.Enabled then return end local c=LP.Character if not c then return end local h=c:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)

local heldState={}
function setFS(k,s,sv)
  if not Config[k] then return end
  if type(Config[k])~="table" or not Config[k].Key then return end
  if Config[k].Enabled==s then return end
  Config[k].Enabled=s refreshCard(k) if applyAll then applyAll() end if sv~=false then saveCfg() end
end
function toggleMainV()
  Main.Visible=not Main.Visible
  if Main.Visible then sOp() enBlur() Main.Size=UDim2.new(0,460,0,326) Tw(Main,ES,{Size=UDim2.new(0,480,0,340)})
  else sCl() closePopup() disBlur() end
end
UIS.InputBegan:Connect(function(i,gpe)
  if gpe or listeningKey then return end
  if i.KeyCode==Enum.KeyCode.RightControl then toggleMainV() return end
  if i.KeyCode==Enum.KeyCode.End then panicRestore() return end
  if i.UserInputType==Enum.UserInputType.Keyboard then
    local kn=i.KeyCode.Name
    for fk,d in pairs(Config) do
      if type(d)=="table" and d.Key==kn and d.Key~="None" then
        if d.Mode=="Hold" then if not heldState[fk] then heldState[fk]=true setFS(fk,true,false) end
        else setFS(fk,not d.Enabled,true) end
      end
    end
  end
end)
UIS.InputEnded:Connect(function(i)
  if i.UserInputType==Enum.UserInputType.Keyboard then
    local kn=i.KeyCode.Name
    for fk,d in pairs(Config) do
      if type(d)=="table" and d.Key==kn and d.Mode=="Hold" then
        if heldState[fk] then heldState[fk]=false setFS(fk,false,false) end
      end
    end
  end
end)

function clampMain()
  local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
  if vp.X<=0 then vp=Vector2.new(1920,1080) end
  local ax=Main.Position.X.Scale*vp.X+Main.Position.X.Offset
  local ay=Main.Position.Y.Scale*vp.Y+Main.Position.Y.Offset
  local sx=Main.AbsoluteSize.X>0 and Main.AbsoluteSize.X or 480
  local sy=Main.AbsoluteSize.Y>0 and Main.AbsoluteSize.Y or 340
  ax=math.clamp(ax,-sx+80,math.max(80,vp.X-80))
  ay=math.clamp(ay,0,math.max(0,vp.Y-40))
  Main.Position=UDim2.new(0,ax,0,ay)
  Config.UI.XS=0 Config.UI.XO=ax Config.UI.YS=0 Config.UI.YO=ay
end
do
  local dr,ds,sp
  TB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true ds=i.Position sp=Main.Position end end)
  UIS.InputChanged:Connect(function(i) if not dr then return end if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local d=i.Position-ds Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y) end end)
  UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then if dr then dr=false clampMain() saveDb() end end end)
end
pcall(function() workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() task.wait(0.05) if Main.Position.X.Scale==0 and Main.Position.Y.Scale==0 then clampMain() end end) end)
MinB.MouseButton1Click:Connect(function() sCl() Main.Visible=false closePopup() disBlur() end)
CloseB.MouseButton1Click:Connect(function()
  if restoreAll then restoreAll() end
  disBlur()
  running=false
  if _fc then pcall(function() _fc:Disconnect() end) end
  if activeKBConn then pcall(function() activeKBConn:Disconnect() end) activeKBConn=nil end
  for k in pairs(_fp) do _fp[k]=nil end
  if SFolder then SFolder:Destroy() end
  SG:Destroy()
end)

if isTouch() then
  local fab=C("TextButton",{Name="NL_FAB",Size=UDim2.new(0,26,0,26),Position=UDim2.new(Config.FAB.XS,Config.FAB.XO,Config.FAB.YS,Config.FAB.YO),BackgroundColor3=Color3.fromRGB(30,25,55),BackgroundTransparency=0.2,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=90,Active=true},SG)
  C("UICorner",{CornerRadius=UDim.new(1,0)},fab)
  C("UIStroke",{Color=Color3.fromRGB(120,90,220),Thickness=1},fab)
  local g2=C("Frame",{Size=UDim2.new(1,-6,1,-6),Position=UDim2.new(0,3,0,3),BackgroundColor3=Color3.fromRGB(155,108,255),BackgroundTransparency=0.85,BorderSizePixel=0,ZIndex=0},fab)
  C("UICorner",{CornerRadius=UDim.new(1,0)},g2)
  C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="NL",TextColor3=Color3.fromRGB(220,200,255),TextSize=9,ZIndex=2},fab)
  local fd,fs2,fo,fm=false,nil,nil,false
  local holdT=nil
  local function clampF()
    local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
    if vp.X<=0 then vp=Vector2.new(1920,1080) end
    local ax=fab.Position.X.Scale*vp.X+fab.Position.X.Offset
    local ay=fab.Position.Y.Scale*vp.Y+fab.Position.Y.Offset
    local sz=fab.AbsoluteSize.X>0 and fab.AbsoluteSize.X or 26
    ax=math.clamp(ax,4,vp.X-sz-4) ay=math.clamp(ay,4,vp.Y-sz-4)
    fab.Position=UDim2.new(0,ax,0,ay)
    Config.FAB.XS=0 Config.FAB.XO=ax Config.FAB.YS=0 Config.FAB.YO=ay
  end
  fab.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch then
      fd=true fm=false fs2=i.Position fo=fab.Position Tw(fab,EO,{BackgroundTransparency=0})
      if holdT then task.cancel(holdT) end
      holdT=task.delay(1.2,function() holdT=nil fd=false fm=true panicRestore() end)
    end
  end)
  UIS.InputChanged:Connect(function(i)
    if not fd then return end
    if i.UserInputType==Enum.UserInputType.Touch then
      local d=i.Position-fs2
      if d.Magnitude>6 then fm=true if holdT then task.cancel(holdT) holdT=nil end end
      fab.Position=UDim2.new(fo.X.Scale,fo.X.Offset+d.X,fo.Y.Scale,fo.Y.Offset+d.Y)
    end
  end)
  UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch and fd then
      fd=false
      if holdT then task.cancel(holdT) holdT=nil end
      Tw(fab,EO,{BackgroundTransparency=0.2})
      if fm then clampF() saveDb() else toggleMainV() end
    end
  end)
end

loadCfg()
saveSHO()
clampMain()
Main.Position=UDim2.new(Config.UI.XS,Config.UI.XO,Config.UI.YS,Config.UI.YO)
Main.Visible=true
switchTab("Main")
applyAll()
if Config.Shader and Config.Shader~="none" then pcall(function() applyShader(Config.Shader) end) end
for k in pairs(cardRefreshers) do refreshCard(k) end
enBlur()
local fp=UDim2.new(Config.UI.XS,Config.UI.XO,Config.UI.YS,Config.UI.YO)
Main.Size=UDim2.new(0,460,0,326)
Main.Position=UDim2.new(fp.X.Scale,fp.X.Offset,fp.Y.Scale,fp.Y.Offset-10)
Tw(Main,TweenInfo.new(0.42,Enum.EasingStyle.Quint),{Size=UDim2.new(0,480,0,340),Position=fp})
task.delay(1.2,function() if running and notify then notify("NL "..VER,"by "..CREATOR.." · TikTok: "..TIKTOK,4) end end)