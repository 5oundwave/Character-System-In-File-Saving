util.AddNetworkString('menu_ch_creation')
util.AddNetworkString('menu_ch_load')

util.AddNetworkString('SendCharacterModel')
util.AddNetworkString('SendCharacterInfo')
util.AddNetworkString('RequestCharacterModel')
util.AddNetworkString('CheckCharacterExists')
util.AddNetworkString('CharacterExistsResponse')

util.AddNetworkString('menu_2ch_creation')
util.AddNetworkString('menu_2ch_load')

util.AddNetworkString('Send2CharacterModel')
util.AddNetworkString('Send2CharacterInfo')
util.AddNetworkString('Request2CharacterModel')
util.AddNetworkString('2CharacterExistsResponse')

local function ensureDirectoryExists(path)
    if !file.Exists(path, 'DATA') then
        file.CreateDir(path)
    end
end

local function getPlayerDataPath(playerName)
    return 'character_system_data/' .. playerName
end

local function secondcharallowed(ply)
    local playerPath = getPlayerDataPath(ply:SteamID64())
    local state
    if file.Exists(playerPath .. '/secondcharacterallowed.txt', 'DATA') then
        state = tobool(file.Read(playerPath .. '/secondcharacterallowed.txt', 'DATA'))
    else
        file.Write(playerPath .. '/secondcharacterallowed.txt', 'false')
        state = false
    end
    return state
end

local function sendCharacterModelToClient(ply)
    local playerPath = getPlayerDataPath(ply:SteamID64())
    local json_data = file.Read(playerPath .. '/character_info.txt', 'DATA')

    if json_data then
        local character_data = util.JSONToTable(json_data)
        if character_data and character_data.model then
            net.Start('SendCharacterModel')
            net.WriteString(character_data.model)
            net.Send(ply)
        end
    end
end

local function sendSecondCharacterModelToClient(ply)
    local playerPath = getPlayerDataPath(ply:SteamID64())
    local json_data = file.Read(playerPath .. '/2character_info.txt', 'DATA')

    if json_data then
        local character_data = util.JSONToTable(json_data)
        if character_data and character_data.model then
            net.Start('Send2CharacterModel')
            net.WriteString(character_data.model)
            net.Send(ply)
        end
    end
end

local function sendCharacterInfo(ply)
    local playerPath = getPlayerDataPath(ply:SteamID64())
    local json_data = file.Read(playerPath .. '/character_info.txt', 'DATA')

    if json_data then
        local character_data = util.JSONToTable(json_data)
        if character_data then
            net.Start('SendCharacterInfo')
            net.WriteTable(character_data)
            net.Send(ply)
        end
    end
end

local function sendSecondCharacterInfo(ply)
    local playerPath = getPlayerDataPath(ply:SteamID64())
    local json_data = file.Read(playerPath .. '/2character_info.txt', 'DATA')

    if json_data then
        local character_data = util.JSONToTable(json_data)
        if character_data then
            net.Start('Send2CharacterInfo')
            net.WriteTable(character_data)
            net.Send(ply)
        end
    end
end

net.Receive('RequestCharacterModel', function(len, ply)
    sendCharacterModelToClient(ply)
    sendCharacterInfo(ply)
end)

net.Receive('Request2CharacterModel', function(len, ply)
    sendSecondCharacterModelToClient(ply)
    sendSecondCharacterInfo(ply)
end)

net.Receive('CheckCharacterExists', function(len, ply)
    local steamID64 = ply:SteamID64()
    local playerPath = getPlayerDataPath(steamID64)
    local firstexists = file.Exists(playerPath .. '/character_info.txt', 'DATA')
    local secondexists = file.Exists(playerPath .. '/2character_info.txt', 'DATA')
    local secallowed = secondcharallowed(ply)

    net.Start('CharacterExistsResponse')
    net.WriteBool(firstexists)
    net.WriteBool(secondexists)
    net.WriteBool(secallowed)
    net.Send(ply)
end)

local function updatecharacterinfo(ply)
    local bodys = ply:GetBodyGroups()
    local charname = ply:getDarkRPVar('rpname') or 'Unknown'
    local charjob = RPExtraTeams[ply:Team()].command or 'Unknown'
    local charskin = ply:GetSkin() or 0
    local charmodel = ply:GetModel() or 'models/player/Kleiner.mdl'
    -- local charrank = ply:GetNWString('PlayerRank') or 'Trainee' Field for ranks(for military or starwarsrp)
    -- local charspec = ply:GetNWString('Playerspec') or 'Gunner' Field for specialisation(for military or starwarsrp)

    local bodyGroupsData = {}
    -- Check the status of each body group
    for i = 0, #bodys - 1 do
        local status = ply:GetBodygroup(i)
        table.insert(bodyGroupsData, status)
    end

    local charbodys = table.concat(bodyGroupsData) or 000000000000

    -- Ensure the main directory exists
    ensureDirectoryExists('character_system_data')

    -- Create player-specific directory
    local playerPath = getPlayerDataPath(ply:SteamID64())
    ensureDirectoryExists(playerPath)

    local saved_data = {
        name = charname,
        job = charjob,
        bodygroups = charbodys,
        playerskin = charskin,
        model = charmodel,
        -- rank = charrank,
        -- spec = charspec,
    }

    local json_table = util.TableToJSON(saved_data)

    if ply:GetNWString('Char_ID') == 1 then
        file.Write(playerPath .. '/character_info.txt', json_table)
    elseif ply:GetNWString('Char_ID') == 2 then
        file.Write(playerPath .. '/2character_info.txt', json_table)
    end
end

