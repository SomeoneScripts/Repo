-- M7z Crystal Seed Finder — Partes 1/5 até 5/5 reunidas
-- Código consolidado a partir das cinco partes fornecidas.

-- =========================
-- PARTE 1/5
-- =========================

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = game:GetService("Workspace")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local CONFIG = {
    NomesAlvo       = {"Semente de Cristal", "Crystal Seed", "Semente", "CrystalSeed"},
    VelocidadeMin   = 0.5,
    VelocidadeMax   = 4.0,
    VelocidadeIni   = 1,
    DistanciaPegar  = 8,
    AlturaVoo       = 3,
    DelayPegar      = 0.3,
    CorFundo        = Color3.fromRGB(15, 15, 18),
    CorPainel       = Color3.fromRGB(24, 24, 28),
    CorBorda        = Color3.fromRGB(45, 45, 52),
    CorTexto        = Color3.fromRGB(235, 235, 235),
    CorTextoFraco   = Color3.fromRGB(150, 150, 155),
    CorVermelho     = Color3.fromRGB(220, 40, 40),
    CorVerde        = Color3.fromRGB(60, 200, 120),
}

local Estado = {
    Ativo          = false,
    Velocidade     = CONFIG.VelocidadeIni,
    Conexoes       = {},
    AlvosAtuais    = {},
    Pegos          = {},
    LoopAtivo      = nil,
    ScanAtivo      = nil,
    VooAtivo       = false,
    PararAposAtual = false,
}

local function novoInstancia(cls, props)
    local obj = Instance.new(cls)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function tween(obj, props, tempo)
    local t = TweenService:Create(obj,
        TweenInfo.new(tempo or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props)
    t:Play()
    return t
end

local function adicionarConexao(conn)
    table.insert(Estado.Conexoes, conn)
    return conn
end

local function limparConexoes()
    for _, c in ipairs(Estado.Conexoes) do
        pcall(function() c:Disconnect() end)
    end
    Estado.Conexoes = {}
end

if CoreGui:FindFirstChild("M7zCrystalSeedUI") then
    CoreGui.M7zCrystalSeedUI:Destroy()
end

local ScreenGui = novoInstancia("ScreenGui", {
    Name = "M7zCrystalSeedUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = (gethui and gethui()) or CoreGui,
})

local Janela = novoInstancia("Frame", {
    Name = "Janela",
    Size = UDim2.new(0, 280, 0, 250),
    Position = UDim2.new(0.5, -140, 0.35, -125),
    BackgroundColor3 = CONFIG.CorFundo,
    BorderSizePixel = 0,
    Active = true,
    Parent = ScreenGui,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(0, 14), Parent = Janela })
novoInstancia("UIStroke", { Color = CONFIG.CorBorda, Thickness = 1, Parent = Janela })

local TitleBar = novoInstancia("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = CONFIG.CorPainel,
    BorderSizePixel = 0,
    Parent = Janela,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(0, 14), Parent = TitleBar })
novoInstancia("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = CONFIG.CorPainel,
    BorderSizePixel = 0,
    Parent = TitleBar,
})

local Logo = novoInstancia("Frame", {
    Name = "Logo",
    Size = UDim2.new(0, 56, 0, 28),
    Position = UDim2.new(0, 10, 0.5, -14),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Parent = TitleBar,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Logo })
novoInstancia("UIStroke", { Color = CONFIG.CorBorda, Thickness = 1, Parent = Logo })

novoInstancia("TextLabel", {
    Size = UDim2.new(0.33, 0, 1, 0), BackgroundTransparency = 1, Text = "M",
    TextColor3 = Color3.fromRGB(255,255,255), TextScaled = true,
    Font = Enum.Font.GothamBold, Parent = Logo,
})
novoInstancia("TextLabel", {
    Size = UDim2.new(0.34, 0, 1, 0), Position = UDim2.new(0.33, 0, 0, 0),
    BackgroundTransparency = 1, Text = "7", TextColor3 = CONFIG.CorVermelho,
    TextScaled = true, Font = Enum.Font.GothamBold, Parent = Logo,
})
novoInstancia("TextLabel", {
    Size = UDim2.new(0.33, 0, 1, 0), Position = UDim2.new(0.67, 0, 0, 0),
    BackgroundTransparency = 1, Text = "Z", TextColor3 = Color3.fromRGB(255,255,255),
    TextScaled = true, Font = Enum.Font.GothamBold, Parent = Logo,
})

