local P = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local PG = P:WaitForChild("PlayerGui")
local HS = game:GetService("HttpService")

-- ==========================================
-- CẤU HÌNH KEYAUTH & HỆ THỐNG
-- ==========================================
local KEYAUTH_NAME = "mio hub"                      
local KEYAUTH_OWNERID = "PbCMNqwxIl"      
local GET_KEY_URL = "CHUA_CO_LINK"     
local TIKTOK_HANDLE = "@mio238987"     
local SAVE_FILE = "mio_key.dat"

local CFG = {
    FreezeDuration = 0.15, BasePower = 70, SlopeBonus = 1.4, HeightScale = 0.12, SpeedScale = 0.15,
    MaxPower = 250, AngleFromVertical = 45, SpeedMultiplier = 20, MaxHorizSpeed = 300,
}

-- ==========================================
-- HỆ THỐNG NGÔN NGỮ (VI / EN)
-- ==========================================
local Loc = {
    vi = {
        tab_main = "Chức năng", tab_map = "Bản đồ", tab_info = "Thông tin",
        freeze = "⚡ KÍCH HOẠT FREEZE (LAG)", edge = "Edge Boost (Mép)", aj = "Auto Jump",
        map_ph = "Nhập Map ID...", map_btn = "🏗️ Load Fake Map",
        buy_key = "IB TIKTOK ĐỂ LẤY KEY", copy_success = "Đã copy link TikTok! Nhắn tin để lấy Key.",
        verify = "XÁC NHẬN", get_key = "LẤY KEY", key_ph = "Nhập Key...", auth_title = "MIO HUB - XÁC THỰC",
        key_ok = "Thành công! Đang mở Menu...", key_fail = "Key sai, hết hạn hoặc bị khoá HWID!",
        credit = "cre by mio"
    },
    en = {
        tab_main = "Features", tab_map = "Map", tab_info = "Info",
        freeze = "⚡ TRIGGER FREEZE (LAG)", edge = "Edge Boost", aj = "Auto Jump",
        map_ph = "Enter Map ID...", map_btn = "🏗️ Load Fake Map",
        buy_key = "DM TIKTOK TO GET KEY", copy_success = "TikTok link copied! DM to get Key.",
        verify = "VERIFY", get_key = "GET KEY", key_ph = "Enter Key...", auth_title = "MIO HUB - AUTH",
        key_ok = "Success! Opening Menu...", key_fail = "Invalid key, expired or HWID locked!",
        credit = "cre by mio"
    }
}
local current_lang = "vi"

-- ==========================================
-- KEYAUTH API (ĐÃ FIX LỖI URL)
-- ==========================================
local function getHWID()
    if type(gethwid) == "function" then return gethwid() end
    local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    return ok and id or "UNKNOWN_HWID"
end

local function initKeyAuth()
    local safeName = HS:UrlEncode(KEYAUTH_NAME)
    local url = string.format("https://keyauth.win/api/1.2/?type=init&name=%s&ownerid=%s&ver=1.0", safeName, KEYAUTH_OWNERID)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and res then
        local s, data = pcall(function() return HS:JSONDecode(res) end)
        if s and data and data.success then return data.sessionid end
    end
    return nil
end

local function checkKey(k)
    if not k or k == "" then return false end
    local sessionid = initKeyAuth()
    if not sessionid then return false end
    
    local safeKey = HS:UrlEncode(k)
    local safeHWID = HS:UrlEncode(getHWID())
    local url = string.format("https://keyauth.win/api/1.2/?type=license&key=%s&hwid=%s&sessionid=%s", safeKey, safeHWID, sessionid)
    
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and res then
        local s, data = pcall(function() return HS:JSONDecode(res) end)
        if s and data and data.success then return true end
    end
    return false
end

local function saved()
    local ok, r = pcall(function()
        if isfile and isfile(SAVE_FILE) then return readfile(SAVE_FILE) end
    end)
    return ok and r or nil
end
local function save(k)
    pcall(function() if writefile then writefile(SAVE_FILE, k) end end)
