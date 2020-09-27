local addonVer = "1.0.0.0" --don't use letters or numbers > 10
local me = UnitName('player')

local TWA = CreateFrame("Frame")

local TWATargetsDropDown = CreateFrame('Frame', 'TWATargetsDropDown', UIParent, 'UIDropDownMenuTemplate')
local TWATanksDropDown = CreateFrame('Frame', 'TWATanksDropDown', UIParent, 'UIDropDownMenuTemplate')
local TWAHealersDropDown = CreateFrame('Frame', 'TWAHealersDropDown', UIParent, 'UIDropDownMenuTemplate')

local TWATemplates = CreateFrame('Frame', 'TWATemplates', UIParent, 'UIDropDownMenuTemplate')


function twaprint(a)
    if a == nil then
        DEFAULT_CHAT_FRAME:AddMessage('|cff69ccf0[TWA]|cff0070de:' .. time() .. '|cffffffff attempt to print a nil value.')
        return false
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cff69ccf0[TWA] |cffffffff" .. a)
end

function twaerror(a)
    DEFAULT_CHAT_FRAME:AddMessage('|cff69ccf0[TWA]|cff0070de:' .. time() .. '|cffffffff[' .. a .. ']')
end

function twadebug(a)
    --    if not TWLC_DEBUG then return end
    if me == 'Kzktst' or me == 'Xerrtwo' then
        twaprint('|cff0070de[TWADEBUG:' .. time() .. ']|cffffffff[' .. a .. ']')
    end
end


TWA:RegisterEvent("ADDON_LOADED")
TWA:RegisterEvent("RAID_ROSTER_UPDATE")
TWA:RegisterEvent("CHAT_MSG_ADDON")
TWA:RegisterEvent("CHAT_MSG_WHISPER")

TWA.data = {}

local twa_templates = {
    ['gaar'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [3] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [4] = { "Triangle", "-", "-", "-", "-", "-", "-" },
        [5] = { "Square", "-", "-", "-", "-", "-", "-" },
        [6] = { "Diamond", "-", "-", "-", "-", "-", "-" },
        [7] = { "Circle", "-", "-", "-", "-", "-", "-" },
        [8] = { "Star", "-", "-", "-", "-", "-", "-" },
        [9] = { "Moon", "-", "-", "-", "-", "-", "-" }
    },
    ['domo'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [3] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [4] = { "Triangle", "-", "-", "-", "-", "-", "-" },
        [5] = { "Square", "-", "-", "-", "-", "-", "-" },
        [6] = { "Diamond", "-", "-", "-", "-", "-", "-" },
        [7] = { "Circle", "-", "-", "-", "-", "-", "-" },
        [8] = { "Star", "-", "-", "-", "-", "-", "-" },
        [9] = { "Moon", "-", "-", "-", "-", "-", "-" }
    },
    ['rag'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Melee", "-", "-", "-", "-", "-", "-" },
        [3] = { "Ranged", "-", "-", "-", "-", "-", "-" },
    },
    ['razorgore'] = {
        [1] = { "Left", "-", "-", "-", "-", "-", "-" },
        [2] = { "Left", "-", "-", "-", "-", "-", "-" },
        [3] = { "Left", "-", "-", "-", "-", "-", "-" },
        [4] = { "Right", "-", "-", "-", "-", "-", "-" },
        [5] = { "Right", "-", "-", "-", "-", "-", "-" },
        [6] = { "Right", "-", "-", "-", "-", "-", "-" },
    },
    ['vael'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Group 1", "-", "-", "-", "-", "-", "-" },
        [3] = { "Group 2", "-", "-", "-", "-", "-", "-" },
        [4] = { "Group 3", "-", "-", "-", "-", "-", "-" },
        [5] = { "Group 4", "-", "-", "-", "-", "-", "-" },
        [6] = { "Group 5", "-", "-", "-", "-", "-", "-" },
        [7] = { "Group 6", "-", "-", "-", "-", "-", "-" },
        [8] = { "Group 7", "-", "-", "-", "-", "-", "-" },
        [9] = { "Group 8", "-", "-", "-", "-", "-", "-" },
    },
    ['lashlayer'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [3] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [4] = { "BOSS", "-", "-", "-", "-", "-", "-" },
    },
    ['chromaggus'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Dispels", "-", "-", "-", "-", "-", "-" },
        [3] = { "Dispels", "-", "-", "-", "-", "-", "-" },
        [4] = { "Enrage", "-", "-", "-", "-", "-", "-" },
    },
    ['nef'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Left", "-", "-", "-", "-", "-", "-" },
        [3] = { "Left", "-", "-", "-", "-", "-", "-" },
        [4] = { "Right", "-", "-", "-", "-", "-", "-" },
        [5] = { "Right", "-", "-", "-", "-", "-", "-" },
    }
}

function TWA.loadTemplate(template, load)
    if load ~= nil and load == true then
        TWA.data = {}
        for i, d in next, twa_templates[template] do
            TWA.data[i] = d
        end
        TWA.PopulateTWA()
        twaprint('Loaded template |cff69ccf0' .. template)
        getglobal('TWA_MainTemplates'):SetText(template)
        return true
    end
    ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "LoadTemplate=" .. template, "RAID")
end

--default
TWA.raid = {
    ['warrior'] = {},
    ['paladin'] = {},
    ['druid'] = {},
    ['warlock'] = {},
    ['mage'] = {},
    ['priest'] = {},
    ['rogue'] = {},
    ['shaman'] = {},
    ['hunter'] = {},
}

