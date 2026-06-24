local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local PhysicsService = game:GetService('PhysicsService')
local player = Players.LocalPlayer
local playerGui = player:FindFirstChildOfClass('PlayerGui') or game:GetService('CoreGui')

for _, ch in ipairs(playerGui:GetChildren()) do
    if ch.Name=='MultiTabControlPanel' or ch.Name=='InkDestroyerGui' or ch.Name=='SpeedSliderGui' then ch:Destroy() end
end
for _, v in ipairs(workspace:GetChildren()) do if v.Name=='KillAuraRangeCircle' then v:Destroy() end end

-- =========== COLOR PALETTE ===========
local C = {
    bg     = Color3.fromRGB(10,10,10),
    dark   = Color3.fromRGB(6,6,6),
    btn    = Color3.fromRGB(22,22,22),
    btnH   = Color3.fromRGB(32,32,32),
    acc    = Color3.fromRGB(255,20,110),
    on     = Color3.fromRGB(55,210,85),
    off    = Color3.fromRGB(215,55,55),
    txt    = Color3.fromRGB(225,225,225),
    sub    = Color3.fromRGB(130,130,130),
    div    = Color3.fromRGB(28,28,28),
    tabSel = Color3.fromRGB(255,20,110),
    tabDef = Color3.fromRGB(16,16,16),
}
local function corner(p,r) local c=Instance.new('UICorner',p); c.CornerRadius=UDim.new(0,r or 7) end
local function mkDiv(parent,yOff)
    local d=Instance.new('Frame',parent); d.Size=UDim2.new(1,-20,0,1); d.Position=UDim2.new(0,10,0,yOff)
    d.BackgroundColor3=C.div; d.BorderSizePixel=0
end
local function mkBtn(parent,text,yOff,h)
    local b=Instance.new('TextButton'); b.Parent=parent
    b.Size=UDim2.new(1,-20,0,h or 32); b.Position=UDim2.new(0,10,0,yOff)
    b.BackgroundColor3=C.btn; b.BorderSizePixel=0; b.AutoButtonColor=false
    b.Text=text; b.Font=Enum.Font.GothamBold; b.TextSize=12; b.TextColor3=C.txt
    corner(b,7)
    b.MouseEnter:Connect(function() b.BackgroundColor3=C.btnH end)
    b.MouseLeave:Connect(function() b.BackgroundColor3=C.btn end)
    return b
end
local function mkLbl(parent,text,yOff,h,sz,col)
    local l=Instance.new('TextLabel',parent)
    l.Size=UDim2.new(1,-20,0,h or 18); l.Position=UDim2.new(0,10,0,yOff)
    l.BackgroundTransparency=1; l.Text=text; l.Font=Enum.Font.Gotham
    l.TextSize=sz or 11; l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextColor3=col or C.sub; return l
end
local function mkHdr(parent,text,yOff)
    local l=Instance.new('TextLabel',parent)
    l.Size=UDim2.new(1,-20,0,20); l.Position=UDim2.new(0,10,0,yOff)
    l.BackgroundTransparency=1; l.Text=text; l.Font=Enum.Font.GothamBold
    l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextColor3=C.acc; return l
end
local function mkHalfBtn(parent,text,yOff,xOff,w,h)
    local b=Instance.new('TextButton'); b.Parent=parent
    b.Size=UDim2.new(0,w,0,h or 30); b.Position=UDim2.new(0,xOff,0,yOff)
    b.BackgroundColor3=C.btn; b.BorderSizePixel=0; b.AutoButtonColor=false
    b.Text=text; b.Font=Enum.Font.GothamBold; b.TextSize=11; b.TextColor3=C.txt
    corner(b,7)
    b.MouseEnter:Connect(function() b.BackgroundColor3=C.btnH end)
    b.MouseLeave:Connect(function() b.BackgroundColor3=C.btn end)
    return b
end
local function mkSlider(parent,yOff)
    local trk=Instance.new('Frame',parent)
    trk.Size=UDim2.new(1,-20,0,6); trk.Position=UDim2.new(0,10,0,yOff)
    trk.BackgroundColor3=C.div; trk.BorderSizePixel=0; corner(trk,100)
    local fill=Instance.new('Frame',trk); fill.Size=UDim2.new(0,0,1,0)
    fill.BackgroundColor3=C.acc; fill.BorderSizePixel=0; corner(fill,100)
    local hnd=Instance.new('TextButton'); hnd.Parent=trk
    hnd.Size=UDim2.new(0,14,0,14); hnd.Position=UDim2.new(0,-7,0.5,-7)
    hnd.BackgroundColor3=Color3.fromRGB(255,255,255); hnd.BorderSizePixel=0
    hnd.Text=''; hnd.AutoButtonColor=false; corner(hnd,100)
    return trk,fill,hnd
end
local function setToggle(btn,state,label)
    btn.Text=(label or '')..(state and ': ON' or ': OFF')
    btn.TextColor3=state and C.on or C.off
end

-- =========== ROOT GUI ===========
local sg=Instance.new('ScreenGui'); sg.Name='InkDestroyerGui'; sg.ResetOnSpawn=false; sg.Parent=playerGui
local mf=Instance.new('Frame',sg); mf.Name='MainFrame'
mf.Size=UDim2.new(0,610,0,430); mf.Position=UDim2.new(0.5,-305,0.38,-215)
mf.BackgroundColor3=C.bg; mf.BorderSizePixel=0; mf.Active=true; mf.Draggable=true; corner(mf,14)

-- Title bar
local tb=Instance.new('Frame',mf); tb.Size=UDim2.new(1,0,0,46); tb.BackgroundColor3=C.dark; tb.BorderSizePixel=0; corner(tb,14)
local _tf=Instance.new('Frame',tb); _tf.Size=UDim2.new(1,0,0,14); _tf.Position=UDim2.new(0,0,1,-14); _tf.BackgroundColor3=C.dark; _tf.BorderSizePixel=0
local acbar=Instance.new('Frame',tb); acbar.Size=UDim2.new(0,3,0.65,0); acbar.Position=UDim2.new(0,13,0.17,0); acbar.BackgroundColor3=C.acc; acbar.BorderSizePixel=0; corner(acbar,4)
local tl=Instance.new('TextLabel',tb)
tl.Size=UDim2.new(0,220,1,0); tl.Position=UDim2.new(0,22,0,0)
tl.BackgroundTransparency=1; tl.Text='INK DESTROYER'
tl.TextColor3=C.txt; tl.TextSize=17; tl.Font=Enum.Font.GothamBold; tl.TextXAlignment=Enum.TextXAlignment.Left
local tvl=Instance.new('TextLabel',tb)
tvl.Size=UDim2.new(0,40,1,0); tvl.Position=UDim2.new(0,175,0,0)
tvl.BackgroundTransparency=1; tvl.Text='v5'; tvl.TextColor3=C.acc; tvl.TextSize=11; tvl.Font=Enum.Font.GothamBold; tvl.TextXAlignment=Enum.TextXAlignment.Left
-- Close button (right side, well away from title text)
local minBtn=Instance.new('TextButton'); minBtn.Parent=tb
minBtn.Size=UDim2.new(0,26,0,26); minBtn.Position=UDim2.new(1,-68,0.5,-13)
minBtn.BackgroundColor3=Color3.fromRGB(22,22,22); minBtn.BorderSizePixel=0
minBtn.Text='-'; minBtn.TextColor3=C.txt; minBtn.TextSize=15; minBtn.Font=Enum.Font.GothamBold; minBtn.AutoButtonColor=false; corner(minBtn,6)
local cl=Instance.new('TextButton'); cl.Parent=tb
cl.Size=UDim2.new(0,26,0,26); cl.Position=UDim2.new(1,-36,0.5,-13)
cl.BackgroundColor3=Color3.fromRGB(45,12,12); cl.BorderSizePixel=0
cl.Text='X'; cl.TextColor3=Color3.fromRGB(255,70,70); cl.TextSize=13; cl.Font=Enum.Font.GothamBold; cl.AutoButtonColor=false; corner(cl,6)
cl.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Sidebar
local sb=Instance.new('Frame',mf); sb.Size=UDim2.new(0,130,1,-46); sb.Position=UDim2.new(0,0,0,46); sb.BackgroundColor3=C.dark; sb.BorderSizePixel=0; corner(sb,14)
local _sf=Instance.new('Frame',sb); _sf.Size=UDim2.new(1,0,0,14); _sf.Position=UDim2.new(0,0,0,0); _sf.BackgroundColor3=C.dark; _sf.BorderSizePixel=0
local tc=Instance.new('Frame',sb); tc.Size=UDim2.new(1,0,1,0); tc.BackgroundTransparency=1
local tlay=Instance.new('UIListLayout',tc); tlay.Padding=UDim.new(0,5); tlay.HorizontalAlignment=Enum.HorizontalAlignment.Center
local tpad=Instance.new('UIPadding',tc); tpad.PaddingTop=UDim.new(0,14)

-- Content area
local cfa=Instance.new('Frame',mf); cfa.Size=UDim2.new(1,-148,1,-64); cfa.Position=UDim2.new(0,140,0,54); cfa.BackgroundTransparency=1
local function makeC(name,vis)
    local f=Instance.new('ScrollingFrame',cfa); f.Name=name; f.Size=UDim2.new(1,0,1,0); f.BackgroundTransparency=1; f.Visible=vis
    f.BorderSizePixel=0; f.ScrollBarThickness=4; f.CanvasSize=UDim2.new(0,0,0,720); f.ScrollingDirection=Enum.ScrollingDirection.Y
    return f