end

-- ==========================================
-- GIAO DIỆN NHẬP KEY
-- ==========================================
local function prompt(onOK)
    if PG:FindFirstChild("MioKeyGate") then PG.MioKeyGate:Destroy() end
    local t = Loc[current_lang]
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "MioKeyGate"; sg.ResetOnSpawn = false; sg.DisplayOrder = 1000; sg.IgnoreGuiInset = true; sg.Parent = PG
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 320, 0, 260); f.Position = UDim2.fromScale(.5, .5); f.AnchorPoint = Vector2.new(.5, .5)
    f.BackgroundColor3 = Color3.fromRGB(10, 10, 10); f.BorderSizePixel = 0; f.Parent = sg
    Instance.new("UICorner", f).CornerRadius = UDim.new(.06, 0)
    local s = Instance.new("UIStroke", f); s.Thickness = 2; s.Color = Color3.fromRGB(255, 255, 255)
    
    local title = Instance.new("TextLabel", f)
    title.Size = UDim2.new(1, -20, 0, 24); title.Position = UDim2.new(0, 10, 0, 10); title.BackgroundTransparency = 1
    title.Text = t.auth_title; title.Font = Enum.Font.GothamBlack; title.TextSize = 15; title.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local b = Instance.new("TextBox", f)
    b.Size = UDim2.new(1, -20, 0, 36); b.Position = UDim2.new(0, 10, 0, 46); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.BorderSizePixel = 0; b.Text = ""; b.PlaceholderText = t.key_ph; b.Font = Enum.Font.Code; b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(255, 255, 255); b.ClearTextOnFocus = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(.1, 0)
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, -20, 0, 34); btn.Position = UDim2.new(0, 10, 0, 90); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0; btn.Text = t.verify; btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(.1, 0)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(255,255,255)

    local getBtn = Instance.new("TextButton", f)
    getBtn.Size = UDim2.new(1, -20, 0, 34); getBtn.Position = UDim2.new(0, 10, 0, 134); getBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    getBtn.BorderSizePixel = 0; getBtn.Text = t.get_key; getBtn.Font = Enum.Font.GothamBold; getBtn.TextSize = 14; getBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    Instance.new("UICorner", getBtn).CornerRadius = UDim.new(.1, 0)

    local buyBtn = Instance.new("TextButton", f)
    buyBtn.Size = UDim2.new(1, -20, 0, 34); buyBtn.Position = UDim2.new(0, 10, 0, 178); buyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    buyBtn.BorderSizePixel = 0; buyBtn.Text = t.buy_key; buyBtn.Font = Enum.Font.GothamBold; buyBtn.TextSize = 13; buyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(.1, 0)
    
    local st = Instance.new("TextLabel", f)
    st.Size = UDim2.new(1, -20, 0, 40); st.Position = UDim2.new(0, 10, 0, 218); st.BackgroundTransparency = 1
    st.Text = ""; st.Font = Enum.Font.Gotham; st.TextSize = 11; st.TextColor3 = Color3.fromRGB(255, 100, 100); st.TextWrapped = true

    getBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(GET_KEY_URL) end)
        st.Text = "Copied!"; st.TextColor3 = Color3.fromRGB(150, 255, 150)
    end)

    buyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard("https://www.tiktok.com/" .. TIKTOK_HANDLE) end)
        st.Text = t.copy_success; st.TextColor3 = Color3.fromRGB(150, 255, 150)
    end)
    
    btn.MouseButton1Click:Connect(function()
        st.Text = "Checking..."; st.TextColor3 = Color3.fromRGB(255, 255, 150)
        task.spawn(function()
            if checkKey(b.Text) then
                save(b.Text); st.Text = t.key_ok; st.TextColor3 = Color3.fromRGB(150, 255, 150)
                task.wait(1); sg:Destroy(); onOK()
            else
                st.Text = t.key_fail; st.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end)
    end)
end