--testing
--TWA.raid = {
--    ['warrior'] = { 'Smultron', 'Jeff', 'Reis', 'Mesmorc' },
--    ['paladin'] = { 'Paleddin', 'Laughadin' },
--    ['druid'] = { 'Kashchada', 'Faralynn', 'Lulzer' },
--    ['warlock'] = { 'Baba', 'Furry', 'Faust' },
--    ['mage'] = { 'Momo', 'Trepp', 'Linette' },
--    ['priest'] = { 'Er', 'Dispatch', 'Morrgoth' },
--    ['rogue'] = { 'Tyrelys', 'Smersh', 'Tonysoprano' },
--    ['shaman'] = { 'Ilmane', 'Buffalo', 'Cloudburst' },
--    ['hunter'] = { 'Chlo', 'Zteban', 'Ruari' },
--}

TWA.classes = {
    ['Warriors'] = 'warrior',
    ['Paladins'] = 'paladin',
    ['Druids'] = 'druid',
    ['Warlocks'] = 'warlock',
    ['Mages'] = 'mage',
    ['Priests'] = 'priest',
    ['Rogues'] = 'rogue',
    ['Shamans'] = 'shaman',
    ['Hunters'] = 'hunter',
}

TWA.classColors = {
    ["warrior"] = { r = 0.78, g = 0.61, b = 0.43, c = "|cffc79c6e" },
    ["mage"] = { r = 0.41, g = 0.8, b = 0.94, c = "|cff69ccf0" },
    ["rogue"] = { r = 1, g = 0.96, b = 0.41, c = "|cfffff569" },
    ["druid"] = { r = 1, g = 0.49, b = 0.04, c = "|cffff7d0a" },
    ["hunter"] = { r = 0.67, g = 0.83, b = 0.45, c = "|cffabd473" },
    ["shaman"] = { r = 0.14, g = 0.35, b = 1.0, c = "|cff0070de" },
    ["priest"] = { r = 1, g = 1, b = 1, c = "|cffffffff" },
    ["warlock"] = { r = 0.58, g = 0.51, b = 0.79, c = "|cff9482c9" },
    ["paladin"] = { r = 0.96, g = 0.55, b = 0.73, c = "|cfff58cba" },
    ["krieger"] = { r = 0.78, g = 0.61, b = 0.43, c = "|cffc79c6e" },
    ["magier"] = { r = 0.41, g = 0.8, b = 0.94, c = "|cff69ccf0" },
    ["schurke"] = { r = 1, g = 0.96, b = 0.41, c = "|cfffff569" },
    ["druide"] = { r = 1, g = 0.49, b = 0.04, c = "|cffff7d0a" },
    ["jäger"] = { r = 0.67, g = 0.83, b = 0.45, c = "|cffabd473" },
    ["schamane"] = { r = 0.14, g = 0.35, b = 1.0, c = "|cff0070de" },
    ["priester"] = { r = 1, g = 1, b = 1, c = "|cffffffff" },
    ["hexenmeister"] = { r = 0.58, g = 0.51, b = 0.79, c = "|cff9482c9" },
}

TWA.marks = {
    ['Star'] = TWA.classColors['rogue'].c,
    ['Circle'] = TWA.classColors['druid'].c,
    ['Diamond'] = TWA.classColors['paladin'].c,
    ['Triangle'] = TWA.classColors['hunter'].c,
    ['Moon'] = '|cffffffff',
    ['Square'] = TWA.classColors['mage'].c,
    ['Cross'] = '|cffff0000',
    ['Skull'] = '|cffffffff',
}

TWA.sides = {
    --if changed also change in buildTargetsDropdown !
    ['Left'] = TWA.classColors['warlock'].c,
    ['Right'] = TWA.classColors['mage'].c,
}
TWA.coords = {
    --if changed also change in buildTargetsDropdown !
    ['North'] = '|cffffffff',
    ['South'] = '|cffffffff',
    ['East'] = '|cffffffff',
    ['West'] = '|cffffffff',
}
TWA.misc = {
    ['Raid'] = TWA.classColors['shaman'].c,
    ['Melee'] = TWA.classColors['rogue'].c,
    ['Ranged'] = TWA.classColors['mage'].c,
    ['BOSS'] = '|cffff3333',
    ['Enrage'] = '|cffff7777',
    ['Dispels'] = TWA.classColors['mage'].c,
}

TWA.groups = {
    ['Group 1'] = TWA.classColors['priest'].c,
    ['Group 2'] = TWA.classColors['priest'].c,
    ['Group 3'] = TWA.classColors['priest'].c,
    ['Group 4'] = TWA.classColors['priest'].c,
    ['Group 5'] = TWA.classColors['priest'].c,
    ['Group 6'] = TWA.classColors['priest'].c,
    ['Group 7'] = TWA.classColors['priest'].c,
    ['Group 8'] = TWA.classColors['priest'].c,
}