end
local minimized=false
minBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    sb.Visible=not minimized
    cfa.Visible=not minimized
    mf.Size=minimized and UDim2.new(0,610,0,46) or UDim2.new(0,610,0,430)
    minBtn.Text=minimized and '+' or '-'
end)

-- TAB ORDER: RLGL, Dalgona, Glass Bridge, Hide and Seek, Jump Rope, Combat, Troll, Misc (Misc always last)
local rlglC=makeC('RLGL',true); local dalC=makeC('Dal',false); local glassC=makeC('Glass',false)
local hideC=makeC('HideSeek',false); local jumpC=makeC('JumpRope',false); local combatC=makeC('Combat',false); local trollC=makeC('Troll',false); local miscC=makeC('Misc',false)

local function mkTab(name,sel)
    local b=Instance.new('TextButton'); b.Parent=tc; b.Size=UDim2.new(0.84,0,0,30); b.BorderSizePixel=0
    b.BackgroundColor3=sel and C.tabSel or C.tabDef
    b.Text=name; b.Font=Enum.Font.GothamBold; b.TextSize=11
    b.TextColor3=sel and Color3.fromRGB(255,255,255) or C.sub; b.AutoButtonColor=false; corner(b,7)
    return b
end
local btnRLGL   = mkTab('RLGL',true)
local btnDal    = mkTab('Dalgona',false)
local btnGlass  = mkTab('Glass Bridge',false)
local btnHide   = mkTab('Hide and Seek',false)
local btnJump   = mkTab('Jump Rope',false)
local btnCombat = mkTab('Combat',false)
local btnTroll  = mkTab('Troll',false)
local btnMisc   = mkTab('Misc',false)  -- ALWAYS LAST
local TABS={btnRLGL,btnDal,btnGlass,btnHide,btnJump,btnCombat,btnTroll,btnMisc}
local CTRS={rlglC,dalC,glassC,hideC,jumpC,combatC,trollC,miscC}
local function showTab(idx)
    for i=1,#TABS do
        TABS[i].BackgroundColor3=(i==idx) and C.tabSel or C.tabDef
        TABS[i].TextColor3=(i==idx) and Color3.fromRGB(255,255,255) or C.sub
        CTRS[i].Visible=(i==idx)
    end
end
for i=1,#TABS do local ii=i; TABS[i].MouseButton1Click:Connect(function() showTab(ii) end) end

-- ===== RLGL =====
mkHdr(rlglC,'Red Light Green Light',2)
local wsBtn=mkBtn(rlglC,'WalkSpeed Loop: OFF',26,32); wsBtn.TextColor3=C.off
local spdLbl=mkLbl(rlglC,'Speed: 16',64,16,11,C.txt)
local sTrk,sFill,sHnd=mkSlider(rlglC,84)
mkDiv(rlglC,100)
local tpBtn=mkBtn(rlglC,'Route to Finish  (Outside Path)',108,34)
local routeSpeedMin,routeSpeedMax=10,90
local routeSpeed=42
local routeSpeedLbl=mkLbl(rlglC,'Route Speed: '..routeSpeed..' studs/s',150,16,11,C.sub)
local routeSpeedTrk,routeSpeedFill,routeSpeedHnd=mkSlider(rlglC,170)
local routeSpeedRel=(routeSpeed-routeSpeedMin)/(routeSpeedMax-routeSpeedMin)
routeSpeedHnd.Position=UDim2.new(routeSpeedRel,-7,0.5,-7); routeSpeedFill.Size=UDim2.new(routeSpeedRel,0,1,0)
local instantRoute=false
local instantRouteBtn=mkBtn(rlglC,'Instant Route: OFF',188,30); instantRouteBtn.TextColor3=C.off

-- ===== DALGONA =====
mkHdr(dalC,'Dalgona Cutter',2)
local dalTypeLbl=mkLbl(dalC,'Shape: detecting...',24,16,11,C.acc)
local dalBBoxLbl=mkLbl(dalC,'',42,14,10)
local atBtn=mkBtn(dalC,'Auto-Trace: OFF',60,32); atBtn.TextColor3=C.off
local dalStatusLbl=mkLbl(dalC,'Status: idle',98,16,11)
mkDiv(dalC,118)
local dalRefreshBtn=mkBtn(dalC,'Re-detect Shape',124,26); dalRefreshBtn.TextSize=11

-- ===== GLASS =====
mkHdr(glassC,'Glass Bridge ESP',2)
local espBtn=mkBtn(glassC,'Safe Glass ESP: OFF',26,32); espBtn.TextColor3=C.off
local glassStatusLbl=mkLbl(glassC,'Status: idle',64,16,10)

-- ===== HIDE AND SEEK =====
mkHdr(hideC,'Hide and Seek ESP',2)
local hsEspBtn=mkBtn(hideC,'Hider/Seeker ESP: OFF',26,32); hsEspBtn.TextColor3=C.off
local hsHiderBtn=mkBtn(hideC,'[X] Show Hiders',64,28); hsHiderBtn.TextColor3=C.on
local hsSeekerBtn=mkBtn(hideC,'[X] Show Seekers',98,28); hsSeekerBtn.TextColor3=C.on
local hsGuardBtn=mkBtn(hideC,'Guard ESP: OFF',132,28); hsGuardBtn.TextColor3=C.off
local hsStatusLbl=mkLbl(hideC,'Seekers red, hiders blue',166,16,10)

-- ===== JUMP ROPE =====
mkHdr(jumpC,'Jump Rope Tools',2)
local jrDeleteBtn=mkBtn(jumpC,'Delete Rope: OFF',26,32); jrDeleteBtn.TextColor3=C.off
local jrPlatformBtn=mkBtn(jumpC,'Platform Under Rope: OFF',64,32); jrPlatformBtn.TextColor3=C.off
local jrStatusLbl=mkLbl(jumpC,'Status: waiting for rope',102,16,10)

-- ===== COMBAT =====
mkHdr(combatC,'Kill Aura',2)
local kaBtn=mkBtn(combatC,'Kill Aura: OFF',24,30); kaBtn.TextColor3=C.off
local kbBtn=mkBtn(combatC,'Toggle Key: [ F ]',60,24); kbBtn.TextColor3=C.sub; kbBtn.TextSize=11
mkDiv(combatC,90)
-- Position + distance row
local posLbl=mkLbl(combatC,'Position:',94,14,11,C.sub)
local POS_NAMES={'Behind','Left','Right','In Front'}
local POS_DIR={Vector3.new(0,0,1),Vector3.new(-1,0,0),Vector3.new(1,0,0),Vector3.new(0,0,-1)}
local posIdx=1
local posBtn=mkBtn(combatC,'[ Behind ]',110,26); posBtn.TextColor3=C.acc; posBtn.TextSize=12
mkDiv(combatC,142)
local distLbl=mkLbl(combatC,'Distance: 1.5 studs',146,16,11,C.sub)
local distTrk,distFill,distHnd=mkSlider(combatC,166)
local distVal=1.5
mkDiv(combatC,180)
local rnLbl=mkLbl(combatC,'Range: 20 studs',184,16,11,C.sub)
local rnTrk,rnFill,rnHnd=mkSlider(combatC,204)
local tgtLbl=mkLbl(combatC,'Target: none',218,16,11)
mkDiv(combatC,238)
-- Hitbox expander
mkHdr(combatC,'Weapon Hitbox Expander',242)
local hbBtn=mkBtn(combatC,'Hitbox Expand: OFF',264,30); hbBtn.TextColor3=C.off
local hbLbl=mkLbl(combatC,'Equip a weapon then toggle',298,16,10)
mkDiv(combatC,322)
local predLbl=mkLbl(combatC,'Prediction Lead: 1.15x',328,16,11,C.sub)
local predTrk,predFill,predHnd=mkSlider(combatC,348)
mkDiv(combatC,366)
mkHdr(combatC,'Target Blacklist',374)
local blDropBtn=mkBtn(combatC,'Blacklist Player: select...',398,28); blDropBtn.TextColor3=C.acc; blDropBtn.TextSize=11
local blToggleBtn=mkBtn(combatC,'Add / Remove Selected',432,28); blToggleBtn.TextSize=11
local blStatusLbl=mkLbl(combatC,'Blacklisted: none',466,16,10)
local blDrop=Instance.new('Frame',combatC)
blDrop.Size=UDim2.new(1,-20,0,150); blDrop.Position=UDim2.new(0,10,0,488)
blDrop.BackgroundColor3=C.dark; blDrop.BorderSizePixel=0; blDrop.Visible=false; corner(blDrop,7)