-- ==========================================
-- MAIN UI (BLACK & WHITE ANIMATED HUB)
-- ==========================================
local function startMain()
    if PG:FindFirstChild("MioHub") then PG.MioHub:Destroy() end
    local t = Loc[current_lang]
    
    local function mk(cls, props, parent)
        local o = Instance.new(cls)
        for k, v in pairs(props) do o[k] = v end
        o.Parent = parent
        return o
    end

    local C_Bg = Color3.fromRGB(12, 12, 12)
    local C_Sidebar = Color3.fromRGB(18, 18, 18)
    local C_Accent = Color3.fromRGB(255, 255, 255)
    local C_Text = Color3.fromRGB(240, 240, 240)
    local C_SubText = Color3.fromRGB(140, 140, 140)
    local C_Item = Color3.fromRGB(25, 25, 25)

    local sg = mk("ScreenGui", {Name = "MioHub", ResetOnSpawn = false, DisplayOrder = 999, IgnoreGuiInset = true}, PG)
    
    -- Main Frame
    local main = mk("Frame", {
        Size = UDim2.new(0, 500, 0, 320), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C_Bg, BorderSizePixel = 0, ClipsDescendants = true
    }, sg)
    mk("UICorner", {CornerRadius = UDim.new(0.02, 0)}, main)
    local mainStroke = mk("UIStroke", {Color = C_Accent, Thickness = 1.5, Transparency = 0.2}, main)
    
    -- Hiệu ứng viền thở
    task.spawn(function()
        while main.Parent do
            TS:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.8}):Play()
            task.wait(1.5)
            TS:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.2}):Play()
            task.wait(1.5)
        end
    end)

    -- Top Bar
    local topBar = mk("Frame", {Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1}, main)
    local titleLabel = mk("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1, Text = "MIO HUB | WHITE EDITION", TextColor3 = C_Accent,
        Font = Enum.Font.GothamBlack, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
    }, topBar)

    -- Nút đổi ngôn ngữ
    local langBtn = mk("TextButton", {Size = UDim2.new(0, 35, 0, 25), Position = UDim2.new(1, -80, 0, 5), BackgroundColor3 = C_Item, Text = string.upper(current_lang), TextColor3 = C_Text, Font = Enum.Font.GothamBold, TextSize = 11, BorderSizePixel = 0}, topBar)
    mk("UICorner", {CornerRadius = UDim.new(0.2, 0)}, langBtn)
    langBtn.MouseButton1Click:Connect(function()
        current_lang = (current_lang == "vi" and "en") or "vi"
        startMain()
    end)

    -- Float Button (Nút MIO đen trắng)
    local floatBtn = mk("TextButton", {
        Size = UDim2.new(0, 70, 0, 30), Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = C_Bg, Text = "MIO", TextColor3 = C_Accent, Font = Enum.Font.GothamBlack,
        TextSize = 12, BorderSizePixel = 0, AutoButtonColor = false, Visible = false, ZIndex = 10
    }, sg)
    mk("UICorner", {CornerRadius = UDim.new(0.2, 0)}, floatBtn)
    mk("UIStroke", {Color = C_Accent, Thickness = 1.5}, floatBtn)

    local fbDrag, fbStart, fbPos
    floatBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fbDrag, fbStart, fbPos = true, input.Position, floatBtn.Position
        end
    end)
    floatBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then fbDrag = false end
    end)
    UIS.InputChanged:Connect(function(input)
        if fbDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - fbStart
            floatBtn.Position = UDim2.new(fbPos.X.Scale, fbPos.X.Offset + d.X, fbPos.Y.Scale, fbPos.Y.Offset + d.Y)
        end
    end)
    floatBtn.MouseButton1Click:Connect(function() main.Visible = true; floatBtn.Visible = false end)

    -- Nút Close
    local btnClose = mk("TextButton", {Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -35, 0, 2), BackgroundTransparency = 1, Text = "X", TextColor3 = C_SubText, Font = Enum.Font.GothamBold, TextSize = 14}, topBar)
    btnClose.MouseButton1Click:Connect(function() main.Visible = false; floatBtn.Visible = true end)

    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            main.Visible = not main.Visible
            floatBtn.Visible = not main.Visible
        end
    end)
    
    -- Sidebar
    local sidebar = mk("Frame", {Size = UDim2.new(0, 130, 1, -45), Position = UDim2.new(0, 10, 0, 40), BackgroundColor3 = C_Sidebar, BorderSizePixel = 0}, main)
    mk("UICorner", {CornerRadius = UDim.new(0.04, 0)}, sidebar)
    
    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 1, -25), BackgroundTransparency = 1,
        Text = t.credit, TextColor3 = C_SubText, Font = Enum.Font.GothamBold, TextSize = 12, TextTransparency = 0.4
    }, sidebar)
    
    -- Content
    local content = mk("ScrollingFrame", {
        Size = UDim2.new(1, -160, 1, -45), Position = UDim2.new(0, 150, 0, 40),
        BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = C_Accent, CanvasSize = UDim2.new(0, 0, 1, 0)
    }, main)
    mk("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, content)

    -- Tabs
    local tabs = {}
    local function createTab(name, order)
        local btn = mk("TextButton", {
            Size = UDim2.new(1, -10, 0, 35), Position = UDim2.new(0, 5, 0, 5 + (order * 40)),
            BackgroundColor3 = C_Item, Text = "  " .. name, TextColor3 = C_SubText,
            Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0, AutoButtonColor = false
        }, sidebar)
        mk("UICorner", {CornerRadius = UDim.new(0.1, 0)}, btn)
        
        local origPos = btn.Position
        btn.Position = UDim2.new(-1, 0, origPos.Y.Scale, origPos.Y.Offset)
        TS:Create(btn, TweenInfo.new(0.4 + (order*0.1), Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = origPos}):Play()

        local page = mk("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Visible = false}, content)
        mk("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, page)
        table.insert(tabs, {btn = btn, page = page})
        return page
    end

    local function switchTab(index)
        for i, tab in ipairs(tabs) do
            if i == index then
                TS:Create(tab.btn, TweenInfo.new(0.2), {BackgroundColor3 = C_Accent, TextColor3 = C_Bg}):Play()
                tab.page.Visible = true
            else
                TS:Create(tab.btn, TweenInfo.new(0.2), {BackgroundColor3 = C_Item, TextColor3 = C_SubText}):Play()
                tab.page.Visible = false
            end
        end
    end

    local tabMain = createTab(t.tab_main, 0)
    local tabMap = createTab(t.tab_map, 1)
    local tabInfo = createTab(t.tab_info, 2)
    switchTab(1)
    for i, tab in ipairs(tabs) do tab.btn.MouseButton1Click:Connect(function() switchTab(i) end) end

    -- Components
    local function createButton(parent, text, callback)
        local b = mk("TextButton", {
            Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C_Item, Text = text, TextColor3 = C_Text,
            Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0, AutoButtonColor = false, LayoutOrder = #parent:GetChildren()
        }, parent)
        mk("UICorner", {CornerRadius = UDim.new(0.1, 0)}, b)
        local stroke = mk("UIStroke", {Color = C_Accent, Thickness = 1, Transparency = 0.8}, b)
        b.MouseEnter:Connect(function() TS:Create(stroke, TweenInfo.new(0.1), {Transparency = 0}):Play(); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end)
        b.MouseLeave:Connect(function() TS:Create(stroke, TweenInfo.new(0.1), {Transparency = 0.8}):Play(); b.BackgroundColor3 = C_Item end)
        b.MouseButton1Click:Connect(callback)
        return b
    end

    local function createToggle(parent, text, default, callback)
        local f = mk("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C_Item, LayoutOrder = #parent:GetChildren()}, parent)
        mk("UICorner", {CornerRadius = UDim.new(0.1, 0)}, f)
        mk("TextLabel", {Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = C_Text, Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left}, f)
        local switchBg = mk("Frame", {Size = UDim2.new(0, 36, 0, 20), Position = UDim2.new(1, -46, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = default and C_Accent or Color3.fromRGB(60, 60, 60)}, f)
        mk("UICorner", {CornerRadius = UDim.new(1, 0)}, switchBg)
        local knob = mk("Frame", {Size = UDim2.new(0, 16, 0, 16), Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = default and C_Bg or C_Accent}, switchBg)
        mk("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)
        local state = default
        local btnHit = mk("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""}, f)
        btnHit.MouseButton1Click:Connect(function()
            state = not state
            if state then
                TS:Create(switchBg, TweenInfo.new(0.15), {BackgroundColor3 = C_Accent}):Play()
                TS:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(1, -18, 0.5, 0), BackgroundColor3 = C_Bg}):Play()
            else
                TS:Create(switchBg, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                TS:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = C_Accent}):Play()
            end
            if callback then callback(state) end
        end)
        return f
    end

    local function createTextBox(parent, placeholder, default)
        local f = mk("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C_Item, LayoutOrder = #parent:GetChildren()}, parent)
        mk("UICorner", {CornerRadius = UDim.new(0.1, 0)}, f)
        local tb = mk("TextBox", {Size = UDim2.new(1, -20, 1, -10), Position = UDim2.new(0, 10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Color3.fromRGB(10, 10, 10), Text = default, PlaceholderText = placeholder, TextColor3 = C_Text, Font = Enum.Font.Code, TextSize = 13, ClearTextOnFocus = false}, f)
        mk("UICorner", {CornerRadius = UDim.new(0.1, 0)}, tb)
        return tb
    end

    -- KÉO THẢ & KHOÁ 2 GIÂY
    local dragging, dragInput, dragStart, startPos
    local isLocked = false
    local holdStart = nil
    local HOLD_TIME = 2

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            holdStart = tick(); dragging = true; dragStart = input.Position; startPos = main.Position
            local thisHold = holdStart
            task.delay(HOLD_TIME, function()
                if dragging and holdStart == thisHold then
                    isLocked = not isLocked; dragging = false; holdStart = nil
                    if isLocked then
                        titleLabel.Text = "MIO HUB | LOCKED 🔒"; titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100); mainStroke.Color = Color3.fromRGB(255, 100, 100)
                    else
                        titleLabel.Text = "MIO HUB | WHITE EDITION"; titleLabel.TextColor3 = C_Accent; mainStroke.Color = C_Accent
                    end
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false; holdStart = nil end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging and not isLocked then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- ==== LOGIC ====
    local freezing = false
    local function hrp()
        local c = P.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
        if not h or h.Health <= 0 then return nil end
        return c:FindFirstChild("HumanoidRootPart")
    end
    local function onSlope(r)
        local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = {P.Character}
        local hit = workspace:Raycast(r.Position, Vector3.new(0, -6, 0), rp)
        return hit and hit.Normal.Y < .95 and hit.Normal.Y > .1
    end
    local function launch()
        local r = hrp(); if not r then return end
        local v = r.AssemblyLinearVelocity
        local hs = Vector3.new(v.X, 0, v.Z).Magnitude
        local alt = math.max(r.Position.Y, 0)
        local horiz = Vector3.new(v.X, 0, v.Z)
        local fwd
        if horiz.Magnitude > 1.5 then fwd = horiz.Unit
        else
            local cam = workspace.CurrentCamera
            local lv = (cam and cam.CFrame.LookVector) or r.CFrame.LookVector
            fwd = Vector3.new(lv.X, 0, lv.Z)
            fwd = fwd.Magnitude < .01 and Vector3.new(0, 0, -1) or fwd.Unit
        end
        local ang = math.rad(CFG.AngleFromVertical)
        local dir = (fwd * math.sin(ang) + Vector3.new(0, 1, 0) * math.cos(ang)).Unit
        local power = CFG.BasePower + alt * CFG.HeightScale + hs * CFG.SpeedScale
        if onSlope(r) then power = power * CFG.SlopeBonus end
        power = math.min(power, CFG.MaxPower)

        local boostedHoriz = horiz * CFG.SpeedMultiplier
        local newV = Vector3.new(boostedHoriz.X, math.max(v.Y, 0), boostedHoriz.Z) + dir * power
        local fh = Vector3.new(newV.X, 0, newV.Z)
        if fh.Magnitude > CFG.MaxHorizSpeed then fh = fh.Unit * CFG.MaxHorizSpeed end
        r.AssemblyLinearVelocity = Vector3.new(fh.X, newV.Y, fh.Z)
    end
    local function doFreeze()
        if freezing then return end
        freezing = true
        local overlay = mk("Frame", {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.6, ZIndex = 20}, sg)
        local t2 = os.clock(); while os.clock() - t2 < CFG.FreezeDuration do end
        launch(); overlay:Destroy(); freezing = false
    end

    local edgeBoostEnabled = false
    local edgePower = 100
    local edgeMinFall = 1.0
    local function checkBouncePart(pt)
        local keywords = {"bounce", "boost", "launch", "jump", "pad", "ramp", "platform"}
        local n = string.lower(pt.Name)
        for _, w in ipairs(keywords) do if n:find(w) then return true end end
        if pt.Parent and (pt.Parent:IsA("Model") or pt.Parent:IsA("Folder")) then
            local pn = string.lower(pt.Parent.Name)
            for _, w in ipairs(keywords) do if pn:find(w) then return true end end
        end
        return false
    end
    RS.Stepped:Connect(function()
        if not edgeBoostEnabled then return end
        local c = P.Character; local h = c and c:FindFirstChildOfClass("Humanoid"); local r = c and c:FindFirstChild("HumanoidRootPart")
        if not h or not r or h.Health <= 0 then return end
        if r.AssemblyLinearVelocity.Y < -edgeMinFall then
            local t_parts = r:GetTouchingParts()
            local isEdge, isBounce = false, false
            if #t_parts > 0 then
                for _, pt in pairs(t_parts) do if checkBouncePart(pt) then isBounce = true break end end
                if not isBounce then isEdge = true end
            end
            if isEdge then
                r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, 0, r.AssemblyLinearVelocity.Z) + Vector3.new(0, edgePower, 0)
            end
        end
    end)

    local function loadFakeMap(mapId)
        if not mapId or mapId == "" then return end
        local char = P.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.Anchored = true; local originalPos = root.Position
        root.CFrame = CFrame.new(root.Position.X, 5000, root.Position.Z)
        task.spawn(function()
            local success, objs = pcall(function() return game:GetObjects("rbxassetid://" .. mapId) end)
            if success and objs[1] then
                local map = objs[1]; map.Parent = workspace; task.wait(1)
                local targetPart = map:FindFirstChildWhichIsA("BasePart", true)
                if targetPart then root.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
                else root.CFrame = CFrame.new(0, 10, 0) end
            else root.CFrame = CFrame.new(originalPos) end
            root.Anchored = false
        end)
    end

    -- ==== UI ITEMS ====
    createButton(tabMain, t.freeze, doFreeze)
    createToggle(tabMain, t.edge, false, function(state) edgeBoostEnabled = state end)
    createToggle(tabMain, t.aj, false, function(state)
        if state then
            task.spawn(function()
                while state do
                    local h = P.Character and P.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 and (UIS:IsKeyDown(Enum.KeyCode.Space)) then
                        local s = h:GetState()
                        if s == Enum.HumanoidStateType.Running or s == Enum.HumanoidStateType.Landed then h.Jump = true end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end)

    local mapIdBox = createTextBox(tabMap, t.map_ph, "13336839729")
    createButton(tabMap, t.map_btn, function() loadFakeMap(mapIdBox.Text) end)

    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, 
        Text = "MIO HUB\n" .. t.credit .. "\nTikTok: " .. TIKTOK_HANDLE, 
        TextColor3 = C_SubText, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, LayoutOrder = 99
    }, tabInfo)

    -- HIỆU ỨNG MỞ MENU
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Rotation = -10
    TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 320), Rotation = 0}):Play()
end

-- CHẠY SCRIPT
local sk = saved()
if sk and checkKey(sk) then startMain() else prompt(startMain) end