TWA:SetScript("OnEvent", function()
    if event then
        if event == "ADDON_LOADED" and arg1 == "TWAssignments" then
            twaprint("TWA Loaded")
            if not TWA_DATA then
                TWA_DATA = {
                    [1] = { '-', '-', '-', '-', '-', '-', '-' },
                }
                TWA.data = TWA_DATA
            end
            TWA.data = TWA_DATA
            TWA.fillRaidData()
            TWA.PopulateTWA()
        end
        if event == "RAID_ROSTER_UPDATE" then
            TWA.fillRaidData()
            TWA.PopulateTWA()
        end
        if event == 'CHAT_MSG_ADDON' and arg1 == "TWA" then
            twadebug(arg4 .. ' says: ' .. arg2)
            TWA.handleSync(arg1, arg2, arg3, arg4)
        end
        if event == 'CHAT_MSG_WHISPER' then
            if arg1 == 'heal' then
                local sentAssignment = false
                local lineToSend = ''
                for line, row in next, TWA.data do
                    local mark = ''
                    local tank = ''
                    for i, cell in next, row do
                        if i == 1 then
                            mark = cell
                            tank = mark
                        end
                        if i == 2 or i == 3 or i == 4 then
                            if cell ~= '-' then tank = '' end
                        end
                        if i == 2 or i == 3 or i == 4 then
                            if cell ~= '-' then
                                tank = tank .. cell .. ' '
                            end
                        end
                        if arg2 == cell then
                            if i == 2 or i == 3 or i == 4 then
                                if lineToSend == '' then
                                    lineToSend = 'You are assigned to ' .. mark
                                else
                                    lineToSend = lineToSend .. ' and ' .. mark
                                end
--                                ChatThrottleLib:SendChatMessage("BULK", "TWA", " " .. mark, "WHISPER", "Common", arg2);
--                                sentAssignment = true
                            end
                            if i == 5 or i == 6 or i == 7 then
                                if lineToSend == '' then
                                    lineToSend = 'You are assigned to Heal ' .. tank
                                else
                                    lineToSend = lineToSend .. ' and ' .. tank
                                end
--                                ChatThrottleLib:SendChatMessage("BULK", "TWA", "You are assigned to Heal " .. tank, "WHISPER", "Common", arg2);
--                                sentAssignment = true
                            end
                        end
                    end
                end
                if lineToSend == '' then
                    ChatThrottleLib:SendChatMessage("BULK", "TWA", 'You are not assigned.', "WHISPER", "Common", arg2);
                else
                    ChatThrottleLib:SendChatMessage("BULK", "TWA", lineToSend, "WHISPER", "Common", arg2);
                end
--                if not sentAssignment then
--                    ChatThrottleLib:SendChatMessage("BULK", "TWA", "You are not assigned.", "WHISPER", "Common", arg2);
--                end
            end
        end
    end
end)

function TWA.markOrPlayerUsed(markOrPlayer)
    for row, data in next, TWA.data do
        for _, as in next, data do
            if as == markOrPlayer then return true end
        end
    end
    return false
end

function TWA.fillRaidData()
    twadebug('fill raid data')
    TWA.raid = {
        ['warrior'] = {},
        ['paladin'] = {},
        ['druid'] = {},
        ['warlock'] = {},
        ['mage'] = {},
        ['priest'] = {},
        ['rogue'] = {},
        ['shaman'] = {},
        ['hunter'] = {},
    }
    for i = 0, GetNumRaidMembers() do
        if (GetRaidRosterInfo(i)) then
            local name, _, _, _, _, _, z = GetRaidRosterInfo(i);
            local _, unitClass = UnitClass('raid' .. i) --standard
            unitClass = string.lower(unitClass)
            table.insert(TWA.raid[unitClass], name)
        end
    end
end

function TWA.isPlayerOffline(name)
    for i = 0, GetNumRaidMembers() do
        if (GetRaidRosterInfo(i)) then
            local n, _, _, _, _, _, z = GetRaidRosterInfo(i);
            if n == name and z == 'Offline' then
                return true
            end
        end
    end
    return false
end

function TWA.handleSync(pre, t, ch, sender)

    if string.find(t, 'LoadTemplate=', 1, true) then
        local tempEx = string.split(t, '=')
        if not tempEx[2] then return false end
        TWA.loadTemplate(tempEx[2], true)
    end

    if string.find(t, 'SendTable=', 1, true) then
        local sendEx = string.split(t, '=')
        if not sendEx[2] then return false end

        if sendEx[2] == me then
            ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "FullSync=start", "RAID")
            for row, data in next, TWA.data do
                ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "FullSync=" ..
                        data[1] .. '=' ..
                        data[2] .. '=' ..
                        data[3] .. '=' ..
                        data[4] .. '=' ..
                        data[5] .. '=' ..
                        data[6] .. '=' ..
                        data[7], "RAID")
            end
            ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "FullSync=end", "RAID")
        end
    end

    if string.find(t, 'FullSync=', 1, true) and sender ~= me then
        local sEx = string.split(t, '=')
        if sEx[2] == 'start' then
            TWA.data = {}
        elseif sEx[2] == 'end' then
            TWA.PopulateTWA()
        else
            if sEx[2] and sEx[3] and sEx[4] and sEx[5] and sEx[6] and sEx[7] and sEx[8] then
                local index = table.getn(TWA.data) + 1
                TWA.data[index] = {}
                TWA.data[index][1] = sEx[2]
                TWA.data[index][2] = sEx[3]
                TWA.data[index][3] = sEx[4]
                TWA.data[index][4] = sEx[5]
                TWA.data[index][5] = sEx[6]
                TWA.data[index][6] = sEx[7]
                TWA.data[index][7] = sEx[8]
            end
        end
    end

    if string.find(t, 'RemRow=', 1, true) then
        local rowEx = string.split(t, '=')
        if not rowEx[2] then return false end
        if not tonumber(rowEx[2]) then return false end

        TWA.RemRow(tonumber(rowEx[2]), sender)
    end
    if string.find(t, 'ChangeCell=', 1, true) then
        local changeEx = string.split(t, '=')
        if not changeEx[2] or not changeEx[3] then return false end
        if not tonumber(changeEx[2]) or not changeEx[3] then return false end

        TWA.change(tonumber(changeEx[2]), changeEx[3], sender)
    end
    if string.find(t, 'Reset', 1, true) then
        TWA.Reset()
    end
    if string.find(t, 'AddLine', 1, true) then
        TWA.AddLine()
    end
end

TWA.rows = {}
TWA.cells = {}

function TWA.changeCell(xy, to)
    ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "ChangeCell=" .. xy .. "=" .. to, "RAID")
    local x = math.floor(xy / 100)
    local y = xy - x * 100
    TWA.closeDropdown(y)
end

function TWA.change(xy, to, sender)
    local x = math.floor(xy / 100)
    local y = xy - x * 100

    if not TWA.data[x] then
        ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "SendTable=" .. sender, "RAID")
        return false
    end

    if to ~= 'clear' then
        TWA.data[x][y] = to
    else
        TWA.data[x][y] = '-'
    end

    TWA.PopulateTWA()
end

