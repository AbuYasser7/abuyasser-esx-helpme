ESX = exports["es_extended"]:getSharedObject()

-- RTL helpers
local RLM = "\u{200F}"  -- Right-to-Left Mark
local LRM = "\u{200E}"  -- Left-to-Right Mark


---------------------------------------------------------------------
-- التحقق من صلاحيات استخدام الأمر
---------------------------------------------------------------------
local function Allowed(xPlayer, command)
    local cfg = Config.Commands[command]
    if not cfg then return false end

    local group = xPlayer.getGroup() or "user"

    for _, allowed in ipairs(cfg.groups) do
        if group == allowed then
            return true
        end
        -- superadmin يعتبر admin
        if allowed == "admin" and group == "superadmin" then
            return true
        end
    end
    return false
end


---------------------------------------------------------------------
-- جلب جميع معرفات اللاعب (Steam, Discord, License…)
---------------------------------------------------------------------
local function GetAllIdentifiers(src)
    local ids = {
        license  = "N/A",
        license2 = "N/A",
        steam    = "N/A",
        discord  = "N/A",
        xbl      = "N/A",
        live     = "N/A",
        fivem    = "N/A"
    }

    for _, id in pairs(GetPlayerIdentifiers(src)) do
        if id:find("license:") then
            ids.license = id:gsub("license:", "")
        elseif id:find("license2:") then
            ids.license2 = id:gsub("license2:", "")
        elseif id:find("steam:") then
            ids.steam = id:gsub("steam:", "")
        elseif id:find("discord:") then
            ids.discord = id:gsub("discord:", "")
        elseif id:find("xbl:") then
            ids.xbl = id:gsub("xbl:", "")
        elseif id:find("live:") then
            ids.live = id:gsub("live:", "")
        elseif id:find("fivem:") then
            ids.fivem = id:gsub("fivem:", "")
        end
    end

    return ids
end


---------------------------------------------------------------------
-- جلب بيانات الوظيفة من جداول: jobs + job_grades
---------------------------------------------------------------------
local function GetJobInfo(jobName, grade)
    local row = exports.oxmysql:single_async([[
        SELECT 
            j.name      AS job_name,
            j.label     AS job_label,
            g.grade     AS grade,
            g.label     AS grade_label
        FROM jobs j
        LEFT JOIN job_grades g
            ON g.job_name = j.name
        WHERE j.name = ? AND g.grade = ?
        LIMIT 1
    ]], { jobName, grade })

    if row then
        return {
            job_name    = row.job_name or jobName,
            job_label   = row.job_label or jobName,
            grade       = row.grade or grade,
            grade_label = row.grade_label or tostring(grade)
        }
    end

    return {
        job_name    = jobName,
        job_label   = jobName,
        grade       = grade,
        grade_label = tostring(grade)
    }
end


---------------------------------------------------------------------
-- إرسال Webhook
---------------------------------------------------------------------
local function SendWebhook(url, content, embed)
    PerformHttpRequest(url, function() end, "POST", json.encode({
        username = Config.WebhookUsername or "سجل الأوامر",
        content  = content,
        embeds   = { embed }
    }), { ["Content-Type"] = "application/json" })
end