novoInstancia("TextLabel", {
    Size = UDim2.new(1, -160, 1, 0), Position = UDim2.new(0, 72, 0, 0),
    BackgroundTransparency = 1, Text = "Crystal Seed Finder", TextColor3 = CONFIG.CorTexto,
    TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium,
    TextSize = 13, Parent = TitleBar,
})

local function criarBotaoTitle(texto, corTexto, xOffset)
    local b = novoInstancia("TextButton", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, xOffset, 0.5, -14),
        BackgroundColor3 = CONFIG.CorFundo, BorderSizePixel = 0, Text = texto,
        TextColor3 = corTexto, Font = Enum.Font.GothamBold, TextSize = 16,
        AutoButtonColor = false, Parent = TitleBar,
    })
    novoInstancia("UICorner", { CornerRadius = UDim.new(0, 8), Parent = b })
    return b
end

local BtnConfig = criarBotaoTitle("⚙", CONFIG.CorTexto, -100)
local BtnMin    = criarBotaoTitle("–", CONFIG.CorTexto, -68)
local BtnFechar = criarBotaoTitle("X", CONFIG.CorVermelho, -36)

local function hover(btn, cor)
    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = cor}, 0.15) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = CONFIG.CorFundo}, 0.15) end)
end
hover(BtnConfig, Color3.fromRGB(50, 50, 58))
hover(BtnMin, Color3.fromRGB(40,40,45))
hover(BtnFechar, Color3.fromRGB(80,20,20))

local Conteudo = novoInstancia("Frame", {
    Name = "Conteudo", Size = UDim2.new(1, -20, 1, -60),
    Position = UDim2.new(0, 10, 0, 50), BackgroundTransparency = 1, Parent = Janela,
})

local BtnAtivar = novoInstancia("TextButton", {
    Name = "BtnAtivar", Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = CONFIG.CorPainel, BorderSizePixel = 0, Text = "ATIVAR",
    TextColor3 = CONFIG.CorTexto, Font = Enum.Font.GothamBold, TextSize = 15,
    AutoButtonColor = false, Parent = Conteudo,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(0, 10), Parent = BtnAtivar })
novoInstancia("UIStroke", { Color = CONFIG.CorBorda, Thickness = 1, Parent = BtnAtivar })

local VelLabel = novoInstancia("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 58),
    BackgroundTransparency = 1, Text = "Velocidade: 2.00x", TextColor3 = CONFIG.CorTextoFraco,
    Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Conteudo,
})

local SliderTrack = novoInstancia("Frame", {
    Name = "Slider", Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 0, 88),
    BackgroundColor3 = CONFIG.CorPainel, BorderSizePixel = 0, Parent = Conteudo,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderTrack })

local SliderFill = novoInstancia("Frame", {
    Size = UDim2.new(0.5, 0, 1, 0), BackgroundColor3 = CONFIG.CorVermelho,
    BorderSizePixel = 0, Parent = SliderTrack,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderFill })

local SliderKnob = novoInstancia("Frame", {
    Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0.5, -11, 0.5, -11),
    BackgroundColor3 = CONFIG.CorTexto, BorderSizePixel = 0, Parent = SliderTrack,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderKnob })
novoInstancia("UIStroke", { Color = CONFIG.CorVermelho, Thickness = 2, Parent = SliderKnob })

local SliderTouch = novoInstancia("TextButton", {
    Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 0, -12),
    BackgroundTransparency = 1, Text = "", Parent = SliderTrack,
})

local StatusLabel = novoInstancia("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 1, -16),
    BackgroundTransparency = 1, Text = "Inativo", TextColor3 = CONFIG.CorTextoFraco,
    Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Conteudo,
})

local InfoLabel = novoInstancia("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 1, -34),
    BackgroundTransparency = 1, Text = "Pegos: 0", TextColor3 = CONFIG.CorVerde,
    Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Conteudo,
})

-- =========================
-- PARTE 2/5
-- =========================

