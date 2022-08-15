ESX = nil
Citizen.CreateThread(function() while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end end)

itemList = {}
EtatModifItem = false 
itemCreate = {
    nom = "~r~A Saisir",
    label = "~r~A Saisir",
    poids = "~r~A Saisir",
    rare = "0",
    canremove = "1",
}

ItemModif = {
    name = "N/A",
    label = "N/A",
    oldPoids = "N/A",
    newsPoids = "~r~A Saisir",
}

--- Création du Menu
function LoadMenuItemBuilder()
    local menuPrincipal = RageUI.CreateMenu("~u~Item Builder", "Options", 10, 40, 'banner', 'sk_banner')
    local menuCreateItem = RageUI.CreateSubMenu(menuPrincipal, "~u~Créer un Item", nil)
    local menuListeItem = RageUI.CreateSubMenu(menuPrincipal, "~u~Liste des Items", nil)
    local menuItemModif = RageUI.CreateSubMenu(menuListeItem, "~u~Modification Items", nil)

    RageUI.Visible(menuPrincipal, not RageUI.Visible(menuPrincipal))
    while menuPrincipal do
        Citizen.Wait(0)

        --- Main Menu ---
        RageUI.IsVisible(menuPrincipal,true,true,true,function()
            RageUI.ButtonWithStyle("~r~→~s~ Créer un Item", nil, {RightLabel = "→→→"}, true, function(h, a, s) end, menuCreateItem)
            RageUI.ButtonWithStyle("~r~→~s~ Liste des Items", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                if s then ESX.TriggerServerCallback('sk_itembuilder:GetAllItems', function(itemsrv) itemList = itemsrv end) end 
            end, menuListeItem)
        end, function() end, 1)
        ----------------------

        --- Sub Menu ---
        RageUI.IsVisible(menuCreateItem,true,true,true,function()
            RageUI.ButtonWithStyle("~g~→~s~ Nom de l'item :", nil, {RightLabel = itemCreate.nom}, true, function(h, a, s)
                if s then
                    itemCreate.nom = KeyboardInput("Veuillez saisir le nom de l'item", "", 12)
                    if itemCreate.nom == "" then itemCreate.nom = "~r~A Saisir"
                    else 
                        ESX.TriggerServerCallback('sk_itembuilder:CheckNameItem', function(etat)
                            if etat == "true" then 
                                itemCreate.nom = "~r~A Saisir"
                                if Config.okokNotif then exports['okokNotify']:Alert("Item Builder", "Un item possède déjà ce nom", 5000, 'error')
                                else ESX.ShowNotification("~r~Un item possède déjà ce nom") end 
                            end
                        end, itemCreate.nom)
                    end
                end
            end)
            RageUI.ButtonWithStyle("~g~→~s~ Label de l'item :", nil, {RightLabel = itemCreate.label}, true, function(h, a, s)
                if s then
                    itemCreate.label = KeyboardInput("Veuillez saisir le label de l'item", "", 30)
                    if itemCreate.label == "" then itemCreate.label = "~r~A Saisir"
                    else
                        ESX.TriggerServerCallback('sk_itembuilder:CheckLabelItem', function(etat)
                            if etat == "true" then 
                                itemCreate.label = "~r~A Saisir"
                                if Config.okokNotif then exports['okokNotify']:Alert("Item Builder", "Un item possède déjà ce label", 5000, 'error')
                                else ESX.ShowNotification("~r~Un item possède déjà ce label") end 
                            end
                        end, itemCreate.label)
                    end
                end
            end)
            RageUI.ButtonWithStyle("~g~→~s~ Poids de l'item :", nil, {RightLabel = itemCreate.poids}, true, function(h, a, s)
                if s then 
                    itemCreate.poids = KeyboardInput("Veuillez saisir le poids de l'item", "", 3)
                    if itemCreate.poids ~= "" and tonumber(itemCreate.poids) then
                    else 
                        itemCreate.poids = "~r~A Saisir"
                        if Config.okokNotif then exports['okokNotify']:Alert("Item Builder", "Le poids n'est pas valide", 5000, 'error')
                        else ESX.ShowNotification("~r~Le poids n'est pas valide") end 
                    end
                end
            end)
            RageUI.Line(113,203,113,255)
            local AllCheck = itemCreate.com ~= "~r~A Saisir" and itemCreate.label ~= "~r~A Saisir" and itemCreate.poids ~= "~r~A Saisir" 
            RageUI.ButtonWithStyle("~g~→ Valider ", nil, {RightLabel = "→→→"}, AllCheck, function(h, a, s)
                if s then 
                    TriggerServerEvent("sk_itembuilder:AddItem", itemCreate)
                    if Config.okokNotif then exports['okokNotify']:Alert("Item Builder", "L'item a bien été ajouté", 5000, 'success')
                    else ESX.ShowNotification("L'item a bien été ~g~ajouté") end 
                    itemCreate.nom,itemCreate.label,itemCreate.poids,itemCreate.rare,itemCreate.canremove="~r~A Saisir","~r~A Saisir","~r~A Saisir","0","1"
                    RageUI.CloseAll()
                end
            end)
        end, function() end)

        RageUI.IsVisible(menuListeItem,true,true,true,function()
            for k,v in pairs(itemList) do
                RageUI.ButtonWithStyle("~b~→~s~ "..v.label.." [~b~"..v.name.."~s~]", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                    if s then 
                        ItemModif.name = v.name
                        ItemModif.label = v.label
                        ItemModif.oldPoids = v.poids
                    end
                end, menuItemModif)
            end
        end, function() end)
        -----------------

        --- Sub Menu 2 ---
        RageUI.IsVisible(menuItemModif,true,true,true,function()
            RageUI.Info("~o~Information Item", {"Name →", "Label →", "Poids  →", ""}, {ItemModif.name, ItemModif.label, ItemModif.oldPoids, ""})
            RageUI.Checkbox("~o~→~s~ Modifier l'Item",nil, EtatModifItem,{},function(h,a,s,c) if s then EtatModifItem = c if not c  then ItemModif.newsPoids = "~r~A Saisir" end end end)
            if EtatModifItem then 
                RageUI.ButtonWithStyle("~o~→~s~ Modifier le poids", nil, {RightLabel = ItemModif.newsPoids}, true, function(h, a, s)
                    if s then
                        ItemModif.newsPoids = KeyboardInput("Veuillez saisir le nouveau poids de l'item", "", 12)
                        if tonumber(ItemModif.oldPoids) ~= tonumber(ItemModif.newsPoids) then
                            if ItemModif.newsPoids ~= "" and tonumber(ItemModif.newsPoids) then else 
                                ItemModif.newsPoids = "~r~A Saisir"
                                if Config.okokNotif then exports['okokNotify']:Alert("Item Builder", "Le poids n'est pas valide", 5000, 'error')
                                else ESX.ShowNotification("~r~Le poids n'est pas valide") end 
                            end
                        else 
                            ItemModif.newsPoids = "~r~A Saisir"
                            if Config.okokNotif then exports['okokNotify']:Alert("Item Builder", "Le poids est identique a celui actuel", 5000, 'error')
                            else ESX.ShowNotification("~r~Le poids est identique a celui actuel") end 
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~g~→ Valider", nil, {RightLabel = "→→→"}, ItemModif.newsPoids ~= "~r~A Saisir" , function(h, a, s)
                    if s then
                        TriggerServerEvent('sk_itembuilder:MajItem', ItemModif)
                        if Config.okokNotif then exports['okokNotify']:Alert("Item Builder", "L'item a été mis a jour", 5000, 'success')
                        else ESX.ShowNotification("L'item a été ~o~mis a jour") end 
                        ItemModif.newsPoids,ItemModif.name,ItemModif.label,ItemModif.oldPoids,EtatModifItem="~r~A Saisir","N/A","N/A","N/A",false
                        RageUI.CloseAll()
                    end
                end)
            else 
                RageUI.ButtonWithStyle("~r~→ Supprimer l'Item", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                    if s then 
                        ESX.TriggerServerCallback('sk_itembuilder:CheckNameItem', function(etat)
                            if etat == "true" then 
                                TriggerServerEvent('sk_itembuilder:DeleteItem', ItemModif.name)
                                if Config.okokNotif then exports['okokNotify']:Alert("Item Builder", "L'item a été supprimé", 5000, 'success')
                                else ESX.ShowNotification("L'item a été ~r~supprimé") end 
                                ItemModif.newsPoids,ItemModif.name,ItemModif.label,ItemModif.oldPoids="~r~A Saisir","N/A","N/A","N/A"
                                RageUI.CloseAll()
                            else 
                                if Config.okokNotif then exports['okokNotify']:Alert("Item Builder", "Cette item n'existe pas/plus", 5000, 'error')
                                else ESX.ShowNotification("~r~Cette item n'existe pas/plus") end 
                                RageUI.GoBack()
                            end
                        end, ItemModif.name)
                    end
                end)
            end
        end, function() end)
        -------------------

        --- Ne pas Toucher ---
        if not RageUI.Visible(menuPrincipal) and not RageUI.Visible(menuCreateItem) and not RageUI.Visible(menuListeItem) and not RageUI.Visible(menuItemModif) then
            menuPrincipal=RMenu:DeleteType("~u~Item Builder", true)
        end
        ----------------------
    end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Citizen.Wait(0) end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

--- Ouvrir le menu avec une Commande
if Config.Command.etat then 
    RegisterCommand(Config.Command.name, function()
        ESX.TriggerServerCallback('sk_itembuilder:GetUserGroup', function(group)
            for k, v in pairs(Config.Group) do
                if group == v then LoadMenuItemBuilder() end
            end
        end)
    end)
end

--- Ouvrir le menu avec une Touche
if Config.Key.etat then 
    Keys.Register(Config.Key.key, Config.Key.key, 'Menu Item Builder', function()
        print("Pesse Key - "..Config.Key.key)
        ESX.TriggerServerCallback('sk_itembuilder:GetUserGroup', function(group)
            for k, v in pairs(Config.Group) do
                if group == v then LoadMenuItemBuilder() end
            end
        end)
    end)
end
