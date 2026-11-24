local P=game:GetService("Players").LocalPlayer

local UIS=game:GetService("UserInputService")

local RS=game:GetService("RunService")

local TS=game:GetService("TweenService")

local PG=P:WaitForChild("PlayerGui")



-- ==== CONFIG ====

local VALID_KEY = "miobeo123"

local TIKTOK = "https://www.tiktok.com/@minhquang.1121"

local TIKTOK_HANDLE = "@minhquang.1121"

local SAVE_FILE = "mio_key.dat"



local CFG={

    FreezeDuration    = 0.15,

    BasePower         = 70,

    SlopeBonus        = 1.4,

    HeightScale       = 0.12,

    SpeedScale        = 0.15,

    MaxPower          = 200,

    AngleFromVertical = 45,

    SpeedMultiplier   = 20,    -- nhân vận tốc ngang khi bấm

    MaxHorizSpeed     = 300,   -- cap an toàn; hạ nếu bị snap

}



-- ==== KEY ====

local function check(k)

    if not k then return false end

    return k:gsub("%s+","") == VALID_KEY

end

local function saved()

    local ok,r=pcall(function()

        if isfile and isfile(SAVE_FILE) then return readfile(SAVE_FILE) end

    end)

    return ok and r or nil

end

local function save(k)

    pcall(function() if writefile then writefile(SAVE_FILE,k) end end)

end



-- ==== PROMPT ====

local function prompt(onOK)

    if PG:FindFirstChild("MioKeyGate") then PG.MioKeyGate:Destroy() end

    local sg=Instance.new("ScreenGui")

    sg.Name="MioKeyGate"; sg.ResetOnSpawn=false; sg.DisplayOrder=1000; sg.IgnoreGuiInset=true

    sg.Parent=PG



    local f=Instance.new("Frame")

    f.Size=UDim2.new(0,320,0,230); f.Position=UDim2.fromScale(.5,.5); f.AnchorPoint=Vector2.new(.5,.5)

    f.BackgroundColor3=Color3.fromRGB(18,18,22); f.BorderSizePixel=0; f.Parent=sg

    Instance.new("UICorner",f).CornerRadius=UDim.new(.06,0)

    local s=Instance.new("UIStroke",f); s.Thickness=2

    local h=0

    local conn

    conn=RS.RenderStepped:Connect(function(dt)

        if not f.Parent then conn:Disconnect() return end

        h=(h+dt*.5)%1; s.Color=Color3.fromHSV(h,1,1)

    end)



    local title=Instance.new("TextLabel",f)

    title.Size=UDim2.new(1,-20,0,24); title.Position=UDim2.new(0,10,0,10)

    title.BackgroundTransparency=1; title.Text="Script by Mio"

    title.Font=Enum.Font.GothamBold; title.TextSize=15; title.TextColor3=Color3.fromRGB(230,230,230)



    local sub=Instance.new("TextLabel",f)

    sub.Size=UDim2.new(1,-20,0,16); sub.Position=UDim2.new(0,10,0,34)

    sub.BackgroundTransparency=1; sub.Text="Enter your key to continue"

    sub.Font=Enum.Font.Gotham; sub.TextSize=11; sub.TextColor3=Color3.fromRGB(150,150,160)



    local b=Instance.new("TextBox",f)

    b.Size=UDim2.new(1,-20,0,36); b.Position=UDim2.new(0,10,0,56)

    b.BackgroundColor3=Color3.fromRGB(30,30,38); b.BorderSizePixel=0; b.Text=""

    b.PlaceholderText="Enter key"; b.Font=Enum.Font.Code; b.TextSize=14

    b.TextColor3=Color3.fromRGB(220,220,220); b.ClearTextOnFocus=false

    Instance.new("UICorner",b).CornerRadius=UDim.new(.1,0)



    local btn=Instance.new("TextButton",f)

    btn.Size=UDim2.new(1,-20,0,34); btn.Position=UDim2.new(0,10,0,100)

    btn.BackgroundColor3=Color3.fromRGB(40,40,55); btn.BorderSizePixel=0; btn.Text="VERIFY"

    btn.Font=Enum.Font.GothamBold; btn.TextSize=14; btn.TextColor3=Color3.fromRGB(220,220,220)

    Instance.new("UICorner",btn).CornerRadius=UDim.new(.1,0)



    local buyBtn=Instance.new("TextButton",f)

    buyBtn.Size=UDim2.new(1,-20,0,34); buyBtn.Position=UDim2.new(0,10,0,144)

    buyBtn.BackgroundColor3=Color3.fromRGB(60,25,70); buyBtn.BorderSizePixel=0

    buyBtn.Text="BUY KEY — "..TIKTOK_HANDLE

    buyBtn.Font=Enum.Font.GothamBold; buyBtn.TextSize=13; buyBtn.TextColor3=Color3.fromRGB(240,200,255)

    Instance.new("UICorner",buyBtn).CornerRadius=UDim.new(.1,0)

    local bs=Instance.new("UIStroke",buyBtn); bs.Thickness=1

    bs.Color=Color3.fromRGB(180,100,220); bs.Transparency=.3



    local st=Instance.new("TextLabel",f)

    st.Size=UDim2.new(1,-20,0,18); st.Position=UDim2.new(0,10,0,184)

    st.BackgroundTransparency=1; st.Text=""

    st.Font=Enum.Font.Gotham; st.TextSize=11; st.TextColor3=Color3.fromRGB(255,120,120)



    local info=Instance.new("TextLabel",f)

    info.Size=UDim2.new(1,-20,0,18); info.Position=UDim2.new(0,10,0,204)

    info.BackgroundTransparency=1; info.Text=""

    info.Font=Enum.Font.Gotham; info.TextSize=10; info.TextColor3=Color3.fromRGB(150,220,150)



    buyBtn.MouseButton1Click:Connect(function()

        local ok=pcall(function() setclipboard(TIKTOK) end)

        if ok then

            info.Text="Link copied! DM "..TIKTOK_HANDLE.." on TikTok"

        else

            info.Text="DM "..TIKTOK_HANDLE.." on TikTok to buy"

        end

    end)



    btn.MouseButton1Click:Connect(function()

        st.Text="Checking..."; st.TextColor3=Color3.fromRGB(220,220,150)

        task.spawn(function()

            if check(b.Text) then

                save(b.Text)

                st.Text="OK!"; st.TextColor3=Color3.fromRGB(150,220,150)

                task.wait(.4); sg:Destroy(); onOK()

            else

                st.Text="Invalid key — buy at "..TIKTOK_HANDLE

                st.TextColor3=Color3.fromRGB(255,120,120)

            end

        end)

    end)