-- ===== TROLL =====
mkHdr(trollC,'Orbit Troll',2)
local orbitGuardBtn=mkBtn(trollC,'Orbit Guard: OFF',26,32); orbitGuardBtn.TextColor3=C.off
local orbitGuardKeyBtn=mkBtn(trollC,'Guard Key: [ G ]',64,26); orbitGuardKeyBtn.TextColor3=C.sub; orbitGuardKeyBtn.TextSize=11
local orbitPlayerBtn=mkBtn(trollC,'Orbit Player: OFF',98,32); orbitPlayerBtn.TextColor3=C.off
local orbitPlayerKeyBtn=mkBtn(trollC,'Player Key: [ H ]',136,26); orbitPlayerKeyBtn.TextColor3=C.sub; orbitPlayerKeyBtn.TextSize=11
mkDiv(trollC,170)
local orbitSpeedLbl=mkLbl(trollC,'Orbit Speed: 2.5',176,16,11,C.sub)
local orbitSpeedTrk,orbitSpeedFill,orbitSpeedHnd=mkSlider(trollC,196)
local orbitStatusLbl=mkLbl(trollC,'Targets nearest guard/player',216,16,10)
-- ===== MISC (ALWAYS LAST TAB) =====
mkHdr(miscC,'Utilities',2)
local stBtn=mkBtn(miscC,'Stamina Bypass: OFF',24,30); stBtn.TextColor3=C.off
local ijBtn=mkBtn(miscC,'Infinite Jump: OFF',60,30); ijBtn.TextColor3=C.off
local ncBtn=mkBtn(miscC,'Noclip: OFF',96,30); ncBtn.TextColor3=C.off
mkDiv(miscC,132)
local tpUpBtn=mkHalfBtn(miscC,'TP 100 Up',138,10,188,30)
local tpDnBtn=mkHalfBtn(miscC,'TP 40 Down',138,208,188,30)
mkDiv(miscC,176)
local guardMiscBtn=mkBtn(miscC,'Guard ESP: OFF',182,28); guardMiscBtn.TextColor3=C.off
mkDiv(miscC,218)
local miscTpDropBtn=mkBtn(miscC,'Teleport Player: select alive...',224,28); miscTpDropBtn.TextColor3=C.acc; miscTpDropBtn.TextSize=11
local miscTpBtn=mkBtn(miscC,'Teleport To Selected',258,28); miscTpBtn.TextSize=11
local miscTpStatusLbl=mkLbl(miscC,'Alive players only',292,16,10)
local miscTpDrop=Instance.new('Frame',miscC)
miscTpDrop.Size=UDim2.new(1,-20,0,160); miscTpDrop.Position=UDim2.new(0,10,0,314)
miscTpDrop.BackgroundColor3=C.dark; miscTpDrop.BorderSizePixel=0; miscTpDrop.Visible=false; corner(miscTpDrop,7)
mkDiv(miscC,488)
local guiKeyBtn=mkBtn(miscC,'GUI Key: [ J ]  (click to rebind)',494,26); guiKeyBtn.TextSize=11; guiKeyBtn.TextColor3=C.sub

print('GUI built v5')

-- =========== LOGIC ===========

-- GUI toggle
local guiVisible=true; local guiKey=Enum.KeyCode.J; local guiBindMode=false
guiKeyBtn.MouseButton1Click:Connect(function() guiBindMode=true; guiKeyBtn.Text='Press any key...'; guiKeyBtn.TextColor3=Color3.fromRGB(255,200,0) end)

-- WalkSpeed
local wsOn=false; local curSpd=16; local isDrag=false
wsBtn.MouseButton1Click:Connect(function() wsOn=not wsOn; setToggle(wsBtn,wsOn,'WalkSpeed Loop') end)
sHnd.MouseButton1Down:Connect(function() isDrag=true end)
UserInputService.InputChanged:Connect(function(inp)
    local mv=inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch
    if isDrag and mv then
        local rel=math.clamp((inp.Position.X-sTrk.AbsolutePosition.X)/sTrk.AbsoluteSize.X,0,1)
        sHnd.Position=UDim2.new(rel,-7,0.5,-7); sFill.Size=UDim2.new(rel,0,1,0)
        curSpd=math.round(16+rel*184); spdLbl.Text='Speed: '..curSpd
        if wsOn then local c=player.Character; if c then local h=c:FindFirstChildOfClass('Humanoid'); if h then h.WalkSpeed=curSpd end end end
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        isDrag=false
    end
end)
local routeSpeedDrag=false
routeSpeedHnd.MouseButton1Down:Connect(function() routeSpeedDrag=true end)
UserInputService.InputChanged:Connect(function(inp)
    local mv=inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch
    if routeSpeedDrag and mv then
        local rel=math.clamp((inp.Position.X-routeSpeedTrk.AbsolutePosition.X)/routeSpeedTrk.AbsoluteSize.X,0,1)
        routeSpeedHnd.Position=UDim2.new(rel,-7,0.5,-7); routeSpeedFill.Size=UDim2.new(rel,0,1,0)
        routeSpeed=math.round(routeSpeedMin+rel*(routeSpeedMax-routeSpeedMin))
        routeSpeedLbl.Text='Route Speed: '..routeSpeed..' studs/s'
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        routeSpeedDrag=false
    end
end)
instantRouteBtn.MouseButton1Click:Connect(function()
    instantRoute=not instantRoute
    setToggle(instantRouteBtn,instantRoute,'Instant Route')
end)
task.spawn(function() while task.wait(0.1) do if not sg.Parent then break end
    if wsOn then local c=player.Character; if c then local h=c:FindFirstChildOfClass('Humanoid'); if h and h.WalkSpeed~=curSpd then h.WalkSpeed=curSpd end end end
end end)

-- Outside-path route to RLGL finish
local routeRunning=false
local function tweenTo(hrp,targetPos,speed)
    local dist=(targetPos-hrp.Position).Magnitude
    if dist<0.5 then return true end
    local dur=dist/speed; local elapsed=0
    local startCF=hrp.CFrame
    local angY=select(2,startCF:ToEulerAnglesYXZ())
    while elapsed<dur do
        if not sg.Parent or not routeRunning then return false end
        local dt=task.wait()
        elapsed=elapsed+dt
        local t=elapsed/dur; t=t*t*(3-2*t) -- smoothstep
        hrp.CFrame=CFrame.new(startCF.Position:Lerp(targetPos,math.clamp(t,0,1)))*CFrame.Angles(0,angY,0)
    end
    hrp.CFrame=CFrame.new(targetPos)*CFrame.Angles(0,angY,0)
    return true