do
    local dragging, dragStart, startPos
    local function iniciarDrag(input)
        dragging = true
        dragStart = input.Position
        startPos = Janela.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then iniciarDrag(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Janela.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

do
    local arrastando = false
    local function atualizar(input)
        local posX = input.Position.X - SliderTrack.AbsolutePosition.X
        local pct = math.clamp(posX / SliderTrack.AbsoluteSize.X, 0, 1)
        local valor = CONFIG.VelocidadeMin + (CONFIG.VelocidadeMax - CONFIG.VelocidadeMin) * pct
        SliderFill.Size = UDim2.new(pct, 0, 1, 0)
        SliderKnob.Position = UDim2.new(pct, -11, 0.5, -11)
        VelLabel.Text = string.format("Velocidade: %.2fx", valor)
        Estado.Velocidade = valor
    end
    SliderTouch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then arrastando = true; atualizar(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if arrastando and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then atualizar(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then arrastando = false end
    end)
    local pctIni = (CONFIG.VelocidadeIni - CONFIG.VelocidadeMin) / (CONFIG.VelocidadeMax - CONFIG.VelocidadeMin)
    SliderFill.Size = UDim2.new(pctIni, 0, 1, 0)
    SliderKnob.Position = UDim2.new(pctIni, -11, 0.5, -11)
end

local function promptEhSemente(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local objectText = string.lower(prompt.ObjectText or "")
    local actionText = string.lower(prompt.ActionText or "")
    if string.find(objectText, "semente") or string.find(objectText, "cristal")
    or string.find(objectText, "crystal") or string.find(objectText, "seed") then return true end
    if string.find(actionText, "pegar") and objectText ~= "" then return true end
    return false
end

local function acharPrompt(obj)
    if not obj then return nil end
    if obj:IsA("ProximityPrompt") then return obj end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("ProximityPrompt") then return d end
    end
    return nil
end

local function ehAlvo(obj)
    if not obj or not obj.Name then return false end
    for _, nome in ipairs(CONFIG.NomesAlvo) do
        if obj.Name == nome or string.find(obj.Name, nome, 1, true) then return true end
    end
    local prompt = acharPrompt(obj)
    if prompt and promptEhSemente(prompt) then return true end
    return false
end

local function pegarPosicao(obj)
    if obj:IsA("BasePart") then return obj.Position end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("BasePart") then return d.Position end
    end
    return nil
end

-- =========================
-- PARTE 3/5
-- =========================

local function criarESP(obj)
    if not obj or not obj.Parent then return end
    if Estado.AlvosAtuais[obj] then return end
    if Estado.Pegos[obj] then return end
    local adornee = obj
    if not obj:IsA("BasePart") then
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("BasePart") then adornee = d; break end
        end
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "M7zESP"
    billboard.Size = UDim2.new(0, 140, 0, 24)
    billboard.StudsOffset = Vector3.new(0, 2.2, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 500
    billboard.Adornee = adornee
    billboard.Parent = adornee
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "Semente de Cristal"
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.TextStrokeTransparency = 0
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.Parent = billboard
    local conn
    conn = obj.AncestryChanged:Connect(function(_, parent)
        if not parent and Estado.AlvosAtuais[obj] then
            pcall(function()
                local dados = Estado.AlvosAtuais[obj]
                if dados.billboard then dados.billboard:Destroy() end
                if dados.conn then dados.conn:Disconnect() end
            end)
            Estado.AlvosAtuais[obj] = nil
        end
    end)
    Estado.AlvosAtuais[obj] = { billboard = billboard, conn = conn }
end

local function limparESP()
    for obj, dados in pairs(Estado.AlvosAtuais) do
        pcall(function()
            if dados.billboard then dados.billboard:Destroy() end
            if dados.conn then dados.conn:Disconnect() end
        end)
    end
    Estado.AlvosAtuais = {}
end

local function escanear(container)
    container = container or Workspace
    local encontrados = {}
    for _, obj in ipairs(container:GetDescendants()) do
        if ehAlvo(obj) and not Estado.Pegos[obj] then criarESP(obj); table.insert(encontrados, obj) end
    end
    return encontrados
end

local function listarAlvos()
    local lista = {}
    local vistos = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if ehAlvo(obj) and not Estado.Pegos[obj] and not vistos[obj] then
            local pos = pegarPosicao(obj)
            if pos then
                local raiz = obj
                if obj:IsA("ProximityPrompt") then raiz = obj.Parent end
                if not vistos[raiz] then
                    vistos[raiz] = true
                    table.insert(lista, {obj = raiz, prompt = acharPrompt(raiz), pos = pos})
                end
            end
        end
    end
    return lista
end

-- =========================
-- PARTE 4/5
-- =========================

local function voarAte(posAlvo)
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end

    Estado.VooAtivo = true
    if hum then pcall(function() hum.PlatformStand = true end) end

    local destino = posAlvo + Vector3.new(0, CONFIG.AlturaVoo, 0)
    local velocidade = Estado.Velocidade * 80

    while Estado.Ativo and Estado.VooAtivo do
        local dt = task.wait()
        local vetorDestino = (destino - hrp.Position)
        local distancia = vetorDestino.Magnitude

        if distancia < 1.5 then
            pcall(function()
                hrp.CFrame = CFrame.new(destino)
            end)
            break
        end

        local passo = vetorDestino.Unit * velocidade * dt

        if passo.Magnitude >= distancia then
            pcall(function()
                hrp.CFrame = CFrame.new(destino)
            end)
            break
        end

        pcall(function()
            hrp.CFrame = hrp.CFrame + passo
            hrp.Velocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
        end)
    end

    if hum then pcall(function() hum.PlatformStand = false end) end
    Estado.VooAtivo = false
    return true
end

local function interagir(obj)
    local prompt = acharPrompt(obj)
    if not prompt then print("[M7z] Sem prompt no objeto:", obj and obj.Name); return false end
    task.wait(CONFIG.DelayPegar + math.random() * 0.2)
    pcall(function() prompt:InputHoldBegin() end)
    task.wait(0.1 + math.random() * 0.08)
    pcall(function() prompt:InputHoldEnd() end)
    task.wait(0.1)
    pcall(function() if fireproximityprompt then fireproximityprompt(prompt) end end)
    print("[M7z] Interagiu com:", obj.Name, "| Prompt:", prompt.ObjectText)
    return true
end

local function iniciarFarm()
    if Estado.LoopAtivo then return end
    Estado.LoopAtivo = task.spawn(function()
        while Estado.Ativo do
            local alvos = listarAlvos()
            if #alvos == 0 then
                StatusLabel.Text = "Aguardando itens..."
                StatusLabel.TextColor3 = CONFIG.CorTextoFraco
                task.wait(0.5 + math.random() * 0.5)
            else
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    table.sort(alvos, function(a, b)
                        return (a.pos - hrp.Position).Magnitude < (b.pos - hrp.Position).Magnitude
                    end)
                end
                local escolhido = alvos[1]
                StatusLabel.Text = "Indo até o item..."
                StatusLabel.TextColor3 = CONFIG.CorVerde
                voarAte(escolhido.pos)
                if escolhido.obj and escolhido.obj.Parent and not Estado.Pegos[escolhido.obj] then
                    interagir(escolhido.obj)
                    Estado.Pegos[escolhido.obj] = true
                    local totalPegos = 0
                    for _ in pairs(Estado.Pegos) do totalPegos = totalPegos + 1 end
                    InfoLabel.Text = "Pegos: " .. totalPegos
                    local dados = Estado.AlvosAtuais[escolhido.obj]
                    if dados then
                        pcall(function()
                            if dados.billboard then dados.billboard:Destroy() end
                            if dados.conn then dados.conn:Disconnect() end
                        end)
                        Estado.AlvosAtuais[escolhido.obj] = nil
                    end
                end
                task.wait(0.3 + math.random() * 0.4)
            end
        end
    end)
end

local function pararFarm()
    Estado.VooAtivo = false
    Estado.LoopAtivo = nil
end

local function ativar()
    if Estado.Ativo then return end
    Estado.Ativo = true
    Estado.Pegos = {}
    BtnAtivar.Text = "DESATIVAR"
    tween(BtnAtivar, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.2)
    StatusLabel.Text = "Procurando..."
    StatusLabel.TextColor3 = CONFIG.CorVerde
    escanear(Workspace)
    adicionarConexao(Workspace.DescendantAdded:Connect(function(obj)
        if Estado.Ativo and ehAlvo(obj) and not Estado.Pegos[obj] then
            task.wait(0.15)
            if obj and obj.Parent then criarESP(obj) end
        end
    end))
    Estado.ScanAtivo = task.spawn(function()
        while Estado.Ativo do
            escanear(Workspace)
            task.wait(0.8 + math.random() * 0.4)
        end
    end)
    iniciarFarm()
end

local function desativar()
    if not Estado.Ativo then return end
    Estado.Ativo = false
    BtnAtivar.Text = "ATIVAR"
    tween(BtnAtivar, {BackgroundColor3 = CONFIG.CorPainel}, 0.2)
    StatusLabel.Text = "Inativo"
    StatusLabel.TextColor3 = CONFIG.CorTextoFraco
    pararFarm()
    limparConexoes()
    limparESP()
    Estado.Pegos = {}
    Estado.ScanAtivo = nil
end

BtnAtivar.MouseButton1Click:Connect(function()
    if Estado.Ativo then desativar() else ativar() end
end)

-- =========================
-- PARTE 5/5
-- =========================

local MiniBtn
local function criarMiniBtn()
    MiniBtn = novoInstancia("TextButton", {
        Name = "MiniBtn", Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 20, 0.5, -25), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0, Text = "M7", TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold, TextSize = 18, AutoButtonColor = false,
        Parent = ScreenGui, Visible = false,
    })
    novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = MiniBtn })
    novoInstancia("UIStroke", { Color = CONFIG.CorVermelho, Thickness = 2, Parent = MiniBtn })
    local dragging, dragStart, startPos
    MiniBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MiniBtn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MiniBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    MiniBtn.MouseButton1Click:Connect(function()
        Janela.Visible = true
        MiniBtn.Visible = false
        tween(Janela, {Size = UDim2.new(0, 280, 0, 250)}, 0.2)
    end)
end
criarMiniBtn()

BtnMin.MouseButton1Click:Connect(function()
    tween(Janela, {Size = UDim2.new(0, 280, 0, 0)}, 0.2)
    task.wait(0.2)
    Janela.Visible = false
    MiniBtn.Visible = true
end)

local ReabrirBtn
local function criarReabrir()
    ReabrirBtn = novoInstancia("TextButton", {
        Name = "ReabrirBtn", Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 20, 0.4, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0, Text = "M7", TextColor3 = CONFIG.CorVermelho,
        Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false,
        Parent = ScreenGui, Visible = false,
    })
    novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ReabrirBtn })
    novoInstancia("UIStroke", { Color = CONFIG.CorVermelho, Thickness = 2, Parent = ReabrirBtn })
    ReabrirBtn.MouseButton1Click:Connect(function()
        Janela.Visible = true
        ReabrirBtn.Visible = false
        if MiniBtn then MiniBtn.Visible = false end
    end)