function TWA.closeDropdown(y)
    if y == 1 then ToggleDropDownMenu(1, nil, getglobal('TWATargetsDropDown'), "cursor", 2, 3) end
    if y == 2 or y == 3 or y == 4 then ToggleDropDownMenu(1, nil, getglobal('TWATanksDropDown'), "cursor", 2, 3) end
    if y == 5 or y == 6 or 6 == 7 then ToggleDropDownMenu(1, nil, getglobal('TWAHealersDropDown'), "cursor", 2, 3) end
end

function TWA.PopulateTWA()

    twadebug('PopulateTWA')

    for i = 1, 25 do
        if TWA.rows[i] then
            if TWA.rows[i]:IsVisible() then
                TWA.rows[i]:Hide()
            end
        end
    end

    for index, data in next, TWA.data do

        if not TWA.rows[index] then
            TWA.rows[index] = CreateFrame('Frame', 'TWRow' .. index, getglobal("TWA_Main"), 'TWRow')
        end

        TWA.rows[index]:Show()

        TWA.rows[index]:SetBackdropColor(0, 0, 0, .2);

        TWA.rows[index]:SetPoint("TOP", getglobal("TWA_Main"), "TOP", 0, -25 - index * 21)
        if not TWA.cells[index] then
            TWA.cells[index] = {}
        end

        getglobal('TWRow' .. index .. 'CloseRow'):SetID(index)

        local line = ''

        for i, name in data do

            if not TWA.cells[index][i] then
                TWA.cells[index][i] = CreateFrame('Frame', 'TWCell' .. index .. i, TWA.rows[index], 'TWCell')
            end

            TWA.cells[index][i]:SetPoint("LEFT", TWA.rows[index], "LEFT", -82 + i * 82, 0)

            getglobal('TWCell' .. index .. i .. 'Button'):SetID((index * 100) + i)

            local color = TWA.classColors['priest'].c
            TWA.cells[index][i]:SetBackdropColor(.2, .2, .2, .7);
            for c, n in next, TWA.raid do
                for _, raidMember in next, n do
                    if raidMember == name then
                        color = TWA.classColors[c].c
                        local r = TWA.classColors[c].r
                        local g = TWA.classColors[c].g
                        local b = TWA.classColors[c].b
                        TWA.cells[index][i]:SetBackdropColor(r, g, b, .7);
                        break
                    end
                end
            end

            if TWA.marks[name] then color = TWA.marks[name] end
            if TWA.sides[name] then color = TWA.sides[name] end
            if TWA.coords[name] then color = TWA.coords[name] end
            if TWA.misc[name] then color = TWA.misc[name] end
            if TWA.groups[name] then color = TWA.groups[name] end

            if name == '-' then name = '' end

            if TWA.isPlayerOffline(name) then
                color = '|cffff0000'
            end

            getglobal('TWCell' .. index .. i .. 'Text'):SetText(color .. name)

            getglobal('TWCell' .. index .. i .. 'Icon'):Hide()
            getglobal('TWCell' .. index .. i .. 'Icon'):SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");

            if name == 'Skull' then
                getglobal('TWCell' .. index .. i .. 'Icon'):SetTexCoord(0.75, 1, 0.25, 0.5)
                getglobal('TWCell' .. index .. i .. 'Icon'):Show()
            end
            if name == 'Cross' then
                getglobal('TWCell' .. index .. i .. 'Icon'):SetTexCoord(0.5, 0.75, 0.25, 0.5)
                getglobal('TWCell' .. index .. i .. 'Icon'):Show()
            end
            if name == 'Square' then
                getglobal('TWCell' .. index .. i .. 'Icon'):SetTexCoord(0.25, 0.5, 0.25, 0.5)
                getglobal('TWCell' .. index .. i .. 'Icon'):Show()
            end
            if name == 'Moon' then
                getglobal('TWCell' .. index .. i .. 'Icon'):SetTexCoord(0, 0.25, 0.25, 0.5)
                getglobal('TWCell' .. index .. i .. 'Icon'):Show()
            end
            if name == 'Triangle' then
                getglobal('TWCell' .. index .. i .. 'Icon'):SetTexCoord(0.75, 1, 0, 0.25)
                getglobal('TWCell' .. index .. i .. 'Icon'):Show()
            end
            if name == 'Diamond' then
                getglobal('TWCell' .. index .. i .. 'Icon'):SetTexCoord(0.5, 0.75, 0, 0.25)
                getglobal('TWCell' .. index .. i .. 'Icon'):Show()
            end
            if name == 'Circle' then
                getglobal('TWCell' .. index .. i .. 'Icon'):SetTexCoord(0.25, 0.5, 0, 0.25)
                getglobal('TWCell' .. index .. i .. 'Icon'):Show()
            end
            if name == 'Star' then
                getglobal('TWCell' .. index .. i .. 'Icon'):SetTexCoord(0, 0.25, 0, 0.25)
                getglobal('TWCell' .. index .. i .. 'Icon'):Show()
            end

            line = line .. name .. '-'
        end
    end

    local newLen = 0
    for _ in next, TWA.data do
        newLen = newLen + 1
    end

    getglobal('TWA_Main'):SetHeight(50 + table.getn(TWA.data) * 21)
    TWA_DATA = TWA.data
end

function Buttoane_OnEnter(id)

    local index = math.floor(id / 100)
    local i = id - index * 100

    if id < 100 then
        index = id
    end

    getglobal('TWRow' .. index):SetBackdropColor(1, 1, 1, .2)
end

function Buttoane_OnLeave(id)

    local index = math.floor(id / 100)
    local i = id - index * 100

    if id < 100 then
        index = id
    end

    getglobal('TWRow' .. index):SetBackdropColor(0, 0, 0, .2)
end

function RequestSync_OnClick()
    ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "FullSync", "RAID")
end