---------------------------------------------------------------------
-- الحدث الرئيسي: لاعب استخدم أمر
---------------------------------------------------------------------
RegisterNetEvent("azm:commandUsed", function(commandName, reason, coords)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local cfg = Config.Commands[commandName]
    if not cfg then return end

    -- صلاحيات
    if not Allowed(xPlayer, commandName) then
        TriggerClientEvent('esx:showNotification', src, "❌ ما عندك صلاحية لهذا الأمر.")
        return
    end

    -- جلب البيانات
    local ids = GetAllIdentifiers(src)
    local firstname  = xPlayer.get("firstName") or "غير مسجل"
    local lastname   = xPlayer.get("lastName") or "غير مسجل"
    local group      = xPlayer.getGroup() or "user"
    local identifier = xPlayer.identifier

    -- جلب بيانات الوظيفة
    local jobData = xPlayer.getJob()
    local jobInfo = GetJobInfo(jobData.name, jobData.grade)

    -- جلب code من users
    local code = "N/A"
    local result = exports.oxmysql:single_async(
        'SELECT code FROM users WHERE identifier = ?',
        { identifier }
    )
    if result and result.code then
        code = result.code
    end

    local cleanReason = (reason and reason ~= "") and reason or "بدون سبب"

    -- منشن Discord ID
    local discordMention = (ids.discord ~= "N/A") and ("<@" .. ids.discord .. ">") or "N/A"

    -- الإحداثيات بشكل جميل
    local coordsText = ("```ini\n%sX: %.2f\n%sY: %.2f\n%sZ: %.2f\n```"):format(
        LRM, coords.x, LRM, coords.y, LRM, coords.z
    )

    -- identifiers block
    local idsBlock = ("```yaml\nsteam: %s\ndiscord: %s\nlicense: %s\nlicense2: %s\nfivem: %s\nxbl: %s\nlive: %s\n```")
        :format(ids.steam, ids.discord, ids.license, ids.license2, ids.fivem, ids.xbl, ids.live)

    -----------------------------------------------------------------
    -- الـ EMBED (Outstanding)
    -----------------------------------------------------------------
    local embed = {
        title = ("🚨 %sتم استخدام أمر: /%s"):format(RLM, commandName),
        description = RLM ..
            "**تنبيه**\n" ..
            "لاعب استخدم أمر داخل السيرفر وتم تسجيل البيانات.\n\n" ..
            ("**الأمر:** `%s/%s%s`"):format(LRM, commandName, RLM),
        color = cfg.color or Config.DefaultColor or 16711680,

        fields = {

            -- بيانات اللاعب
            {
                name  = RLM .. "👤 بيانات اللاعب",
                value =
                    ("**%sرقم اللاعب:** %s%d%s\n"):format(RLM, LRM, src, RLM) ..
                    ("**%sالرتبة:** %s%s%s\n"):format(RLM, LRM, group, RLM) ..
                    ("**%sالكود:** %s%s%s\n"):format(RLM, LRM, code, RLM) ..
                    ("**%sالاسم:** %s%s %s%s"):format(RLM, LRM, firstname, lastname, RLM),
                inline = false
            },

            -- الوظيفة
            {
                name  = RLM .. "💼 الوظيفة",
                value =
                    ("**%sاسم الوظيفة:** %s%s%s\n"):format(RLM, LRM, jobInfo.job_name, RLM) ..
                    ("**%sالليبل:** %s%s%s\n"):format(RLM, LRM, jobInfo.job_label, RLM) ..
                    ("**%sالدرجة:** %s%s%s\n"):format(RLM, LRM, tostring(jobInfo.grade), RLM) ..
                    ("**%sاسم الدرجة:** %s%s%s"):format(RLM, LRM, jobInfo.grade_label, RLM),
                inline = false
            },

            -- السبب
            {
                name  = RLM .. "📝 السبب",
                value = RLM .. cleanReason,
                inline = false
            },

            -- الإحداثيات
            {
                name  = RLM .. "📍 الإحداثيات",
                value = coordsText,
                inline = false
            },

            -- Discord / Steam
            {
                name = RLM .. "💬 Discord / 🎮 Steam",
                value =
                    ("**%sDiscord:** %s%s%s  (%s%s%s)\n"):format(
                        RLM, LRM, discordMention, RLM, LRM, ids.discord, RLM
                    ) ..
                    ("**%sSteam:** %s%s%s"):format(RLM, LRM, ids.steam, RLM),
                inline = false
            },

            -- identifiers block
            {
                name  = RLM .. "🔐 Identifiers",
                value = idsBlock,
                inline = false
            }
        },

        footer = {
            text = RLM .. "سجل الأوامر • " .. os.date("%Y-%m-%d %H:%M:%S")
        }
    }

    -- إرسال المنشن
    local mention = (Config.GlobalMention or "@everyone")
    local content = mention .. " 🚨 في لاعب استخدم الأمر: **/" .. commandName .. "**"

    -- إرسال
    SendWebhook(cfg.webhook, content, embed)
end)
