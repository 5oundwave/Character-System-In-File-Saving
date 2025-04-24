surface.CreateFont('font1', {
    font = 'Roboto',
    size = ScreenScale(6),
})

surface.CreateFont('font2', {
    font = 'Roboto',
    size = ScreenScale(8),
})

local LANG = include('autorun/localization_loader.lua')
local gw, gh = ScrW(), ScrH()
local image_background = Material('materials/image_baground.png', 'noclamp smooth')
local image_plus       = Material('materials/Plus.png', 'noclamp smooth')
local characterModel = 'models/player/Kleiner.mdl'
local secondcharacterModel = 'models/player/Kleiner.mdl'
local characterInfo = {}
local secondcharacterInfo = {}

net.Receive('SendCharacterModel', function()
    characterModel = net.ReadString()
    hook.Run('CharacterModelReceived')
end)

net.Receive('Send2CharacterModel', function()
    secondcharacterModel = net.ReadString()
    hook.Run('2CharacterModelReceived')
end)

net.Receive('SendCharacterInfo', function()
    characterInfo = net.ReadTable()
end)

net.Receive('Send2CharacterInfo', function()
    secondcharacterInfo = net.ReadTable()
end)

function GetCharacterModel()
    return characterModel
end

function GetSecondCharacterModel()
    return secondcharacterModel
end