local function loadcharacterinfo(ply)
    ensureDirectoryExists('character_system_data')
    local playerPath = getPlayerDataPath(ply:SteamID64())
    ensureDirectoryExists(playerPath)

    local file_table = file.Read(playerPath .. '/character_info.txt', 'DATA')

    local saved_data = util.JSONToTable(file_table)

    if saved_data then
        ply:setRPName(saved_data.name or ' ')
        local jobID
        for k, job in pairs(RPExtraTeams) do
            if job.command == saved_data.job then
                jobID = job.team
                break
            end
        end
        if jobID and team.Valid(jobID) then
            ply:SetTeam(jobID)
        else
            print('Error: Job ID ' .. tostring(jobID) .. ' is not found.')
        end
        ply:SetModel(saved_data.model or 'models/player.mdl')
        ply:SetBodyGroups(saved_data.bodygroups or 0000000000000)
        local skinid = tonumber(saved_data.playerskin)
        if skinid then
            ply:SetSkin(skinid or 0)
        end
        -- ply:SetNWString('PlayerRank', saved_data.rank or 'Trainee')
        -- ply:SetNWString('Playerspec', saved_data.spec or 'Gunner')
    else
        print('Failed to read file')
    end
end

local function loadsecondcharacterinfo(ply)
    ensureDirectoryExists('character_system_data')
    local playerPath = getPlayerDataPath(ply:SteamID64())
    ensureDirectoryExists(playerPath)

    local file_table = file.Read(playerPath .. '/2character_info.txt', 'DATA')

    local saved_data = util.JSONToTable(file_table)

    if saved_data then
        ply:setRPName(saved_data.name or ' ')
        local jobID
        for k, job in pairs(RPExtraTeams) do
            if job.command == saved_data.job then
                jobID = job.team
                break
            end
        end
        if jobID and team.Valid(jobID) then
            ply:SetTeam(jobID)
        else
            print('Error: Job ID ' .. tostring(jobID) .. ' is not found.')
        end
        ply:SetModel(saved_data.model or 'models/player.mdl')
        ply:SetBodyGroups(saved_data.bodygroups or 0000000000000)
        local skinid = tonumber(saved_data.playerskin)
        if skinid then
            ply:SetSkin(skinid or 0)
        end
        -- ply:SetNWString('PlayerRank', saved_data.rank or 'Trainee')
        -- ply:SetNWString('Playerspec', saved_data.spec or 'Gunner')
    else
        print('Failed to read file')
    end
end

local function createcharacter(ply,name)
    local charname = tostring(name)
    local charjob = 'Citizen' -- darkrp job command
    local charskin = 0
    local charmodel = 'models/player.mdl' -- character default model
    -- local charrank = 'Trainee'
    -- local charspec = 'Gunner'
    -- Ensure the main directory exists
    ensureDirectoryExists('character_system_data')

    -- Create player-specific directory
    local playerPath = getPlayerDataPath(ply:SteamID64())
    ensureDirectoryExists(playerPath)

    local saved_data = {
        name = charname,
        job = charjob,
        playerskin = charskin,
        model = charmodel,
        -- rank = charrank,
        -- spec = charspec,
    }

    if saved_data then
        ply:setRPName(saved_data.name or ' ')
        local jobID
        for k, job in pairs(RPExtraTeams) do
            if job.command == saved_data.job then
                jobID = job.team
                break
            end
        end
        if jobID and team.Valid(jobID) then
            ply:SetTeam(jobID)
        else
            print('Error: Job ID ' .. tostring(jobID) .. ' is not found.')
        end
        ply:SetModel(saved_data.model or 'models/player.mdl')
        ply:SetBodyGroups(saved_data.bodygroups or 0000000000000)
        local skinid = tonumber(saved_data.playerskin)
        if skinid then
            ply:SetSkin(skinid or 0)
        end
        -- ply:SetNWString('PlayerRank', saved_data.rank or 'Trainee')
        -- ply:SetNWString('Playerspec', saved_data.spec or 'Gunner')
    else
        print('Failed to read file')
    end

    local json_table = util.TableToJSON(saved_data)

    file.Write(playerPath .. '/character_info.txt', json_table)
end

net.Receive('menu_ch_creation', function()
    local ply = net.ReadPlayer() or nil
    local name = net.ReadString() or ' '
    createcharacter(ply,name)
    ply:KillSilent()
    ply:Spawn()
    ply:SetNWInt('Char_ID', 1)
end)

net.Receive('menu_2ch_creation', function()
    local ply = net.ReadPlayer() or nil
    local name = net.ReadString() or ' '
    createcharacter(ply,name)
    ply:KillSilent()
    ply:Spawn()
    ply:SetNWInt('Char_ID', 2)
end)

net.Receive('menu_ch_load', function()
    local ply = net.ReadPlayer() or nil
    loadcharacterinfo(ply)
    ply:KillSilent()
    ply:Spawn()
    ply:SetNWInt('Char_ID', 1)
end)

net.Receive('menu_2ch_load', function()
    local ply = net.ReadPlayer() or nil
    loadsecondcharacterinfo(ply)
    ply:KillSilent()
    ply:Spawn()
    ply:SetNWInt('Char_ID', 2)
end)

hook.Add('PlayerDisconnected', 'UpdateCharacterInfoWhenLeave', function(ply)
    updatecharacterinfo(ply)
end)

hook.Add('PlayerInitialSpawn', 'SendCharacterModelOnJoin', function(ply)
    if IsValid(ply) then
        secondcharallowed(ply)
        sendCharacterModelToClient(ply)
        sendCharacterInfo(ply)
        sendSecondCharacterModelToClient(ply)
        sendSecondCharacterInfo(ply)
        ply:ConCommand('charapter_system')
    end
end)