function buildTargetsDropdown()

    if UIDROPDOWNMENU_MENU_LEVEL == 1 then

        local Title = {}
        Title.text = "Targets"
        Title.isTitle = true
        UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

        local Marks = {}
        Marks.text = TWA.classColors['mage'].c .. "Marks"
        Marks.notCheckable = true
        Marks.hasArrow = true
        Marks.value = {
            ['key'] = 'marks'
        }
        UIDropDownMenu_AddButton(Marks, UIDROPDOWNMENU_MENU_LEVEL);

        local Sides = {}
        Sides.text = "Sides"
        Sides.notCheckable = true
        Sides.hasArrow = true
        Sides.value = {
            ['key'] = 'sides'
        }
        UIDropDownMenu_AddButton(Sides, UIDROPDOWNMENU_MENU_LEVEL);

        local Coords = {}
        Coords.text = "Coords"
        Coords.notCheckable = true
        Coords.hasArrow = true
        Coords.value = {
            ['key'] = 'coords'
        }
        UIDropDownMenu_AddButton(Coords, UIDROPDOWNMENU_MENU_LEVEL);

        local Targets = {}
        Targets.text = "Misc"
        Targets.notCheckable = true
        Targets.hasArrow = true
        Targets.value = {
            ['key'] = 'misc'
        }
        UIDropDownMenu_AddButton(Targets, UIDROPDOWNMENU_MENU_LEVEL);

        local Groups = {}
        Groups.text = "Groups"
        Groups.notCheckable = true
        Groups.hasArrow = true
        Groups.value = {
            ['key'] = 'groups'
        }
        UIDropDownMenu_AddButton(Groups, UIDROPDOWNMENU_MENU_LEVEL);

        local separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator);

        local clear = {};
        clear.text = "clear"
        clear.disabled = false
        clear.isTitle = false
        clear.notCheckable = true
        clear.func = TWA.changeCell
        clear.arg1 = TWA.currentRow * 100 + TWA.currentCell
        clear.arg2 = 'clear'
        UIDropDownMenu_AddButton(clear, UIDROPDOWNMENU_MENU_LEVEL);

        local close = {};
        close.text = "Close"
        close.disabled = false
        close.notCheckable = true
        close.isTitle = false
        close.arg1 = TWA.currentCell
        close.func = TWA.closeDropdown
        UIDropDownMenu_AddButton(close, UIDROPDOWNMENU_MENU_LEVEL);
    end

    if UIDROPDOWNMENU_MENU_LEVEL == 2 then

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'marks') then

            local Title = {}
            Title.text = "Marks"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            for mark, color in next, TWA.marks do

                local dropdownItem = {}
                dropdownItem.text = color .. mark
                dropdownItem.checked = TWA.markOrPlayerUsed(mark)

                dropdownItem.icon = 'Interface\\TargetingFrame\\UI-RaidTargetingIcons'

                if mark == 'Skull' then
                    dropdownItem.tCoordLeft = 0.75
                    dropdownItem.tCoordRight = 1
                    dropdownItem.tCoordTop = 0.25
                    dropdownItem.tCoordBottom = 0.5
                end
                if mark == 'Cross' then
                    dropdownItem.tCoordLeft = 0.5
                    dropdownItem.tCoordRight = 0.75
                    dropdownItem.tCoordTop = 0.25
                    dropdownItem.tCoordBottom = 0.5
                end
                if mark == 'Square' then
                    dropdownItem.tCoordLeft = 0.25
                    dropdownItem.tCoordRight = 0.5
                    dropdownItem.tCoordTop = 0.25
                    dropdownItem.tCoordBottom = 0.5
                end
                if mark == 'Moon' then
                    dropdownItem.tCoordLeft = 0
                    dropdownItem.tCoordRight = 0.25
                    dropdownItem.tCoordTop = 0.25
                    dropdownItem.tCoordBottom = 0.5
                end
                if mark == 'Triangle' then
                    dropdownItem.tCoordLeft = 0.75
                    dropdownItem.tCoordRight = 1
                    dropdownItem.tCoordTop = 0
                    dropdownItem.tCoordBottom = 0.25
                end
                if mark == 'Diamond' then
                    dropdownItem.tCoordLeft = 0.5
                    dropdownItem.tCoordRight = 0.75
                    dropdownItem.tCoordTop = 0
                    dropdownItem.tCoordBottom = 0.25
                end
                if mark == 'Circle' then
                    dropdownItem.tCoordLeft = 0.25
                    dropdownItem.tCoordRight = 0.5
                    dropdownItem.tCoordTop = 0
                    dropdownItem.tCoordBottom = 0.25
                end
                if mark == 'Star' then
                    dropdownItem.tCoordLeft = 0
                    dropdownItem.tCoordRight = 0.25
                    dropdownItem.tCoordTop = 0
                    dropdownItem.tCoordBottom = 0.25
                end

                dropdownItem.func = TWA.changeCell
                dropdownItem.arg1 = TWA.currentRow * 100 + TWA.currentCell
                dropdownItem.arg2 = mark
                UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
                dropdownItem = nil
            end
        end

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'sides') then

            local Title = {}
            Title.text = "Sides"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            local left = {};
            left.text = TWA.sides['Left'] .. 'Left'
            left.checked = TWA.markOrPlayerUsed('Left')
            left.func = TWA.changeCell
            left.arg1 = TWA.currentRow * 100 + TWA.currentCell
            left.arg2 = 'Left'
            UIDropDownMenu_AddButton(left, UIDROPDOWNMENU_MENU_LEVEL);

            local right = {};
            right.text = TWA.sides['Right'] .. 'Right'
            right.checked = TWA.markOrPlayerUsed('Right')
            right.func = TWA.changeCell
            right.arg1 = TWA.currentRow * 100 + TWA.currentCell
            right.arg2 = 'Right'
            UIDropDownMenu_AddButton(right, UIDROPDOWNMENU_MENU_LEVEL);
        end

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'coords') then

            local Title = {}
            Title.text = "Coords"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            local n = {};
            n.text = TWA.coords['North'] .. 'North'
            n.checked = TWA.markOrPlayerUsed('North')
            n.func = TWA.changeCell
            n.arg1 = TWA.currentRow * 100 + TWA.currentCell
            n.arg2 = 'North'
            UIDropDownMenu_AddButton(n, UIDROPDOWNMENU_MENU_LEVEL);
            local s = {};
            s.text = TWA.coords['South'] .. 'South'
            s.checked = TWA.markOrPlayerUsed('South')
            s.func = TWA.changeCell
            s.arg1 = TWA.currentRow * 100 + TWA.currentCell
            s.arg2 = 'South'
            UIDropDownMenu_AddButton(s, UIDROPDOWNMENU_MENU_LEVEL);
            local e = {};
            e.text = TWA.coords['East'] .. 'East'
            e.checked = TWA.markOrPlayerUsed('East')
            e.func = TWA.changeCell
            e.arg1 = TWA.currentRow * 100 + TWA.currentCell
            e.arg2 = 'East'
            UIDropDownMenu_AddButton(e, UIDROPDOWNMENU_MENU_LEVEL);
            local w = {};
            w.text = TWA.coords['West'] .. 'West'
            w.checked = TWA.markOrPlayerUsed('West')
            w.func = TWA.changeCell
            w.arg1 = TWA.currentRow * 100 + TWA.currentCell
            w.arg2 = 'West'
            UIDropDownMenu_AddButton(w, UIDROPDOWNMENU_MENU_LEVEL);
        end

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'misc') then

            local Title = {}
            Title.text = "Misc"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            for mark, color in next, TWA.misc do
                local markings = {};
                markings.text = color .. mark
                markings.checked = TWA.markOrPlayerUsed(mark)
                markings.func = TWA.changeCell
                markings.arg1 = TWA.currentRow * 100 + TWA.currentCell
                markings.arg2 = mark
                UIDropDownMenu_AddButton(markings, UIDROPDOWNMENU_MENU_LEVEL);
            end
        end

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'groups') then

            local Title = {}
            Title.text = "Groups"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            for mark, color in pairsByKeys(TWA.groups) do
                local markings = {};
                markings.text = color .. mark
                markings.checked = TWA.markOrPlayerUsed(mark)
                markings.func = TWA.changeCell
                markings.arg1 = TWA.currentRow * 100 + TWA.currentCell
                markings.arg2 = mark
                UIDropDownMenu_AddButton(markings, UIDROPDOWNMENU_MENU_LEVEL);
            end
        end
    end
