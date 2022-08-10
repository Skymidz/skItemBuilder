local function isWebhookSet(val)  return val ~= nil and val ~= "" end

local webhookColors = {
    ["green"] = 56108,
    ["orange"] = 16744192,
    ["red"] = 16711680,
}

local date = os.date('*t')
if date.day < 10 then date.day = ''..tostring(date.day) end
if date.month < 10 then date.month = ''..tostring(date.month) end
if date.hour < 10 then date.hour = ''..tostring(date.hour) end
if date.min < 10 then date.min = ''..tostring(date.min) end
if date.sec < 10 then date.sec = ''..tostring(date.sec) end

function sendWebhook(titre,description,color,url)
    local DiscordWebHook = url
    local embeds = {
        {
            ["title"] = titre,
			["description"] = description,
            ["type"] = "rich",
            ["color"] = webhookColors[color],
            ["footer"] =  { ["text"]= "Developed by Skymidz#7333 | "..os.date("%Y").." • "..os.date("%x %X %p") },
        }
    }
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "sk_log",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end