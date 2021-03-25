-- =============================================================================
--  bDance
--    by: BurstBiscuit
-- =============================================================================

require "math"
require "table"
require "unicode"

require "lib/lib_Callback2"
require "lib/lib_ChatLib"
require "lib/lib_Debug"
require "lib/lib_Slash"

Debug.EnableLogging(false)


-- =============================================================================
--  Functions
-- =============================================================================

local g_Enabled = false
local g_Max = 1


-- =============================================================================
--  Functions
-- =============================================================================

function Notification(message)
    ChatLib.Notification({text = "[PoC] " .. tostring(message)})
end

function PoC()
    if (g_Enabled) then
        if (tonumber(Player.GetEliteLevelsInfo_XpAndLevel().current_level) < g_Max) then
            ActivityDirector.RequestMission(878) -- Dance infront of 5
            Callback2.FireAndForget(ActivityDirector.RequestMission, 970, 3) -- Gather 100 Cryst
            Callback2.FireAndForget(ActivityDirector.RequestMission, 959, 6) -- Gather 500 Cryst
            Callback2.FireAndForget(ActivityDirector.RequestMission, 949, 9) -- Gather 100 Cryst
            -- Callback2.FireAndForget(ActivityDirector.RequestMission, 948, 12) -- Dance infront of 8
            Callback2.FireAndForget(Game.SlashCommand, "dance", 12)
            Callback2.FireAndForget(PoC, nil, 15)
        else
            g_Enabled = false
            Notification("Desired elite rank reached, cancelling callback.")
            Game.SlashCommand("cheer")
        end
    end
end

function OnSlashCommand(args)
    if (args[1]) then
        g_Enabled = true
        g_Max = tonumber(unicode.match(args[1], "%d+") or 1)
        Notification("Leveling up to elite rank " .. tostring(g_Max))
    elseif (g_Enabled) then
        g_Enabled = false
        Notification("Disabling callback.")
    else
        g_Enabled = false
        Notification("You must enter a maximum elite rank. For example: /bdance 250")
        return
    end

    PoC()
end


-- =============================================================================
--  Events
-- =============================================================================

function OnComponentLoad()
    LIB_SLASH.BindCallback({
        slash_list = "xp_poc",
        description = "XP Exploit: Proof of Concept",
        func = OnSlashCommand
    })
end