end
criarReabrir()

BtnFechar.MouseButton1Click:Connect(function()
    Janela.Visible = false
    if MiniBtn then MiniBtn.Visible = false end
    ReabrirBtn.Visible = true
end)

local ConfigJanela = novoInstancia("Frame", {
    Name = "ConfigJanela", Size = UDim2.new(0, 260, 0, 320),
    Position = UDim2.new(0.5, -130, 0.5, -160), BackgroundColor3 = CONFIG.CorFundo,
    BorderSizePixel = 0, Active = true, Visible = false, Parent = ScreenGui,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(0, 14), Parent = ConfigJanela })
novoInstancia("UIStroke", { Color = CONFIG.CorBorda, Thickness = 1, Parent = ConfigJanela })

local ConfigTitle = novoInstancia("Frame", {
    Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CONFIG.CorPainel,
    BorderSizePixel = 0, Parent = ConfigJanela,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(0, 14), Parent = ConfigTitle })
novoInstancia("Frame", {
    Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = CONFIG.CorPainel, BorderSizePixel = 0, Parent = ConfigTitle,
})

novoInstancia("TextLabel", {
    Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1, Text = "⚙  Configurações", TextColor3 = CONFIG.CorTexto,
    TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold,
    TextSize = 14, Parent = ConfigTitle,
})

