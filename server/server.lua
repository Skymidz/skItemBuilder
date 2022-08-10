local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--- Avoir le rang du joueur
ESX.RegisterServerCallback("sk_itembuilder:GetUserGroup", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	cb(group)
end)

--- Vérifiez si le nom de l'item est dans la db
ESX.RegisterServerCallback("sk_itembuilder:CheckNameItem", function(source, cb, itemName)
    local CheckItemNameInDB = "false"
    MySQL.Async.fetchAll('SELECT * FROM items WHERE name like @name', { ['@name'] = itemName }, function(data)
        if data[1] then CheckItemNameInDB = "true" end 
        cb(CheckItemNameInDB)
	end)
end)

--- Vérifiez si le label de l'item est dans la db
ESX.RegisterServerCallback("sk_itembuilder:CheckLabelItem", function(source, cb, itemLabel)
	local CheckItemLabelInDB = "false"
    MySQL.Async.fetchAll('SELECT * FROM items WHERE label like @label', { ['@label'] = itemLabel }, function(data)
        if data[1] then CheckItemLabelInDB = "true" end 
        cb(CheckItemLabelInDB)
	end)
end)

--- Avoir la liste des items
ESX.RegisterServerCallback('sk_itembuilder:GetAllItems', function(_src, cb)
    AllItems = {}
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(data)
        for _, v in pairs(data) do table.insert(AllItems, { name = v.name, label = v.label, poids = v.weight }) end
        cb(AllItems)
    end)
end)

--- Permet d'ajouter un item
RegisterNetEvent("sk_itembuilder:AddItem")
AddEventHandler("sk_itembuilder:AddItem", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(Config.Group) do
        if xPlayer.getGroup() == v then 
            MySQL.Async.execute("INSERT INTO items (name, label, weight, rare, can_remove) VALUES (@name, @label, @weight, @rare, @canremove)", {
                ['@name'] = item.nom,
                ['@label'] = item.label,
                ['@weight'] = tonumber(item.poids),
                ['@rare'] = tonumber(item.rare),
                ['@canremove'] = tonumber(item.canremove),
            })
            if Config.Log.etatItem and Config.Log.webhookItem ~= "" then 
                local desc = "__Item Ajouté :__\n- Name : "..item.nom.."\n- Label : "..item.label.."\n- Poids : "..tonumber(item.poids).."\n__Ajouté par :__\n- "..GetPlayerName(source).." ["..source.."]"
                sendWebhook("__Item Ajouté__",desc,"green",Config.Log.webhookItem)
            end 
        end 
    end
end)

--- Permet de modifier un item
RegisterServerEvent('sk_itembuilder:MajItem')
AddEventHandler('sk_itembuilder:MajItem', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(Config.Group) do
        if xPlayer.getGroup() == v then 
            MySQL.Async.execute("UPDATE items SET weight = @poids WHERE name = @name", {
                ["@poids"] = tonumber(item.newsPoids),
                ["@name"] = item.name,
            })
            if Config.Log.etatItem and Config.Log.webhookItem ~= "" then 
                local desc = "__Item Modifié :__\n- Name : "..item.name.."\n- Poids : "..item.oldPoids.." ➔ "..item.newsPoids.."\n__Modifié par :__\n- "..GetPlayerName(source).." ["..source.."]"
                sendWebhook("__Item Modifié__",desc,"orange",Config.Log.webhookItem)
            end 
        end 
    end
end)

--- Permet de delete un item
RegisterServerEvent('sk_itembuilder:DeleteItem')
AddEventHandler('sk_itembuilder:DeleteItem', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(Config.Group) do
        if xPlayer.getGroup() == v then 
            MySQL.Async.execute("DELETE FROM items WHERE name = @name", { ["@name"] = item })
            if Config.Log.etatItem and Config.Log.webhookItem ~= "" then 
                local desc = "__Item Supprimé :__\n- Name : "..item.."\n__Supprimé par :__\n- "..GetPlayerName(source).." ["..source.."]"
                sendWebhook("__Item Supprimé__",desc,"red",Config.Log.webhookItem)
            end 
        end 
    end
end)