local function plusik(ply)
    local buttonViboraCharapter = vgui.Create('DButton', frame)
    buttonViboraCharapter:SetSize(gw * 0.2, gh * 0.5)
    buttonViboraCharapter:SetPos(gw * 0.02, gh * 0.2)
    buttonViboraCharapter:SetText('')
    buttonViboraCharapter.Paint = function(self, w, h)
        local currentColor = Color(23, 23, 23, 225)
        local hoverColor   = Color(33, 33, 33, 255)

        if self:IsHovered() then
            currentColor = hoverColor
        end

        surface.SetDrawColor(currentColor)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255,255)
        surface.SetMaterial(image_plus)
        surface.DrawTexturedRect(w * 0.25, h * 0.3, w * 0.5, h * 0.4)
    end
    local dopPanel
    buttonViboraCharapter.DoClick = function()
        if dopPanel then
            dopPanel:Remove()
        end
        dopPanelblyat()
    end

    function dopPanelblyat()
        dopPanel = vgui.Create('DPanel', frame)
        dopPanel:SetSize(gw * 0.6, gh * 0.7)
        dopPanel:SetPos(gw * 0.3, gh * 0.1)

        dopPanel.Paint = function (self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(23, 23, 23, 225))
            draw.SimpleText(LANG['nameofthecharacter'], 'font2', w * 0.7, h * 0.15, Color( 255, 255, 255, 255 ), 1,1)

            local textY = h * 0.25
            local texts = LANG['nameexample']

            for _, text in ipairs(texts) do
                draw.SimpleText(text, 'font2', w * 0.5, textY, Color( 255, 255, 255, 255 ), 1, 1)
                textY = textY + ScreenScale(8)
            end
        end

        local modelPanel = vgui.Create('DModelPanel', dopPanel)
        modelPanel:SetSize(dopPanel:GetWide() * 0.6, dopPanel:GetTall())
        modelPanel:SetPos(dopPanel:GetWide() * -.15, 0)
        modelPanel:SetModel('models/maintail.mdl')

        local textentrysuka = vgui.Create('DTextEntry', dopPanel)
        textentrysuka:SetSize(dopPanel:GetWide() * 0.3, dopPanel:GetTall() * 0.1)
        textentrysuka:SetPos(dopPanel:GetWide() * 0.3, dopPanel:GetTall() * 0.1)
        textentrysuka:SetFont('font2')
        textentrysuka:SetPlaceholderText(LANG['entertext'])

        local buttonCreate = vgui.Create('DButton', dopPanel)
        buttonCreate:SetSize(dopPanel:GetWide() * 0.2, dopPanel:GetTall() * 0.1)
        buttonCreate:SetPos(dopPanel:GetWide() * 0.5, dopPanel:GetTall() * 0.8)
        buttonCreate:SetText(LANG['create'])
        buttonCreate:SetFont('font2')

        buttonCreate.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255))
            draw.SimpleText(self:GetText(), 'font2', w / 2, h / 2, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        buttonCreate.DoClick = function()
            frame:Remove()
            net.Start('menu_ch_creation')
                net.WritePlayer(LocalPlayer())
                net.WriteString(textentrysuka:GetValue() or 'Не установлен никнейм')
            net.SendToServer()
        end
    end
end

local function secondplusik(ply)
    local sbuttonViboraCharapter = vgui.Create('DButton', frame)
    sbuttonViboraCharapter:SetSize(gw * 0.2, gh * 0.5)
    sbuttonViboraCharapter:SetPos(gw * 0.25, gh * 0.2)
    sbuttonViboraCharapter:SetText('')
    sbuttonViboraCharapter.Paint = function(self, w, h)
        local currentColor = Color(23, 23, 23, 225)
        local hoverColor   = Color(33, 33, 33, 255)

        if self:IsHovered() then
            currentColor = hoverColor
        end

        surface.SetDrawColor(currentColor)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255,255)
        surface.SetMaterial(image_plus)
        surface.DrawTexturedRect(w * 0.25, h * 0.3, w * 0.5, h * 0.4)
    end
    local sdopPanel
    sbuttonViboraCharapter.DoClick = function()
        if sdopPanel then
            sdopPanel:Remove()
        end
        sdopPanelblyat()
    end
    function sdopPanelblyat()
        sdopPanel = vgui.Create('DPanel', frame)
        sdopPanel:SetSize(gw * 0.6, gh * 0.7)
        sdopPanel:SetPos(gw * 0.3, gh * 0.1)

        sdopPanel.Paint = function (self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(23, 23, 23, 225))
            draw.SimpleText(LANG['nameofthecharacter'], 'font2', w * 0.7, h * 0.15, Color( 255, 255, 255, 255 ), 1,1)

            local textY = h * 0.25
            local texts = LANG['nameexample']

            for _, text in ipairs(texts) do
                draw.SimpleText(text, 'font2', w * 0.5, textY, Color( 255, 255, 255, 255 ), 1, 1)
                textY = textY + ScreenScale(8)
            end
        end

        local modelPanel = vgui.Create('DModelPanel', sdopPanel)
        modelPanel:SetSize(sdopPanel:GetWide() * 0.6, sdopPanel:GetTall())
        modelPanel:SetPos(sdopPanel:GetWide() * -.15, 0)
        modelPanel:SetModel('models/maintail.mdl')

        local textentrysuka = vgui.Create('DTextEntry', sdopPanel)
        textentrysuka:SetSize(sdopPanel:GetWide() * 0.3, sdopPanel:GetTall() * 0.1)
        textentrysuka:SetPos(sdopPanel:GetWide() * 0.3, sdopPanel:GetTall() * 0.1)
        textentrysuka:SetFont('font2')
        textentrysuka:SetPlaceholderText(LANG['entertext'])

        local buttonCreate = vgui.Create('DButton', sdopPanel)
        buttonCreate:SetSize(sdopPanel:GetWide() * 0.2, sdopPanel:GetTall() * 0.1)
        buttonCreate:SetPos(sdopPanel:GetWide() * 0.5, sdopPanel:GetTall() * 0.8)
        buttonCreate:SetText(LANG['create'])
        buttonCreate:SetFont('font2')

        buttonCreate.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255))
            draw.SimpleText(self:GetText(), 'font2', w / 2, h / 2, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        buttonCreate.DoClick = function()
            frame:Remove()
            net.Start('menu_2ch_creation')
                net.WritePlayer(LocalPlayer())
                net.WriteString(textentrysuka:GetValue() or 'Не установлен никнейм')
            net.SendToServer()
        end
    end
end

local function characterexists(ply)
    local buttonexistscharacter = vgui.Create('DPanel', frame)
    buttonexistscharacter:SetSize(gw * 0.2, gh * 0.5)
    buttonexistscharacter:SetPos(gw * 0.02, gh * 0.2)
    buttonexistscharacter.Paint = function(self, w, h)
        local currentColor = Color(23, 23, 23, 225)
        local hoverColor   = Color(33, 33, 33, 255)

        if self:IsHovered() then
            currentColor = hoverColor
        end

        draw.RoundedBox(0, 0, 0, w, h, currentColor)
    end

    local modelPanel = vgui.Create('DModelPanel', buttonexistscharacter)
    modelPanel:SetSize(buttonexistscharacter:GetWide(), buttonexistscharacter:GetTall() * 0.7)
    modelPanel:SetPos(0, 0)

    local function updateModel()
        if IsValid(modelPanel) then
            modelPanel:SetModel(GetCharacterModel())
        end
    end

    updateModel()
    function modelPanel:LayoutEntity(Entity) return end
    hook.Add('CharacterModelReceived', 'UpdateCharacterModel', updateModel)

    local nameLabel = vgui.Create('DLabel', buttonexistscharacter)
    nameLabel:SetPos(10, buttonexistscharacter:GetTall() * 0.7)
    nameLabel:SetSize(buttonexistscharacter:GetWide() - 20, ScreenScale(5))
    nameLabel:SetFont('font1')
    nameLabel:SetText(LANG['name'] .. (characterInfo.name or LANG['loading']))

    local jobLabel = vgui.Create('DLabel', buttonexistscharacter)
    jobLabel:SetPos(10, buttonexistscharacter:GetTall() * 0.74)
    jobLabel:SetSize(buttonexistscharacter:GetWide() - 20, ScreenScale(5))
    jobLabel:SetFont('font1')
    local jobName = LANG['loading']
    for k, job in pairs(RPExtraTeams) do
        if job.command == characterInfo.job then
            jobName = job.name
            break
        end
    end
    jobLabel:SetText(LANG['job'] .. jobName)

    -- local specLabel = vgui.Create('DLabel', buttonexistscharacter)
    -- specLabel:SetPos(10, buttonexistscharacter:GetTall() * 0.78)
    -- specLabel:SetSize(buttonexistscharacter:GetWide() - 20, ScreenScale(5))
    -- specLabel:SetFont('font1')
    -- specLabel:SetText(LANG['specialisation'] .. (characterInfo.spec or LANG['loading']))

    -- local rankLabel = vgui.Create('DLabel', buttonexistscharacter)
    -- rankLabel:SetPos(10, buttonexistscharacter:GetTall() * 0.82)
    -- rankLabel:SetSize(buttonexistscharacter:GetWide() - 20, ScreenScale(5))
    -- rankLabel:SetFont('font1')
    -- rankLabel:SetText(LANG['rank'] .. (characterInfo.rank or LANG['loading']))

    local buttonLoad = vgui.Create('DButton', buttonexistscharacter)
    buttonLoad:SetSize(buttonexistscharacter:GetWide() * 0.8, buttonexistscharacter:GetTall() * 0.1)
    buttonLoad:SetPos(buttonexistscharacter:GetWide() * 0.1, buttonexistscharacter:GetTall() * 0.88)
    buttonLoad:SetText(LANG['load'])
    buttonLoad:SetFont('font1')

    buttonLoad.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
        draw.SimpleText(self:GetText(), 'font1', w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    buttonLoad.DoClick = function()
        net.Start('menu_ch_load')
            net.WritePlayer(ply)
            frame:Remove()
        net.SendToServer()
    end
end

local function secondcharacterexists(ply)
    local buttonexistscharacter = vgui.Create('DPanel', frame)
    buttonexistscharacter:SetSize(gw * 0.2, gh * 0.5)
    buttonexistscharacter:SetPos(gw * 0.25, gh * 0.2)
    buttonexistscharacter.Paint = function(self, w, h)
        local currentColor = Color(23, 23, 23, 225)
        local hoverColor   = Color(33, 33, 33, 255)

        if self:IsHovered() then
            currentColor = hoverColor
        end

        draw.RoundedBox(0, 0, 0, w, h, currentColor)
    end

    local modelPanel = vgui.Create('DModelPanel', buttonexistscharacter)
    modelPanel:SetSize(buttonexistscharacter:GetWide(), buttonexistscharacter:GetTall() * 0.7)
    modelPanel:SetPos(0, 0)

    local function updateModel()
        if IsValid(modelPanel) then
            modelPanel:SetModel(GetSecondCharacterModel())
        end
    end

    updateModel()
    function modelPanel:LayoutEntity(Entity) return end
    hook.Add('2CharacterModelReceived', 'Update2CharacterModel', updateModel)

    local nameLabel = vgui.Create('DLabel', buttonexistscharacter)
    nameLabel:SetPos(10, buttonexistscharacter:GetTall() * 0.7)
    nameLabel:SetSize(buttonexistscharacter:GetWide() - 20, ScreenScale(5))
    nameLabel:SetFont('font1')
    nameLabel:SetText(LANG['name'] .. (secondcharacterInfo.name or LANG['loading']))

    local jobLabel = vgui.Create('DLabel', buttonexistscharacter)
    jobLabel:SetPos(10, buttonexistscharacter:GetTall() * 0.74)
    jobLabel:SetSize(buttonexistscharacter:GetWide() - 20, ScreenScale(5))
    jobLabel:SetFont('font1')
    local jobName = LANG['loading']
    for k, job in pairs(RPExtraTeams) do
        if job.command == secondcharacterInfo.job then
            jobName = job.name
            break
        end
    end
    jobLabel:SetText(LANG['job'] .. jobName)

    local specLabel = vgui.Create('DLabel', buttonexistscharacter)
    specLabel:SetPos(10, buttonexistscharacter:GetTall() * 0.78)
    specLabel:SetSize(buttonexistscharacter:GetWide() - 20, ScreenScale(5))
    specLabel:SetFont('font1')
    specLabel:SetText(LANG['specialisation'] .. (secondcharacterInfo.spec or LANG['loading']))

    local rankLabel = vgui.Create('DLabel', buttonexistscharacter)
    rankLabel:SetPos(10, buttonexistscharacter:GetTall() * 0.82)
    rankLabel:SetSize(buttonexistscharacter:GetWide() - 20, ScreenScale(5))
    rankLabel:SetFont('font1')
    rankLabel:SetText(LANG['rank'] .. (secondcharacterInfo.rank or LANG['loading']))

    local buttonLoad = vgui.Create('DButton', buttonexistscharacter)
    buttonLoad:SetSize(buttonexistscharacter:GetWide() * 0.8, buttonexistscharacter:GetTall() * 0.1)
    buttonLoad:SetPos(buttonexistscharacter:GetWide() * 0.1, buttonexistscharacter:GetTall() * 0.88)
    buttonLoad:SetText(LANG['load'])
    buttonLoad:SetFont('font1')

    buttonLoad.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
        draw.SimpleText(self:GetText(), 'font1', w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    buttonLoad.DoClick = function()
        net.Start('menu_2ch_load')
            net.WritePlayer(ply)
            frame:Remove()
        net.SendToServer()
    end
end

local function CharapterSystem(ply)
    net.Start('RequestCharacterModel')
    net.SendToServer()
    net.Start('Request2CharacterModel')
    net.SendToServer()
    net.Start('CheckCharacterExists')
    net.SendToServer()

    net.Receive('CharacterExistsResponse', function()
        local firstexists = net.ReadBool()
        local secondexists = net.ReadBool()
        local secondallowed = net.ReadBool()

        frame = vgui.Create('DFrame')
        frame:SetSize(gw, gh)
        frame:SetPos(0,0)
        frame:MakePopup()
        frame:SetDraggable(false)
        frame:SetTitle('')
        frame:ShowCloseButton(false)

        frame.Paint = function(self, w, h)
            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(image_background)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        if firstexists then
            characterexists(ply)
        elseif !firstexists then
            plusik(ply)
        end
        if secondexists then
            secondcharacterexists(ply)
        elseif !secondexists and secondallowed == true then
            secondplusik(ply)
        end
    end)
end

concommand.Add('charapter_system', function(ply)
    CharapterSystem(ply)
end)