end



-- ==== MAIN ====

local function startMain()

    if PG:FindFirstChild("UltraFreezeUI") then PG.UltraFreezeUI:Destroy() end



    local function mk(cls,props,parent)

        local o=Instance.new(cls)

        for k,v in pairs(props) do o[k]=v end

        o.Parent=parent; return o

    end



    local sg=mk("ScreenGui",{Name="UltraFreezeUI",ResetOnSpawn=false,DisplayOrder=999},PG)

    local ov=mk("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(),BackgroundTransparency=1,ZIndex=20},sg)

    local ct=mk("Frame",{Size=UDim2.new(0,170,0,86),Position=UDim2.new(.78,0,.2,0),BackgroundTransparency=1},sg)

    local btn=mk("TextButton",{Size=UDim2.new(1,0,0,60),Text="FREEZE NOW",Font=Enum.Font.GothamBold,

        TextSize=16,TextColor3=Color3.fromRGB(220,220,220),BackgroundColor3=Color3.fromRGB(15,15,20),

        BackgroundTransparency=.2,AutoButtonColor=false,ZIndex=10},ct)

    local st=mk("UIStroke",{Color=Color3.fromHSV(0,1,1),Thickness=2,Transparency=.1},btn)

    mk("UICorner",{CornerRadius=UDim.new(.15,0)},btn)

    mk("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,64),

        BackgroundTransparency=1,Text="Script by Mio",Font=Enum.Font.GothamSemibold,

        TextSize=13,TextColor3=Color3.fromRGB(200,200,200)},ct)



    local hue=0

    RS.RenderStepped:Connect(function(dt) hue=(hue+dt*.5)%1; st.Color=Color3.fromHSV(hue,1,1) end)



    local function hrp()

        local c=P.Character; local h=c and c:FindFirstChildOfClass("Humanoid")

        if not h or h.Health<=0 then return nil end

        return c:FindFirstChild("HumanoidRootPart")

    end

    local function onSlope(r)

        local rp=RaycastParams.new()

        rp.FilterType=Enum.RaycastFilterType.Exclude

        rp.FilterDescendantsInstances={P.Character}

        local hit=workspace:Raycast(r.Position,Vector3.new(0,-6,0),rp)

        return hit and hit.Normal.Y<.95 and hit.Normal.Y>.1

    end



    local function launch()

        local r=hrp(); if not r then return end

        local v=r.AssemblyLinearVelocity

        local hs=Vector3.new(v.X,0,v.Z).Magnitude

        local alt=math.max(r.Position.Y,0)



        -- hướng forward: ưu tiên vận tốc ngang, fallback camera

        local horiz=Vector3.new(v.X,0,v.Z)

        local fwd

        if horiz.Magnitude>1.5 then fwd=horiz.Unit

        else

            local cam=workspace.CurrentCamera

            local lv=(cam and cam.CFrame.LookVector) or r.CFrame.LookVector

            fwd=Vector3.new(lv.X,0,lv.Z)

            fwd=fwd.Magnitude<.01 and Vector3.new(0,0,-1) or fwd.Unit

        end



        -- vector bay chéo

        local ang=math.rad(CFG.AngleFromVertical)

        local dir=(fwd*math.sin(ang)+Vector3.new(0,1,0)*math.cos(ang)).Unit



        local power=CFG.BasePower+alt*CFG.HeightScale+hs*CFG.SpeedScale

        if onSlope(r) then power=power*CFG.SlopeBonus end

        power=math.min(power,CFG.MaxPower)



        -- NHÂN vận tốc ngang hiện tại

        local boostedHoriz=horiz*CFG.SpeedMultiplier

        local newV=Vector3.new(boostedHoriz.X,math.max(v.Y,0),boostedHoriz.Z)+dir*power



        -- cap tổng vận tốc ngang

        local fh=Vector3.new(newV.X,0,newV.Z)

        if fh.Magnitude>CFG.MaxHorizSpeed then

            fh=fh.Unit*CFG.MaxHorizSpeed

        end

        r.AssemblyLinearVelocity=Vector3.new(fh.X,newV.Y,fh.Z)

    end



    local freezing=false

    local function doFreeze()

        if freezing then return end

        freezing=true

        TS:Create(btn,TweenInfo.new(.05),{BackgroundColor3=Color3.fromRGB(100,20,20),TextColor3=Color3.fromRGB(255,150,150)}):Play()

        TS:Create(st,TweenInfo.new(.05),{Thickness=4}):Play()

        TS:Create(ov,TweenInfo.new(.05),{BackgroundTransparency=.7}):Play()

        local t=os.clock(); while os.clock()-t<CFG.FreezeDuration do end

        launch()

        TS:Create(ov,TweenInfo.new(.1),{BackgroundTransparency=1}):Play()

        TS:Create(btn,TweenInfo.new(.1),{BackgroundColor3=Color3.fromRGB(15,15,20),TextColor3=Color3.fromRGB(220,220,220)}):Play()

        TS:Create(st,TweenInfo.new(.1),{Thickness=2}):Play()

        freezing=false

    end



    local drag,ds,sp=false,nil,nil

    btn.InputBegan:Connect(function(i)

        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then

            drag,ds,sp=true,i.Position,ct.Position

            TS:Create(btn,TweenInfo.new(.05),{Size=UDim2.new(.96,0,0,57)}):Play()

        end

    end)

    btn.InputChanged:Connect(function(i)

        if drag and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then

            local d=i.Position-ds

            ct.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)

        end

    end)

    btn.InputEnded:Connect(function(i)

        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then

            drag=false

            TS:Create(btn,TweenInfo.new(.1),{Size=UDim2.new(1,0,0,60)}):Play()

        end

    end)

    btn.Activated:Connect(function() if not freezing then doFreeze() end end)



    btn.Size=UDim2.new(0,0,0,0)

    TS:Create(btn,TweenInfo.new(.3,Enum.EasingStyle.Back),{Size=UDim2.new(1,0,0,60)}):Play()

    print(("UltraFreeze | %.2fs | x%.0f speed | Script by Mio"):format(CFG.FreezeDuration,CFG.SpeedMultiplier))

end



local sk=saved()

if sk and check(sk) then startMain() else prompt(startMain) end
