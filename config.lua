Config = {}

Config.okokNotif = false --true or false : Si tu as okokNotify sur ton serveur

Config.Log = {
    etatItem = false,    --true or false : Si tu veux les logs des ajouts, modifications et suppressions
    webhookItem = "",  --lien
}

Config.Group = {
    "superadmin",
    "owner",
    "_dev",
} --Les groupes qui auront accès au menu

Config.Command = {
    etat = true,            --true or false : Si tu veux ouvrir le menu avec une commande
    name = "itembuilder",   --La commande pour ouvrir le menu
}

Config.Key = {
    etat = false,   --true or false : Si tu veux ouvrir le menu avec une touche
    key = "F1",     --La touche pour ouvrir le menu
}