end

function buildTanksDropdown()

    if UIDROPDOWNMENU_MENU_LEVEL == 1 then

        local Title = {}
        Title.text = "Tanks"
        Title.isTitle = true
        UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

        local Warriors = {}
        Warriors.text = TWA.classColors['warrior'].c .. 'Warriors'
        Warriors.notCheckable = true
        Warriors.hasArrow = true
        Warriors.value = {
            ['key'] = 'warrior'
        }
        UIDropDownMenu_AddButton(Warriors, UIDROPDOWNMENU_MENU_LEVEL);

        local Druids = {}
        Druids.text = TWA.classColors['druid'].c .. 'Druids'
        Druids.notCheckable = true
        Druids.hasArrow = true
        Druids.value = {
            ['key'] = 'druid'
        }
        UIDropDownMenu_AddButton(Druids, UIDROPDOWNMENU_MENU_LEVEL);

        local Paladins = {}
        Paladins.text = TWA.classColors['paladin'].c .. 'Paladins'
        Paladins.notCheckable = true
        Paladins.hasArrow = true
        Paladins.value = {
            ['key'] = 'paladin'
        }
        UIDropDownMenu_AddButton(Paladins, UIDROPDOWNMENU_MENU_LEVEL);

        local separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator);

        local Warlocks = {}
        Warlocks.text = TWA.classColors['warlock'].c .. 'Warlocks'
        Warlocks.notCheckable = true
        Warlocks.hasArrow = true
        Warlocks.value = {
            ['key'] = 'warlock'
        }
        UIDropDownMenu_AddButton(Warlocks, UIDROPDOWNMENU_MENU_LEVEL);

        local Mages = {}
        Mages.text = TWA.classColors['mage'].c .. 'Mages'
        Mages.notCheckable = true
        Mages.hasArrow = true
        Mages.value = {
            ['key'] = 'mage'
        }
        UIDropDownMenu_AddButton(Mages, UIDROPDOWNMENU_MENU_LEVEL);

        local Priests = {}
        Priests.text = TWA.classColors['priest'].c .. 'Priests'
        Priests.notCheckable = true
        Priests.hasArrow = true
        Priests.value = {
            ['key'] = 'priest'
        }
        UIDropDownMenu_AddButton(Priests, UIDROPDOWNMENU_MENU_LEVEL);

        local Rogues = {}
        Rogues.text = TWA.classColors['rogue'].c .. 'Rogues'
        Rogues.notCheckable = true
        Rogues.hasArrow = true
        Rogues.value = {
            ['key'] = 'rogue'
        }
        UIDropDownMenu_AddButton(Rogues, UIDROPDOWNMENU_MENU_LEVEL);

        local Hunters = {}
        Hunters.text = TWA.classColors['hunter'].c .. 'Hunters'
        Hunters.notCheckable = true
        Hunters.hasArrow = true
        Hunters.value = {
            ['key'] = 'hunter'
        }
        UIDropDownMenu_AddButton(Hunters, UIDROPDOWNMENU_MENU_LEVEL);

        local Shamans = {}
        Shamans.text = TWA.classColors['shaman'].c .. 'Shamans'
        Shamans.notCheckable = true
        Shamans.hasArrow = true
        Shamans.value = {
            ['key'] = 'shaman'
        }
        UIDropDownMenu_AddButton(Shamans, UIDROPDOWNMENU_MENU_LEVEL);

        local separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator);

        local clear = {};
        clear.text = "clear"
        clear.disabled = false
        clear.isTitle = false
        clear.notCheckable = true
        clear.func = TWA.changeCell
        clear.arg1 = TWA.currentRow * 100 + TWA.currentCell
        clear.arg2 = 'clear'
        UIDropDownMenu_AddButton(clear, UIDROPDOWNMENU_MENU_LEVEL);

        local close = {};
        close.text = "Close"
        close.disabled = false
        close.notCheckable = true
        close.isTitle = false
        close.arg1 = TWA.currentCell
        close.func = TWA.closeDropdown
        UIDropDownMenu_AddButton(close, UIDROPDOWNMENU_MENU_LEVEL);
    end
    if UIDROPDOWNMENU_MENU_LEVEL == 2 then

        for i, tank in next, TWA.raid[UIDROPDOWNMENU_MENU_VALUE['key']] do
            local Tanks = {}

            local color = TWA.classColors[UIDROPDOWNMENU_MENU_VALUE['key']].c

            if TWA.isPlayerOffline(tank) then
                color = '|cffff0000'
            end

            Tanks.text = color .. tank
            Tanks.checked = TWA.markOrPlayerUsed(tank)
            Tanks.func = TWA.changeCell
            Tanks.arg1 = TWA.currentRow * 100 + TWA.currentCell
            Tanks.arg2 = tank
            UIDropDownMenu_AddButton(Tanks, UIDROPDOWNMENU_MENU_LEVEL);
        end
    end