local BtnConfigFechar = novoInstancia("TextButton", {
    Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -32, 0.5, -13),
    BackgroundColor3 = CONFIG.CorFundo, BorderSizePixel = 0, Text = "X",
    TextColor3 = CONFIG.CorVermelho, Font = Enum.Font.GothamBold, TextSize = 14,
    AutoButtonColor = false, Parent = ConfigTitle,
})
novoInstancia("UICorner", { CornerRadius = UDim.new(0, 7), Parent = BtnConfigFechar })
hover(BtnConfigFechar, Color3.fromRGB(80, 20, 20))

local ConfigConteudo = novoInstancia("Frame", {
    Size = UDim2.new(1, -20, 1, -50), Position = UDim2.new(0, 10, 0, 48),
    BackgroundTransparency = 1, Parent = ConfigJanela,
})
novoInstancia("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = ConfigConteudo,
})

local function criarToggle(nome, valorInicial, callback)
    local linha = novoInstancia("Frame", {
        Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Parent = ConfigConteudo,
    })
    novoInstancia("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, Text = nome,
        TextColor3 = CONFIG.CorTexto, Font = Enum.Font.Gotham, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = linha,
    })
    local switch = novoInstancia("TextButton", {
        Size = UDim2.new(0, 46, 0, 24), Position = UDim2.new(1, -46, 0.5, -12),
        BackgroundColor3 = valorInicial and CONFIG.CorVerde or CONFIG.CorPainel,
        BorderSizePixel = 0, Text = "", AutoButtonColor = false, Parent = linha,
    })
    novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = switch })
    novoInstancia("UIStroke", { Color = CONFIG.CorBorda, Thickness = 1, Parent = switch })
    local knob = novoInstancia("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = valorInicial and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = switch,
    })
    novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
    local estado = valorInicial
    switch.MouseButton1Click:Connect(function()
        estado = not estado
        tween(switch, { BackgroundColor3 = estado and CONFIG.CorVerde or CONFIG.CorPainel }, 0.15)
        tween(knob, { Position = estado and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) }, 0.15)
        if callback then callback(estado) end
    end)
    return switch
