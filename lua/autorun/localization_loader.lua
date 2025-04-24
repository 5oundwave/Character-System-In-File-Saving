if CLIENT then
    local selectedLang = GetConVar("gmod_language"):GetString() or "en"
    local langPath = "autorun/localization_" .. selectedLang .. ".lua"

    local LANG = include(langPath)

    if not LANG then
        LANG = include("autorun/localization_en.lua")
    end

    return LANG
end