end
tpBtn.MouseButton1Click:Connect(function()
    if routeRunning then
        routeRunning=false; tpBtn.Text='Route to Finish  (Outside Path)'; tpBtn.TextColor3=C.txt; return
    end
    local c=player.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart'); if not hrp then return end
    local rlgl=workspace:FindFirstChild('RedLightGreenLight'); if not rlgl then return end
    local doll=rlgl:FindFirstChild('doll'); if not doll then return end
    local ok,piv=pcall(function() return doll:GetPivot() end); if not ok then return end
    local dp=piv.Position; local mp=hrp.Position
    local flatToDoll=Vector3.new(dp.X-mp.X,0,dp.Z-mp.Z)
    if flatToDoll.Magnitude<1 then return end
    local rightDir=flatToDoll.Unit:Cross(Vector3.new(0,1,0)).Unit
    local sidePos=mp+(rightDir*235) -- right side path: original 160 studs + extra 75
    local routeY=mp.Y
    local wp={
        Vector3.new(sidePos.X, routeY, sidePos.Z),
        Vector3.new(sidePos.X, routeY, dp.Z+15),
        Vector3.new(dp.X,      routeY, dp.Z+15),
        Vector3.new(dp.X,      routeY, dp.Z),
    }
    routeRunning=true; tpBtn.Text='Routing... (click to cancel)'; tpBtn.TextColor3=C.acc
    task.spawn(function()
        local done=false
        if instantRoute then
            local angY=select(2,hrp.CFrame:ToEulerAnglesYXZ())
            hrp.CFrame=CFrame.new(wp[#wp])*CFrame.Angles(0,angY,0)
            done=true
        else
            done=tweenTo(hrp,wp[1],routeSpeed) and tweenTo(hrp,wp[2],routeSpeed*0.8) and tweenTo(hrp,wp[3],routeSpeed) and tweenTo(hrp,wp[4],routeSpeed*0.52)
        end
        if done then
            tpBtn.Text='Route to Finish  (Outside Path)'; tpBtn.TextColor3=C.txt
        end
        routeRunning=false
    end)
end)

-- Dalgona shape detection
local SHAPE_NAMES={
    [2]='Star / Umbrella', [3]='Triangle', [4]='Square', [5]='Circle',
    [6]='Sack Boy / Complex', [7]='Star', [8]='Umbrella', [9]='Honeycomb'
}
local function detectDal()
    local sw2=workspace:FindFirstChild('StairWalkWay')
    local cp2=sw2 and sw2:FindFirstChild('CheckpointsREWORK'); if not cp2 then return 'Not in stage','','' end
    for _,v in ipairs(cp2:GetChildren()) do
        if v.Name:lower():find('dalgona') and v:FindFirstChild('Models') then
            local m=v:FindFirstChild('Models'):FindFirstChildOfClass('Model')
            if m then
                local minX,maxX,minZ,maxZ=math.huge,-math.huge,math.huge,-math.huge
                local borderCount,totalParts=0,0
                for _,p in ipairs(m:GetDescendants()) do
                    if p:IsA('BasePart') then
                        totalParts=totalParts+1
                        minX=math.min(minX,p.Position.X); maxX=math.max(maxX,p.Position.X)
                        minZ=math.min(minZ,p.Position.Z); maxZ=math.max(maxZ,p.Position.Z)
                        if p.Size.Y>1 then borderCount=borderCount+1 end
                    end
                end
                local w=math.floor((maxX-minX)*10+0.5)/10
                local d=math.floor((maxZ-minZ)*10+0.5)/10
                local guess=SHAPE_NAMES[borderCount] or ('Unknown ('..borderCount..' segs)')
                return guess, 'W:'..w..' D:'..d, totalParts..' parts / '..borderCount..' border segs'
            end
        end
    end
    return 'None found','',''
end
local function refreshDal()
    local name,bbox,detail=detectDal()
    dalTypeLbl.Text='Shape: '..name
    dalBBoxLbl.Text=detail
end
refreshDal()
dalRefreshBtn.MouseButton1Click:Connect(refreshDal)

-- Dalgona trace toggle
local dalOn=false; local dalThread=nil
local function getDalWP()
    local sw2=workspace:FindFirstChild('StairWalkWay')
    local cp2=sw2 and sw2:FindFirstChild('CheckpointsREWORK'); if not cp2 then return nil end
    local dal2; for _,v in ipairs(cp2:GetChildren()) do if v.Name:lower():find('dalgona') and v:FindFirstChild('Models') then dal2=v; break end end
    if not dal2 then return nil end
    local model=dal2:FindFirstChild('Models'):FindFirstChildOfClass('Model'); if not model then return nil end
    local minX,maxX,minZ,maxZ=math.huge,-math.huge,math.huge,-math.huge; local surfY
    for _,v in ipairs(model:GetChildren()) do
        if v:IsA('BasePart') and v.Size.Y>1 then
            minX=math.min(minX,v.Position.X-v.Size.X/2); maxX=math.max(maxX,v.Position.X+v.Size.X/2)
            minZ=math.min(minZ,v.Position.Z-v.Size.Z/2); maxZ=math.max(maxZ,v.Position.Z+v.Size.Z/2)
            surfY=v.Position.Y+v.Size.Y/2+1.5
        end
    end
    local x1,x2=minX+0.4,maxX-0.4; local z1,z2=minZ+0.4,maxZ-0.4; local y=surfY or 0
    local steps=18; local wp={}
    local function addEdge(ax,az,bx,bz) for s=0,steps do local t=s/steps; wp[#wp+1]=Vector3.new(ax+(bx-ax)*t,y,az+(bz-az)*t) end end
    addEdge(x1,z1,x2,z1); addEdge(x2,z1,x2,z2); addEdge(x2,z2,x1,z2); addEdge(x1,z2,x1,z1)
    return wp
end
local function stopDal() dalOn=false; setToggle(atBtn,false,'Auto-Trace'); dalStatusLbl.Text='Status: idle'; if dalThread then task.cancel(dalThread); dalThread=nil end end
local function startDal()
    dalOn=true; setToggle(atBtn,true,'Auto-Trace'); refreshDal()
    dalThread=task.spawn(function()
        local wp=getDalWP(); if not wp then dalStatusLbl.Text='No shape found'; stopDal(); return end
        dalStatusLbl.Text='Status: tracing...'; local idx=1
        while dalOn and sg.Parent do
            local c=player.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart')
            if hrp then
                local dest=wp[idx]
                if (hrp.Position-dest).Magnitude<1.5 then
                    idx=idx+1
                    if idx>#wp then dalStatusLbl.Text='Loop complete, restarting'; task.wait(0.15); idx=1; dalStatusLbl.Text='Status: tracing...' end
                else hrp.CFrame=CFrame.new(dest)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0) end
            end
            task.wait(0.05)
        end
    end)
end
atBtn.MouseButton1Click:Connect(function() if dalOn then stopDal() else startDal() end end)

-- Glass Bridge ESP
local espOn=false; local espHL={}
local GLASS_COLORS={
    SAFE=Color3.fromRGB(45,255,95),
    UNSAFE=Color3.fromRGB(255,55,55),
    UNKNOWN=Color3.fromRGB(255,220,45),
}

local function clearHL()
    for _,h in pairs(espHL) do if h and h.Parent then h:Destroy() end end
    espHL={}
    glassStatusLbl.Text='Status: idle'
end

local function truthy(v)
    if v==nil then return nil end
    local s=tostring(v):lower()
    if v==true or s=='true' or s=='safe' or s=='real' or s=='correct' or s=='1' then return true end
    if v==false or s=='false' or s=='unsafe' or s=='fake' or s=='wrong' or s=='break' or s=='0' then return false end
    return nil
end

local function findGlassHolder()
    local gb=workspace:FindFirstChild('GlassBridge')
    local holder=gb and gb:FindFirstChild('GlassHolder')
    if holder then return holder end
    for _,d in ipairs(workspace:GetDescendants()) do
        if d.Name=='GlassHolder' and d.Parent and d.Parent.Name:lower():find('glassbridge') then
            return d
        end
    end
    return nil
end

local function modelSafeState(model)
    local keys={'Safe','IsSafe','Correct','IsCorrect','Real','Tempered','CanStep','Breaks','Fake','Unsafe'}
    for _,inst in ipairs({model,model.Parent}) do
        if inst then
            for _,key in ipairs(keys) do
                local val=inst:GetAttribute(key)
                local t=truthy(val)
                if t~=nil then
                    if key=='Breaks' or key=='Fake' or key=='Unsafe' then return not t end
                    return t
                end
            end
            for _,child in ipairs(inst:GetChildren()) do
                if child:IsA('BoolValue') or child:IsA('StringValue') or child:IsA('IntValue') or child:IsA('NumberValue') then
                    local name=child.Name:lower()
                    local t=truthy(child.Value)
                    if t~=nil and (name:find('safe') or name:find('correct') or name:find('real') or name:find('tempered')) then return t end
                    if t~=nil and (name:find('break') or name:find('fake') or name:find('unsafe')) then return not t end
                end
            end
        end
    end
    return nil
end

local function getGlassModels()
    local holder=findGlassHolder()
    local list={}
    if not holder then return list,nil end
    for _,panel in ipairs(holder:GetChildren()) do
        if panel:IsA('Model') and panel.Name:lower():find('clonedpanel') then
            for _,m in ipairs(panel:GetChildren()) do
                if m:IsA('Model') and m.Name:lower():find('glassmodel') then
                    list[#list+1]=m
                end
            end
        end
    end
    table.sort(list,function(a,b)
        local ap=tonumber((a.Parent and a.Parent.Name or ''):match('%d+')) or 0
        local bp=tonumber((b.Parent and b.Parent.Name or ''):match('%d+')) or 0
        if ap==bp then return a.Name<b.Name end
        return ap<bp
    end)
    return list,holder
end

local function setGlassHighlight(model,state)
    local color=state==true and GLASS_COLORS.SAFE or state==false and GLASS_COLORS.UNSAFE or GLASS_COLORS.UNKNOWN
    local h=espHL[model]
    if not h or not h.Parent then
        h=Instance.new('Highlight')
        h.Name='InkGlassBridgeESP'
        h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        h.FillTransparency=0.55
        h.OutlineTransparency=0
        espHL[model]=h
    end
    h.FillColor=color
    h.OutlineColor=color
    h.Adornee=model
    h.Parent=model
end

local function refreshGlassESP()
    if not espOn then clearHL(); return end
    local models,holder=getGlassModels()
    if not holder then
        glassStatusLbl.Text='Status: GlassBridge not streamed in'
        for model,h in pairs(espHL) do if h and h.Parent then h:Destroy() end; espHL[model]=nil end
        return
    end
    local active={}; local safe=0; local unsafe=0; local unknown=0
    for _,model in ipairs(models) do
        local state=modelSafeState(model)
        if state==true then safe=safe+1 elseif state==false then unsafe=unsafe+1 else unknown=unknown+1 end
        active[model]=true
        setGlassHighlight(model,state)
    end
    for model,h in pairs(espHL) do
        if not active[model] then if h and h.Parent then h:Destroy() end; espHL[model]=nil end
    end
    glassStatusLbl.Text='Panels '..#models..' | Safe '..safe..' / Unsafe '..unsafe..' / Unknown '..unknown
end

espBtn.MouseButton1Click:Connect(function()
    espOn=not espOn
    setToggle(espBtn,espOn,'Safe Glass ESP')
    if espOn then refreshGlassESP() else clearHL() end
end)

task.spawn(function() while task.wait(0.5) do
    if not sg.Parent then clearHL(); break end
    if espOn then refreshGlassESP() end
end end)

-- Hide and Seek ESP
local hsEspOn=false
local hsShowHiders=true
local hsShowSeekers=true
local hsHighlights={}
local guardEspOn=false
local guardHighlights={}
local HS_COLORS={
    SEEKER=Color3.fromRGB(255,45,45),
    HIDER=Color3.fromRGB(45,135,255),
}
local GUARD_COLOR=Color3.fromRGB(255,170,45)

local function setCheckButton(btn,enabled,label)
    btn.Text=(enabled and '[X] ' or '[ ] ')..label
    btn.TextColor3=enabled and C.on or C.off
end

local function clearHSEsp()
    for _,h in pairs(hsHighlights) do
        if h and h.Parent then h:Destroy() end
    end
    hsHighlights={}
    hsStatusLbl.Text='Seekers red, hiders blue'
end

local function normalizeRole(v)
    if v==nil then return nil end
    local s=tostring(v):lower()
    if s=='true' or s=='seeker' or s=='seekers' or s=='it' or s=='guard' then return 'SEEKER' end
    if s=='false' or s=='hider' or s=='hiders' or s=='player' then return 'HIDER' end
    return nil
end

local function findRoleValue(container)
    if not container then return nil end
    local roleKeys={'HideAndSeekRole','CurrentRole','Role','TeamRole','Class','IsSeeker','IsHider','Seeker','Hider','WillBeSeeker'}
    for _,key in ipairs(roleKeys) do
        local attr=container:GetAttribute(key)
        if attr~=nil and (key=='IsSeeker' or key=='Seeker' or key=='WillBeSeeker') then
            if attr==true or tostring(attr):lower()=='true' then return 'SEEKER' end
            if attr==false or tostring(attr):lower()=='false' then return 'HIDER' end
        end
        if attr~=nil and (key=='IsHider' or key=='Hider') then
            if attr==true or tostring(attr):lower()=='true' then return 'HIDER' end
            if attr==false or tostring(attr):lower()=='false' then return 'SEEKER' end
        end
        local role=normalizeRole(attr)
        if role then
            if key=='IsHider' or key=='Hider' then return 'HIDER' end
            if key=='IsSeeker' or key=='Seeker' then return 'SEEKER' end
            return role
        end
    end
    for _,child in ipairs(container:GetChildren()) do
        if child:IsA('BoolValue') or child:IsA('StringValue') or child:IsA('IntValue') or child:IsA('NumberValue') then
            local nameRole=normalizeRole(child.Name)
            local valueRole=normalizeRole(child.Value)
            if child.Name:lower():find('hider') then return child.Value==false and 'SEEKER' or 'HIDER' end
            if child.Name:lower():find('seeker') then return child.Value==false and 'HIDER' or 'SEEKER' end
            if nameRole then return nameRole end
            if valueRole then return valueRole end
        end
    end
    return nil
end

local function getHideSeekRole(plr)
    if not plr then return nil end
    local role=findRoleValue(plr) or findRoleValue(plr.Character)
    if role then return role end
    if plr.Team then
        local teamRole=normalizeRole(plr.Team.Name)
        if teamRole then return teamRole end
    end
    return nil
end

local function shouldShowHS(role)
    if not role or not hsEspOn then return false end
    return (role=='HIDER' and hsShowHiders) or (role=='SEEKER' and hsShowSeekers)
end

local function refreshHSEsp()
    if not hsEspOn then clearHSEsp(); return end
    local shown=0
    local seekers=0
    local hiders=0
    local active={}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=player then
            local char=plr.Character
            local role=getHideSeekRole(plr)
            if role=='SEEKER' then seekers=seekers+1 elseif role=='HIDER' then hiders=hiders+1 end
            if char and shouldShowHS(role) then
                active[plr]=true
                local h=hsHighlights[plr]
                if not h or not h.Parent then
                    h=Instance.new('Highlight')
                    h.Name='InkHideSeekESP'
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillTransparency=0.65
                    h.OutlineTransparency=0
                    hsHighlights[plr]=h
                end
                h.Adornee=char
                h.FillColor=HS_COLORS[role]
                h.OutlineColor=HS_COLORS[role]
                h.Parent=char
                shown=shown+1
            end
        end
    end
    for plr,h in pairs(hsHighlights) do
        if not active[plr] then
            if h and h.Parent then h:Destroy() end
            hsHighlights[plr]=nil
        end
    end
    hsStatusLbl.Text='Showing '..shown..' | Seekers '..seekers..' / Hiders '..hiders
end

local function isPlayerCharacterModel(model)
    if not model or not model:IsA('Model') then return false end
    return Players:GetPlayerFromCharacter(model)~=nil
end

local function looksLikeGuard(model)
    if not model or not model:IsA('Model') or isPlayerCharacterModel(model) then return false end
    local n=model.Name:lower()
    if n:find('guard') or n:find('soldier') or n:find('worker') or n:find('manager') or n:find('masked') then return true end
    if model:FindFirstChildOfClass('Humanoid') then
        for _,d in ipairs(model:GetDescendants()) do
            local dn=d.Name:lower()
            if dn:find('guard') or dn:find('triangle') or dn:find('square') or dn:find('circle') then return true end
        end
    end
    return false
end

local function clearGuardESP()
    for _,h in pairs(guardHighlights) do if h and h.Parent then h:Destroy() end end
    guardHighlights={}
end

local function refreshGuardESP()
    if not guardEspOn then clearGuardESP(); return end
    local active={}; local count=0
    for _,d in ipairs(workspace:GetDescendants()) do
        if looksLikeGuard(d) then
            active[d]=true
            local h=guardHighlights[d]
            if not h or not h.Parent then
                h=Instance.new('Highlight')
                h.Name='InkGuardESP'
                h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                h.FillTransparency=0.62
                h.OutlineTransparency=0
                guardHighlights[d]=h
            end
            h.Adornee=d
            h.FillColor=GUARD_COLOR
            h.OutlineColor=GUARD_COLOR
            h.Parent=d
            count=count+1
            if count>=80 then break end
        end
    end
    for model,h in pairs(guardHighlights) do
        if not active[model] then if h and h.Parent then h:Destroy() end; guardHighlights[model]=nil end
    end
    if guardEspOn then hsStatusLbl.Text='Guard ESP: '..count..' guards' end
end

local function setGuardESP(state)
    guardEspOn=state
    setToggle(hsGuardBtn,guardEspOn,'Guard ESP')
    setToggle(guardMiscBtn,guardEspOn,'Guard ESP')
    if guardEspOn then refreshGuardESP() else clearGuardESP() end
end

hsEspBtn.MouseButton1Click:Connect(function()
    hsEspOn=not hsEspOn
    setToggle(hsEspBtn,hsEspOn,'Hider/Seeker ESP')
    if hsEspOn then refreshHSEsp() else clearHSEsp() end
end)

hsHiderBtn.MouseButton1Click:Connect(function()
    hsShowHiders=not hsShowHiders
    setCheckButton(hsHiderBtn,hsShowHiders,'Show Hiders')
    refreshHSEsp()
end)

hsSeekerBtn.MouseButton1Click:Connect(function()
    hsShowSeekers=not hsShowSeekers
    setCheckButton(hsSeekerBtn,hsShowSeekers,'Show Seekers')
    refreshHSEsp()
end)

hsGuardBtn.MouseButton1Click:Connect(function() setGuardESP(not guardEspOn) end)
guardMiscBtn.MouseButton1Click:Connect(function() setGuardESP(not guardEspOn) end)

task.spawn(function() while task.wait(0.35) do
    if not sg.Parent then clearHSEsp(); clearGuardESP(); break end
    if hsEspOn then refreshHSEsp() end
    if guardEspOn then refreshGuardESP() end
end end)
-- Stamina
local stOn=false
stBtn.MouseButton1Click:Connect(function() stOn=not stOn; setToggle(stBtn,stOn,'Stamina Bypass') end)
task.spawn(function() RunService.RenderStepped:Connect(function()
    if not sg.Parent or not stOn then return end
    local c=player.Character; if not c then return end
    local h=c:FindFirstChildOfClass('Humanoid'); if not h then return end
    if h.FloorMaterial~=Enum.Material.Air and (UserInputService:IsKeyDown(Enum.KeyCode.Space) or h.Jump) then
        h.Jump=true; h:ChangeState(Enum.HumanoidStateType.Jumping) end
end) end)

-- Infinite jump
local ijOn=false; local jConn
ijBtn.MouseButton1Click:Connect(function()
    ijOn=not ijOn; setToggle(ijBtn,ijOn,'Infinite Jump')
    if ijOn then jConn=UserInputService.JumpRequest:Connect(function() local c=player.Character; if c then local h=c:FindFirstChildOfClass('Humanoid'); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)
    else if jConn then jConn:Disconnect(); jConn=nil end end
end)

-- Noclip: hybrid mode, restores when toggled off
local ncOn=false
local ncGroup='InkDestroyerNoclip'
local ncGroupReady=false
local ncOrigGroups={}
local ncOrigCollide={}
local ncMode='off'

local function ensureNoclipGroup()
    if ncGroupReady then return true end
    pcall(function() PhysicsService:RegisterCollisionGroup(ncGroup) end)

    local ok=pcall(function()
        PhysicsService:CollisionGroupSetCollidable(ncGroup,ncGroup,false)
        PhysicsService:CollisionGroupSetCollidable(ncGroup,'Default',false)
    end)

    local gotGroups,groups=pcall(function() return PhysicsService:GetRegisteredCollisionGroups() end)
    if gotGroups then
        for _,info in ipairs(groups) do
            local name=info.name or info.Name
            if name then
                pcall(function() PhysicsService:CollisionGroupSetCollidable(ncGroup,name,false) end)
            end
        end
    end

    ncGroupReady=ok
    return ok
end

local function restoreNoclip()
    for part,groupName in pairs(ncOrigGroups) do
        if part and part.Parent then pcall(function() part.CollisionGroup=groupName end) end
    end
    for part,canCollide in pairs(ncOrigCollide) do
        if part and part.Parent then pcall(function() part.CanCollide=canCollide end) end
    end
    ncOrigGroups={}
    ncOrigCollide={}
    ncMode='off'
end

local function applyNoclip()
    local c=player.Character; if not c then return end
    local groupOk=ensureNoclipGroup()
    local changed=0

    for _,part in ipairs(c:GetDescendants()) do
        if part:IsA('BasePart') then
            if ncOrigGroups[part]==nil then ncOrigGroups[part]=part.CollisionGroup end
            if ncOrigCollide[part]==nil then ncOrigCollide[part]=part.CanCollide end

            local groupWorked=false
            if groupOk then
                groupWorked=pcall(function() part.CollisionGroup=ncGroup end)
            end

            -- Fallback for client-only games where collision groups do not affect local character physics.
            if not groupWorked or part.CollisionGroup~=ncGroup then
                pcall(function() part.CanCollide=false end)
                ncMode='CanCollide'
            else
                ncMode='CollisionGroup'
            end

            changed=changed+1
        end
    end
end

ncBtn.MouseButton1Click:Connect(function()
    ncOn=not ncOn
    setToggle(ncBtn,ncOn,'Noclip')
    if ncOn then applyNoclip() else restoreNoclip() end
end)

task.spawn(function() RunService.Stepped:Connect(function()
    if not sg.Parent then restoreNoclip(); return end
    if ncOn then applyNoclip() end
end) end)

player.CharacterRemoving:Connect(function() restoreNoclip() end)
-- TP Up/Down
tpUpBtn.MouseButton1Click:Connect(function()
    local c=player.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart'); if hrp then hrp.CFrame=hrp.CFrame+Vector3.new(0,100,0) end
end)
tpDnBtn.MouseButton1Click:Connect(function()
    local c=player.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart'); if hrp then hrp.CFrame=hrp.CFrame+Vector3.new(0,-40,0) end
end)


-- Misc teleport to alive players
_G.InkMiscTpSelected=nil
_G.InkMiscIsAlive=function(plr)
    local c=plr and plr.Character
    local h=c and c:FindFirstChildOfClass('Humanoid')
    local hrp=c and c:FindFirstChild('HumanoidRootPart')
    return h and h.Health>0 and hrp and h:GetState()~=Enum.HumanoidStateType.Dead
end

_G.InkRebuildMiscTpDropdown=function()
    for _,ch in ipairs(miscTpDrop:GetChildren()) do ch:Destroy() end
    local y=6; local any=false
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player and _G.InkMiscIsAlive(p) then
            any=true
            local b=Instance.new('TextButton'); b.Parent=miscTpDrop
            b.Size=UDim2.new(1,-12,0,24); b.Position=UDim2.new(0,6,0,y)
            b.BackgroundColor3=C.btn; b.BorderSizePixel=0; b.AutoButtonColor=false; corner(b,5)
            b.Text=p.Name; b.TextColor3=C.txt; b.TextSize=10; b.Font=Enum.Font.GothamBold
            b.MouseButton1Click:Connect(function()
                _G.InkMiscTpSelected=p
                miscTpDropBtn.Text='Teleport Player: '..p.Name
                miscTpDrop.Visible=false
            end)
            y=y+28
        end
    end
    if not any then
        local l=Instance.new('TextLabel'); l.Parent=miscTpDrop
        l.Size=UDim2.new(1,-12,0,24); l.Position=UDim2.new(0,6,0,6)
        l.BackgroundTransparency=1; l.Text='No alive players'; l.TextColor3=C.sub; l.TextSize=10; l.Font=Enum.Font.Gotham
    end
end

miscTpDropBtn.MouseButton1Click:Connect(function()
    _G.InkRebuildMiscTpDropdown()
    miscTpDrop.Visible=not miscTpDrop.Visible
end)

miscTpBtn.MouseButton1Click:Connect(function()
    local c=player.Character; local myHrp=c and c:FindFirstChild('HumanoidRootPart')
    local target=_G.InkMiscTpSelected
    local tc=target and target.Character
    local th=tc and tc:FindFirstChild('HumanoidRootPart')
    if myHrp and th and _G.InkMiscIsAlive(target) then
        myHrp.CFrame=th.CFrame*CFrame.new(0,0,3)
        miscTpStatusLbl.Text='Teleported to '..target.Name
    else
        miscTpStatusLbl.Text='Selected player is not alive'
        _G.InkMiscTpSelected=nil
        miscTpDropBtn.Text='Teleport Player: select alive...'
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if _G.InkMiscTpSelected==p then
        _G.InkMiscTpSelected=nil
        miscTpDropBtn.Text='Teleport Player: select alive...'
    end
end)

-- Jump Rope tools
_G.InkJR={deleteOn=false,platformOn=false,removed={},platform=nil,lastCenter=nil}
_G.InkIsOurJumpObject=function(inst) return inst and inst.Name=='InkJumpRopePlatform' end
_G.InkGetInstCenter=function(inst)
    if not inst then return nil end
    if inst:IsA('BasePart') then return inst.Position end
    if inst:IsA('Model') then local ok,cf=pcall(function() return inst:GetPivot() end); if ok then return cf.Position end end
    return nil
end
_G.InkFindJumpRopeObjects=function()
    local found={}
    local function hasSelectedAncestor(inst)
        for _,sel in ipairs(found) do if sel and inst:IsDescendantOf(sel) then return true end end
        return false
    end
    for _,d in ipairs(workspace:GetDescendants()) do
        if not _G.InkIsOurJumpObject(d) and not hasSelectedAncestor(d) then
            local n=d.Name:lower(); local pn=d.Parent and d.Parent.Name:lower() or ''
            local hit=n:find('jumprope') or n:find('jump rope') or n=='rope' or n:find('rope') or pn:find('jumprope') or pn:find('jump rope')
            if hit and (d:IsA('BasePart') or d:IsA('Model')) then found[#found+1]=d; if #found>=30 then break end end
        end
    end
    return found
end
_G.InkFindJumpRopeCenter=function()
    for _,r in ipairs(_G.InkFindJumpRopeObjects()) do local pos=_G.InkGetInstCenter(r); if pos then _G.InkJR.lastCenter=pos; return pos end end
    for _,d in ipairs(workspace:GetDescendants()) do
        local n=d.Name:lower()
        if (n:find('track') or n:find('rail')) and d:IsA('BasePart') then _G.InkJR.lastCenter=d.Position; return d.Position end
    end
    return _G.InkJR.lastCenter
end
_G.InkApplyDeleteRope=function()
    local count=0
    for _,r in ipairs(_G.InkFindJumpRopeObjects()) do
        if r.Parent and not _G.InkJR.removed[r] then _G.InkJR.removed[r]=r.Parent; r.Parent=nil; count=count+1 end
    end
    jrStatusLbl.Text=count>0 and ('Removed rope objects: '..count) or 'No rope found yet'
end
_G.InkRestoreDeletedRope=function()
    local count=0
    for inst,parent in pairs(_G.InkJR.removed) do if inst and not inst.Parent and parent then inst.Parent=parent; count=count+1 end end
    _G.InkJR.removed={}
    jrStatusLbl.Text=count>0 and ('Restored rope objects: '..count) or 'Rope restore cleared'
end
_G.InkUpdateJumpPlatform=function()
    if not _G.InkJR.platformOn then if _G.InkJR.platform and _G.InkJR.platform.Parent then _G.InkJR.platform:Destroy() end; _G.InkJR.platform=nil; return end
    local center=_G.InkFindJumpRopeCenter()
    if not center then jrStatusLbl.Text='No rope/track found for platform'; return end
    if not _G.InkJR.platform or not _G.InkJR.platform.Parent then
        local p=Instance.new('Part'); p.Name='InkJumpRopePlatform'; p.Anchored=true; p.CanCollide=true; p.Material=Enum.Material.Neon; p.Color=Color3.fromRGB(45,135,255); p.Transparency=0.25; p.Size=Vector3.new(25,1,25); p.Parent=workspace; _G.InkJR.platform=p
    end
    _G.InkJR.platform.CFrame=CFrame.new(center-Vector3.new(0,10,0))
    jrStatusLbl.Text='Platform placed 10 studs under rope'
end

jrDeleteBtn.MouseButton1Click:Connect(function()
    _G.InkJR.deleteOn=not _G.InkJR.deleteOn
    setToggle(jrDeleteBtn,_G.InkJR.deleteOn,'Delete Rope')
    if _G.InkJR.deleteOn then _G.InkApplyDeleteRope() else _G.InkRestoreDeletedRope() end
end)

jrPlatformBtn.MouseButton1Click:Connect(function()
    _G.InkJR.platformOn=not _G.InkJR.platformOn
    setToggle(jrPlatformBtn,_G.InkJR.platformOn,'Platform Under Rope')
    _G.InkUpdateJumpPlatform()
end)

task.spawn(function() while task.wait(0.75) do
    if not sg.Parent then _G.InkRestoreDeletedRope(); if _G.InkJR.platform then _G.InkJR.platform:Destroy() end; break end
    if _G.InkJR.deleteOn then _G.InkApplyDeleteRope() end
    if _G.InkJR.platformOn then _G.InkUpdateJumpPlatform() end
end end)
-- =========== HITBOX EXPANDER ===========
local hbOn=false
local origSizes={} -- part -> originalSize
local EXPAND=1.45  -- 45% size increase, subtle but noticeable

local function getEquippedHandles()
    local c=player.Character; if not c then return {} end
    local handles={}
    for _,tool in ipairs(c:GetChildren()) do
        if tool:IsA('Tool') then
            -- Prefer an explicit hitbox part, then Handle, then largest BasePart
            local h=tool:FindFirstChild('Hitbox',true) or tool:FindFirstChild('Handle')
            if not h or not h:IsA('BasePart') then
                local biggest,bigSize=nil,0
                for _,p in ipairs(tool:GetDescendants()) do
                    if p:IsA('BasePart') then
                        local vol=p.Size.X*p.Size.Y*p.Size.Z
                        if vol>bigSize then biggest=p; bigSize=vol end
                    end
                end
                h=biggest
            end
            if h and h:IsA('BasePart') then handles[#handles+1]={tool=tool,handle=h} end
        end
    end
    return handles
end

local function disableHitbox()
    for h,orig in pairs(origSizes) do
        if h and h.Parent then h.Size=orig end
    end
    origSizes={}
    hbLbl.Text='Equip a weapon then toggle'
end

local function refreshHitbox()
    local found=getEquippedHandles()
    local active={}

    for _,entry in ipairs(found) do
        local h=entry.handle
        active[h]=true
        if origSizes[h]==nil then origSizes[h]=h.Size end
        h.Size=origSizes[h]*EXPAND
    end

    for h,orig in pairs(origSizes) do
        if not active[h] then
            if h and h.Parent then h.Size=orig end
            origSizes[h]=nil
        end
    end

    if #found==0 then
        hbLbl.Text='Waiting for equipped weapon...'
    elseif #found==1 then
        hbLbl.Text='Expanded: '..found[1].tool.Name
    else
        hbLbl.Text='Expanded: '..tostring(#found)..' tools'
    end
end

hbBtn.MouseButton1Click:Connect(function()
    hbOn=not hbOn
    setToggle(hbBtn,hbOn,'Hitbox Expand')
    if hbOn then refreshHitbox() else disableHitbox() end
end)

-- Re-check hitbox if tool changes while enabled
task.spawn(function() while task.wait(0.25) do
    if not sg.Parent then disableHitbox(); break end
    if hbOn then refreshHitbox() end
end end)

player.CharacterRemoving:Connect(function() disableHitbox() end)
-- =========== KILL AURA ===========
local kaOn=false; local kaKey=Enum.KeyCode.F; local kaBindMode=false
local kaRange=20; local rnDrag=false; local rnMin,rnMax=5,100
local distDrag=false; local distMin,distMax=1.0,5.0
local lockedTarget=nil
local LERP=0.32; local GRACE=8
local PREDICT_MIN_SPEED=12
local PREDICT_MAX_TIME=0.7
local PREDICT_STRENGTH=1.15
local PREDICT_STRENGTH_MIN=0.2
local PREDICT_STRENGTH_MAX=2.0
_G.InkKABlacklist=_G.InkKABlacklist or {}
_G.InkKASelectedBlacklistPlayer=nil

local function isAliveCharacter(char)
    local hum=char and char:FindFirstChildOfClass('Humanoid')
    local hrp=char and char:FindFirstChild('HumanoidRootPart')
    return hum and hrp and hum.Health>0 and hum:GetState()~=Enum.HumanoidStateType.Dead
end

local function isBlacklisted(plr)
    return plr and _G.InkKABlacklist[plr.UserId]==true
end

local function updateBlacklistStatus()
    local names={}
    for _,p in ipairs(Players:GetPlayers()) do
        if _G.InkKABlacklist[p.UserId] then names[#names+1]=p.Name end
    end
    table.sort(names)
    blStatusLbl.Text=#names>0 and ('Blacklisted: '..table.concat(names,', ')) or 'Blacklisted: none'
end

local function rebuildBlacklistDropdown()
    for _,ch in ipairs(blDrop:GetChildren()) do ch:Destroy() end
    local y=6
    local any=false
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player then
            any=true
            local b=Instance.new('TextButton'); b.Parent=blDrop
            b.Size=UDim2.new(1,-12,0,24); b.Position=UDim2.new(0,6,0,y)
            b.BackgroundColor3=_G.InkKABlacklist[p.UserId] and Color3.fromRGB(45,20,25) or C.btn
            b.BorderSizePixel=0; b.AutoButtonColor=false; corner(b,5)
            b.Text=(_G.InkKABlacklist[p.UserId] and '[X] ' or '[ ] ')..p.Name
            b.TextColor3=_G.InkKABlacklist[p.UserId] and C.off or C.txt
            b.TextSize=10; b.Font=Enum.Font.GothamBold
            b.MouseButton1Click:Connect(function()
                _G.InkKASelectedBlacklistPlayer=p
                blDropBtn.Text='Blacklist Player: '..p.Name
                blDrop.Visible=false
            end)
            y=y+28
        end
    end
    if not any then
        local l=Instance.new('TextLabel'); l.Parent=blDrop
        l.Size=UDim2.new(1,-12,0,24); l.Position=UDim2.new(0,6,0,6)
        l.BackgroundTransparency=1; l.Text='No other players'; l.TextColor3=C.sub
        l.TextSize=10; l.Font=Enum.Font.Gotham
    end
    updateBlacklistStatus()
end

posBtn.MouseButton1Click:Connect(function()
    posIdx=posIdx%#POS_NAMES+1; posBtn.Text='[ '..POS_NAMES[posIdx]..' ]'
end)

-- Sliders
local function makeSliderLogic(hnd,trk,fill,onVal)
    local drag=false
    hnd.MouseButton1Down:Connect(function() drag=true end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local rel=math.clamp((inp.Position.X-trk.AbsolutePosition.X)/trk.AbsoluteSize.X,0,1)
            hnd.Position=UDim2.new(rel,-7,0.5,-7); fill.Size=UDim2.new(rel,0,1,0)
            onVal(rel)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
end

makeSliderLogic(distHnd,distTrk,distFill,function(rel)
    distVal=math.floor((distMin+rel*(distMax-distMin))*10+0.5)/10
    distLbl.Text='Distance: '..string.format('%.1f',distVal)..' studs'
end)
makeSliderLogic(rnHnd,rnTrk,rnFill,function(rel)
    kaRange=math.round(rnMin+rel*(rnMax-rnMin))
    rnLbl.Text='Range: '..kaRange..' studs'
end)
local predRel=(PREDICT_STRENGTH-PREDICT_STRENGTH_MIN)/(PREDICT_STRENGTH_MAX-PREDICT_STRENGTH_MIN)
predHnd.Position=UDim2.new(predRel,-7,0.5,-7); predFill.Size=UDim2.new(predRel,0,1,0)
makeSliderLogic(predHnd,predTrk,predFill,function(rel)
    PREDICT_STRENGTH=math.floor((PREDICT_STRENGTH_MIN+rel*(PREDICT_STRENGTH_MAX-PREDICT_STRENGTH_MIN))*100+0.5)/100
    predLbl.Text='Prediction Lead: '..string.format('%.2f',PREDICT_STRENGTH)..'x'
end)

blDropBtn.MouseButton1Click:Connect(function()
    rebuildBlacklistDropdown()
    blDrop.Visible=not blDrop.Visible
end)

blToggleBtn.MouseButton1Click:Connect(function()
    local selected=_G.InkKASelectedBlacklistPlayer
    if not selected or not selected.Parent then
        blStatusLbl.Text='Pick a player first'
        rebuildBlacklistDropdown()
        return
    end
    local id=selected.UserId
    _G.InkKABlacklist[id]=not _G.InkKABlacklist[id] or nil
    if lockedTarget==selected then
        lockedTarget=nil
        tgtLbl.Text='Target: blacklisted  scanning...'
    end
    rebuildBlacklistDropdown()
end)

Players.PlayerRemoving:Connect(function(p)
    _G.InkKABlacklist[p.UserId]=nil
    if _G.InkKASelectedBlacklistPlayer==p then
        _G.InkKASelectedBlacklistPlayer=nil
        blDropBtn.Text='Blacklist Player: select...'
    end
    if lockedTarget==p then lockedTarget=nil end
    updateBlacklistStatus()
end)


-- Troll orbit tools
local orbitGuardOn=false
local orbitPlayerOn=false
local orbitGuardKey=Enum.KeyCode.G
local orbitPlayerKey=Enum.KeyCode.H
local orbitGuardBindMode=false
local orbitPlayerBindMode=false
local orbitSpeed=2.5
local orbitMin,orbitMax=0.5,8.0
local orbitRadius=8
local orbitAngle=0

local orbitRel=(orbitSpeed-orbitMin)/(orbitMax-orbitMin)
orbitSpeedHnd.Position=UDim2.new(orbitRel,-7,0.5,-7); orbitSpeedFill.Size=UDim2.new(orbitRel,0,1,0)
makeSliderLogic(orbitSpeedHnd,orbitSpeedTrk,orbitSpeedFill,function(rel)
    orbitSpeed=math.floor((orbitMin+rel*(orbitMax-orbitMin))*10+0.5)/10
    orbitSpeedLbl.Text='Orbit Speed: '..string.format('%.1f',orbitSpeed)
end)

local function orbitAlivePlayer(plr)
    local c=plr and plr.Character
    local h=c and c:FindFirstChildOfClass('Humanoid')
    local hrp=c and c:FindFirstChild('HumanoidRootPart')
    return h and h.Health>0 and hrp and h:GetState()~=Enum.HumanoidStateType.Dead
end

local function getModelRoot(model)
    if not model then return nil end
    return model:FindFirstChild('HumanoidRootPart') or model.PrimaryPart or model:FindFirstChildWhichIsA('BasePart')
end

local function looksLikeOrbitGuard(model)
    if not model or not model:IsA('Model') or Players:GetPlayerFromCharacter(model) then return false end
    local n=model.Name:lower()
    if n:find('guard') or n:find('soldier') or n:find('worker') or n:find('manager') or n:find('masked') then return getModelRoot(model)~=nil end
    if model:FindFirstChildOfClass('Humanoid') then
        for _,d in ipairs(model:GetDescendants()) do
            local dn=d.Name:lower()
            if dn:find('guard') or dn:find('triangle') or dn:find('square') or dn:find('circle') then return getModelRoot(model)~=nil end
        end
    end
    return false
end

local function nearestGuard(fromPos)
    local best,bDist=nil,math.huge
    for _,d in ipairs(workspace:GetDescendants()) do
        if looksLikeOrbitGuard(d) then
            local root=getModelRoot(d)
            if root then
                local dist=(root.Position-fromPos).Magnitude
                if dist<bDist then best=root; bDist=dist end
            end
        end
    end
    return best,bDist
end

local function nearestOrbitPlayer(fromPos)
    local best,bDist=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player and orbitAlivePlayer(p) then
            local root=p.Character and p.Character:FindFirstChild('HumanoidRootPart')
            local dist=(root.Position-fromPos).Magnitude
            if dist<bDist then best=root; bDist=dist end
        end
    end
    return best,bDist
end

local function setOrbitGuard(state)
    orbitGuardOn=state
    if state then orbitPlayerOn=false; setToggle(orbitPlayerBtn,false,'Orbit Player') end
    setToggle(orbitGuardBtn,orbitGuardOn,'Orbit Guard')
end

local function setOrbitPlayer(state)
    orbitPlayerOn=state
    if state then orbitGuardOn=false; setToggle(orbitGuardBtn,false,'Orbit Guard') end
    setToggle(orbitPlayerBtn,orbitPlayerOn,'Orbit Player')
end

orbitGuardBtn.MouseButton1Click:Connect(function() setOrbitGuard(not orbitGuardOn) end)
orbitPlayerBtn.MouseButton1Click:Connect(function() setOrbitPlayer(not orbitPlayerOn) end)
orbitGuardKeyBtn.MouseButton1Click:Connect(function()
    orbitGuardBindMode=true
    orbitGuardKeyBtn.Text='Press any key...'
    orbitGuardKeyBtn.TextColor3=Color3.fromRGB(255,200,0)
end)
orbitPlayerKeyBtn.MouseButton1Click:Connect(function()
    orbitPlayerBindMode=true
    orbitPlayerKeyBtn.Text='Press any key...'
    orbitPlayerKeyBtn.TextColor3=Color3.fromRGB(255,200,0)
end)

RunService.RenderStepped:Connect(function(dt)
    if not sg.Parent then return end
    if not orbitGuardOn and not orbitPlayerOn then return end
    local c=player.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart')
    if not hrp then return end
    local target,dist
    if orbitGuardOn then target,dist=nearestGuard(hrp.Position) else target,dist=nearestOrbitPlayer(hrp.Position) end
    if not target then
        orbitStatusLbl.Text=orbitGuardOn and 'No guard found' or 'No alive player found'
        return
    end
    orbitAngle=orbitAngle+(dt*orbitSpeed)
    local offset=Vector3.new(math.cos(orbitAngle)*orbitRadius,0,math.sin(orbitAngle)*orbitRadius)
    local pos=target.Position+offset
    hrp.CFrame=CFrame.lookAt(pos,Vector3.new(target.Position.X,pos.Y,target.Position.Z))
    orbitStatusLbl.Text=(orbitGuardOn and 'Orbiting guard' or 'Orbiting player')..' | '..math.floor(dist)..' studs'
end)
local rc=Instance.new('Part'); rc.Name='KillAuraRangeCircle'; rc.Shape=Enum.PartType.Cylinder
rc.Anchored=true; rc.CanCollide=false; rc.CastShadow=false
rc.Material=Enum.Material.Neon; rc.Color=Color3.fromRGB(255,40,40)
rc.Transparency=1; rc.Size=Vector3.new(0.12,kaRange*2,kaRange*2); rc.Parent=workspace

local function setKA(state)
    kaOn=state; setToggle(kaBtn,state,'Kill Aura')
    rc.Transparency=state and 0.62 or 1
    if not state then lockedTarget=nil; tgtLbl.Text='Target: none' end
end
kaBtn.MouseButton1Click:Connect(function() setKA(not kaOn) end)
kbBtn.MouseButton1Click:Connect(function() kaBindMode=true; kbBtn.Text='Press any key...'; kbBtn.TextColor3=Color3.fromRGB(255,200,0) end)

UserInputService.InputBegan:Connect(function(inp,gpe)
    if guiBindMode and inp.UserInputType==Enum.UserInputType.Keyboard then
        guiKey=inp.KeyCode
        guiKeyBtn.Text='GUI Key: [ '..tostring(inp.KeyCode):gsub('Enum.KeyCode.','')..' ]  (click to rebind)'
        guiKeyBtn.TextColor3=C.sub; guiBindMode=false; return
    end
    if kaBindMode and inp.UserInputType==Enum.UserInputType.Keyboard then
        kaKey=inp.KeyCode
        kbBtn.Text='Toggle Key: [ '..tostring(inp.KeyCode):gsub('Enum.KeyCode.','')..' ]'
        kbBtn.TextColor3=C.sub; kaBindMode=false; return
    end
    if orbitGuardBindMode and inp.UserInputType==Enum.UserInputType.Keyboard then
        orbitGuardKey=inp.KeyCode
        orbitGuardKeyBtn.Text='Guard Key: [ '..tostring(inp.KeyCode):gsub('Enum.KeyCode.','')..' ]'
        orbitGuardKeyBtn.TextColor3=C.sub; orbitGuardBindMode=false; return
    end
    if orbitPlayerBindMode and inp.UserInputType==Enum.UserInputType.Keyboard then
        orbitPlayerKey=inp.KeyCode
        orbitPlayerKeyBtn.Text='Player Key: [ '..tostring(inp.KeyCode):gsub('Enum.KeyCode.','')..' ]'
        orbitPlayerKeyBtn.TextColor3=C.sub; orbitPlayerBindMode=false; return
    end
    if gpe then return end
    if inp.UserInputType==Enum.UserInputType.Keyboard then
        if inp.KeyCode==guiKey then guiVisible=not guiVisible; mf.Visible=guiVisible end
        if inp.KeyCode==kaKey then setKA(not kaOn) end
        if inp.KeyCode==orbitGuardKey then setOrbitGuard(not orbitGuardOn) end
        if inp.KeyCode==orbitPlayerKey then setOrbitPlayer(not orbitPlayerOn) end
    end
end)

-- Target acquisition
task.spawn(function() while task.wait(0.12) do
    if not sg.Parent then break end
    if kaOn then
        local c=player.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart')
        if hrp then
            if lockedTarget then
                local tc2=lockedTarget.Character; local th=tc2 and tc2:FindFirstChild('HumanoidRootPart')
                if isBlacklisted(lockedTarget) or not isAliveCharacter(tc2) or not th or (th.Position-hrp.Position).Magnitude>kaRange+GRACE then
                    tgtLbl.Text='Target: lost  scanning...'; lockedTarget=nil
                end
            end
            if not lockedTarget then
                local best,bDist,bPlr=nil,kaRange+1,nil
                for _,p in ipairs(Players:GetPlayers()) do
                    if p~=player and not isBlacklisted(p) then
                        local tc3=p.Character; local th2=tc3 and tc3:FindFirstChild('HumanoidRootPart')
                        if isAliveCharacter(tc3) and th2 then local d=(th2.Position-hrp.Position).Magnitude; if d<bDist then best=th2; bDist=d; bPlr=p end end
                    end
                end
                if bPlr then lockedTarget=bPlr; tgtLbl.Text='>> '..bPlr.Name end
            end
        end
    end
end end)

-- RenderStepped: smooth tracking
RunService.RenderStepped:Connect(function(dt)
    if not sg.Parent then return end
    if kaOn then
        local c=player.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart')
        if hrp then
            rc.CFrame=CFrame.new(hrp.Position-Vector3.new(0,2.5,0))*CFrame.Angles(0,0,math.pi/2)
            rc.Size=Vector3.new(0.12,kaRange*2,kaRange*2)
            if lockedTarget then
                local tc4=lockedTarget.Character; local th=tc4 and tc4:FindFirstChild('HumanoidRootPart')
                if isBlacklisted(lockedTarget) then
                    lockedTarget=nil
                    tgtLbl.Text='Target: blacklisted  scanning...'
                elseif isAliveCharacter(tc4) and th then
                    local dir=POS_DIR[posIdx]
                    local vel=th.AssemblyLinearVelocity
                    local flatVel=Vector3.new(vel.X,0,vel.Z)
                    local speed=flatVel.Magnitude
                    local predictedPos=th.Position
                    local targetCF=th.CFrame

                    if speed>PREDICT_MIN_SPEED then
                        local dist=(th.Position-hrp.Position).Magnitude
                        local leadTime=math.clamp((dist/math.max(speed,1))*PREDICT_STRENGTH,0.08,PREDICT_MAX_TIME)
                        predictedPos=th.Position+(flatVel*leadTime)
                        local forward=flatVel.Unit
                        targetCF=CFrame.lookAt(predictedPos,predictedPos+forward)
                        tgtLbl.Text='>> '..lockedTarget.Name..'  lead '..math.floor(speed)
                    else
                        tgtLbl.Text='>> '..lockedTarget.Name
                    end

                    local desiredCF=targetCF*CFrame.new(dir.X*distVal,0,dir.Z*distVal)
                    local alpha=math.clamp(1-(1-LERP)^(60*dt),0,1)
                    hrp.CFrame=hrp.CFrame:Lerp(desiredCF,alpha)
                end
            end
        end
    end
end)

print('INK DESTROYER v5  |  J=GUI  |  F=KillAura  |  Misc is always last tab')