end

local function criarSliderConfig(nome, minV, maxV, valorIni, callback)
    local linha = novoInstancia("Frame", {
        Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Parent = ConfigConteudo,
    })
    local label = novoInstancia("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
        Text = string.format("%s: %.1f", nome, valorIni), TextColor3 = CONFIG.CorTextoFraco,
        Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = linha,
    })
    local track = novoInstancia("Frame", {
        Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 0, 24),
        BackgroundColor3 = CONFIG.CorPainel, BorderSizePixel = 0, Parent = linha,
    })
    novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
    local fill = novoInstancia("Frame", {
        Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = CONFIG.CorVermelho,
        BorderSizePixel = 0, Parent = track,
    })
    novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
    local knob = novoInstancia("Frame", {
        Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, -9, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = track,
    })
    novoInstancia("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
    novoInstancia("UIStroke", { Color = CONFIG.CorVermelho, Thickness = 2, Parent = knob })
    local touch = novoInstancia("TextButton", {
        Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 0, -13),
        BackgroundTransparency = 1, Text = "", Parent = track,
    })
    local arrastando = false
    local function atualizar(input)
        local posX = input.Position.X - track.AbsolutePosition.X
        local pct = math.clamp(posX / track.AbsoluteSize.X, 0, 1)
        local valor = minV + (maxV - minV) * pct
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -9, 0.5, -9)
        label.Text = string.format("%s: %.1f", nome, valor)
        if callback then callback(valor) end
    end
    touch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then arrastando = true; atualizar(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if arrastando and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then atualizar(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then arrastando = false end
    end)
    local pct = (valorIni - minV) / (maxV - minV)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    knob.Position = UDim2.new(pct, -9, 0.5, -9)
    return touch
end

criarToggle("ESP (nome do item)", true, function(v)
    for _, dados in pairs(Estado.AlvosAtuais) do
        if dados.billboard then dados.billboard.Enabled = v end
    end
end)

criarToggle("Loop Infinito", true, function(v)
    Estado.PararAposAtual = not v
end)

criarToggle("Voo Atravessa Tudo", true, function(v)
    Estado.AtravessaTudo = v
end)

criarSliderConfig("Dist. de Pegar", 3, 20, 8, function(v)
    CONFIG.DistanciaPegar = v
end)

criarSliderConfig("Altura do Voo", 1, 10, 3, function(v)
    CONFIG.AlturaVoo = v
end)

criarSliderConfig("Delay Pegar (s)", 0, 2, 0.3, function(v)
    CONFIG.DelayPegar = v
end)

BtnConfig.MouseButton1Click:Connect(function()
    ConfigJanela.Visible = true
    tween(ConfigJanela, { Size = UDim2.new(0, 260, 0, 320) }, 0.2)
end)

BtnConfigFechar.MouseButton1Click:Connect(function()
    tween(ConfigJanela, { Size = UDim2.new(0, 260, 0, 0) }, 0.15)
    task.wait(0.15)
    ConfigJanela.Visible = false
end)

do
    local dragging, dragStart, startPos
    ConfigTitle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = ConfigJanela.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            ConfigJanela.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

ScreenGui.Destroying:Connect(function()
    desativar()
end)

print("[M7z] Crystal Seed Finder carregado com sucesso.")