end

function buildHealersDropdown()

    if UIDROPDOWNMENU_MENU_LEVEL == 1 then

        local Healers = {}
        Healers.text = "Healers"
        Healers.isTitle = true
        UIDropDownMenu_AddButton(Healers, UIDROPDOWNMENU_MENU_LEVEL);

        local Priests = {}
        Priests.text = TWA.classColors['priest'].c .. 'Priests'
        Priests.notCheckable = true
        Priests.hasArrow = true
        Priests.value = {
            ['key'] = 'priest'
        }
        UIDropDownMenu_AddButton(Priests, UIDROPDOWNMENU_MENU_LEVEL);

        local Druids = {}
        Druids.text = TWA.classColors['druid'].c .. 'Druids'
        Druids.notCheckable = true
        Druids.hasArrow = true
        Druids.value = {
            ['key'] = 'druid'
        }
        UIDropDownMenu_AddButton(Druids, UIDROPDOWNMENU_MENU_LEVEL);

        local Shamans = {}
        Shamans.text = TWA.classColors['shaman'].c .. 'Shamans'
        Shamans.notCheckable = true
        Shamans.hasArrow = true
        Shamans.value = {
            ['key'] = 'shaman'
        }
        UIDropDownMenu_AddButton(Shamans, UIDROPDOWNMENU_MENU_LEVEL);

        local Paladins = {}
        Paladins.text = TWA.classColors['paladin'].c .. 'Paladins'
        Paladins.notCheckable = true
        Paladins.hasArrow = true
        Paladins.value = {
            ['key'] = 'paladin'
        }
        UIDropDownMenu_AddButton(Paladins, UIDROPDOWNMENU_MENU_LEVEL);

        local separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator);

        local clear = {};
        clear.text = "clear"
        clear.disabled = false
        clear.isTitle = false
        clear.notCheckable = true
        clear.func = TWA.changeCell
        clear.arg1 = TWA.currentRow * 100 + TWA.currentCell
        clear.arg2 = 'clear'
        UIDropDownMenu_AddButton(clear, UIDROPDOWNMENU_MENU_LEVEL);

        local close = {};
        close.text = "Close"
        close.disabled = false
        close.notCheckable = true
        close.isTitle = false
        close.arg1 = TWA.currentCell
        close.func = TWA.closeDropdown
        UIDropDownMenu_AddButton(close, UIDROPDOWNMENU_MENU_LEVEL);
    end
    if UIDROPDOWNMENU_MENU_LEVEL == 2 then

        for i, healer in next, TWA.raid[UIDROPDOWNMENU_MENU_VALUE['key']] do
            local Healers = {}

            local color = TWA.classColors[UIDROPDOWNMENU_MENU_VALUE['key']].c

            if TWA.isPlayerOffline(healer) then
                color = '|cffff0000'
            end

            Healers.text = color .. healer
            Healers.checked = TWA.markOrPlayerUsed(healer)
            Healers.func = TWA.changeCell
            Healers.arg1 = TWA.currentRow * 100 + TWA.currentCell
            Healers.arg2 = healer
            UIDropDownMenu_AddButton(Healers, UIDROPDOWNMENU_MENU_LEVEL);
        end
    end
end

TWA.currentRow = 0
TWA.currentCell = 0

function TWCell_OnClick(id)

    TWA.currentRow = math.floor(id / 100)
    TWA.currentCell = id - TWA.currentRow * 100

    --targets
    if TWA.currentCell == 1 then
        UIDropDownMenu_Initialize(TWATargetsDropDown, buildTargetsDropdown, "MENU");
        ToggleDropDownMenu(1, nil, TWATargetsDropDown, "cursor", 2, 3);
    end

    --tanks
    if TWA.currentCell == 2 or TWA.currentCell == 3 or TWA.currentCell == 4 then
        UIDropDownMenu_Initialize(TWATanksDropDown, buildTanksDropdown, "MENU");
        ToggleDropDownMenu(1, nil, TWATanksDropDown, "cursor", 2, 3);
    end

    --healers
    if TWA.currentCell == 5 or TWA.currentCell == 6 or TWA.currentCell == 7 then
        UIDropDownMenu_Initialize(TWAHealersDropDown, buildHealersDropdown, "MENU");
        ToggleDropDownMenu(1, nil, TWAHealersDropDown, "cursor", 2, 3);
    end
end

function AddLine_OnClick()
    ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "AddLine", "RAID")
end

function TWA.AddLine()
    if table.getn(TWA.data) < 10 then
        TWA.data[table.getn(TWA.data) + 1] = { '-', '-', '-', '-', '-', '-', '-' };
        TWA.PopulateTWA()
    end
end

function SpamRaid_OnClick()


    ChatThrottleLib:SendChatMessage("BULK", "TWA", "======= RAID ASSIGNMENTS =======", "RAID")

    for index, data in next, TWA.data do

        local line = ''
        local dontPrintLine = true
        for i, name in data do
            dontPrintLine = dontPrintLine and name == '-'
            local separator = ''
            if i == 1 then separator = ' : '
            end
            if i == 4 then separator = ' || Healers: '
            end

            if name == '-' then name = ''
            end
            --            if i == 1 then
            --                name = name .. string.rep(' ', 10 - string.len(name))
            --            end
            line = line .. name .. ' ' .. separator
        end

        if not dontPrintLine then
            ChatThrottleLib:SendChatMessage("BULK", "TWA", line, "RAID")
        end
    end
    ChatThrottleLib:SendChatMessage("BULK", "TWA", "Not assigned, heal the raid. Whisper me 'heal' if you forget your assignment.", "RAID")
end

function RemRow_OnClick(id)
    ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "RemRow=" .. id, "RAID")
end

function TWA.RemRow(id, sender)

    if TWA.data[id + 1] then
        TWA.data[id] = TWA.data[id + 1]
    end

    local last

    for i in next, TWA.data do
        if i > id then
            if TWA.data[i + 1] then
                TWA.data[i] = TWA.data[i + 1]
            end
        end
        last = i
    end

    TWA.data[last] = nil

    TWA.PopulateTWA()
end

function Reset_OnClick()
    ChatThrottleLib:SendAddonMessage("ALERT", "TWA", "Reset", "RAID")
end

function TWA.Reset()
    for index, data in next, TWA.data do
        if TWA.rows[index] then TWA.rows[index]:Hide() end
        if TWA.data[index] then TWA.data[index] = nil end
    end
    TWA.data = {
        [1] = { '-', '-', '-', '-', '-', '-', '-' },
    }
    TWA.PopulateTWA()
end

function CloseTWA_OnClick()
    getglobal('TWA_Main'):Hide()
end

function toggle_TWA_Main()
    if (getglobal('TWA_Main'):IsVisible()) then
        getglobal('TWA_Main'):Hide()
    else
        getglobal('TWA_Main'):Show()
    end
end

function buildTemplatesDropdown()
    if UIDROPDOWNMENU_MENU_LEVEL == 1 then

        local Title = {}
        Title.text = "Templates"
        Title.isTitle = true
        UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

        local Raids = {}
        Raids.text = "Molten Core"
        Raids.notCheckable = true
        Raids.hasArrow = true
        Raids.value = {
            ['key'] = 'mc'
        }
        UIDropDownMenu_AddButton(Raids, UIDROPDOWNMENU_MENU_LEVEL);

        local Raids = {}
        Raids.text = "Blackwing Lair"
        Raids.notCheckable = true
        Raids.hasArrow = true
        Raids.value = {
            ['key'] = 'bwl'
        }
        UIDropDownMenu_AddButton(Raids, UIDROPDOWNMENU_MENU_LEVEL);
    end

    if UIDROPDOWNMENU_MENU_LEVEL == 2 then

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'mc') then

            local dropdownItem = {}
            dropdownItem.text = "Gaar"
            dropdownItem.func = TWA.loadTemplate
            dropdownItem.arg1 = 'gaar'
            dropdownItem.arg2 = false
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            local dropdownItem = {}
            dropdownItem.text = "Majordomo"
            dropdownItem.func = TWA.loadTemplate
            dropdownItem.arg1 = 'domo'
            dropdownItem.arg2 = false
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            local dropdownItem = {}
            dropdownItem.text = "Ragnaros"
            dropdownItem.func = TWA.loadTemplate
            dropdownItem.arg1 = 'rag'
            dropdownItem.arg2 = false
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil
        end

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'bwl') then

            local dropdownItem = {}
            dropdownItem.text = "Razorgore"
            dropdownItem.func = TWA.loadTemplate
            dropdownItem.arg1 = 'razorgore'
            dropdownItem.arg2 = false
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            local dropdownItem = {}
            dropdownItem.text = "Vaelastrasz"
            dropdownItem.func = TWA.loadTemplate
            dropdownItem.arg1 = 'vael'
            dropdownItem.arg2 = false
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            local dropdownItem = {}
            dropdownItem.text = "Lashlayer"
            dropdownItem.func = TWA.loadTemplate
            dropdownItem.arg1 = 'lashlayer'
            dropdownItem.arg2 = false
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            local dropdownItem = {}
            dropdownItem.text = "Chromaggus"
            dropdownItem.func = TWA.loadTemplate
            dropdownItem.arg1 = 'chromaggus'
            dropdownItem.arg2 = false
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            local dropdownItem = {}
            dropdownItem.text = "Nefarian"
            dropdownItem.func = TWA.loadTemplate
            dropdownItem.arg1 = 'nef'
            dropdownItem.arg2 = false
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil
        end
    end
end

function Templates_OnClick()
    UIDropDownMenu_Initialize(TWATemplates, buildTemplatesDropdown, "MENU");
    ToggleDropDownMenu(1, nil, TWATemplates, "cursor", 2, 3);
end

function string:split(delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(self, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert(result, string.sub(self, from))
    return result
end

function pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n)
    end
    table.sort(a, function(a, b) return a < b
    end)
    local i = 0 -- iterator variable
    local iter = function() -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end