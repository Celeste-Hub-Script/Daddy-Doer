local HttpService = game:GetService("HttpService")

local SUPABASE_URL = "https://ncgvxzbpmzhskfdqnufs.supabase.co"
local SUPABASE_ANON_KEY = "YOUR_ANON_KEY"

local Key = getgenv().Key

if not Key then
    warn("No key provided.")
    return
end

local placeId = tostring(game.PlaceId)

local response = request({
    Url = string.format(
        "%s/rest/v1/scripts?game_id=eq.%s&key=eq.%s&select=content",
        SUPABASE_URL,
        placeId,
        HttpService:UrlEncode(Key)
    ),
    Method = "GET",
    Headers = {
        ["apikey"] = SUPABASE_ANON_KEY,
        ["Authorization"] = "Bearer " .. SUPABASE_ANON_KEY,
        ["Content-Type"] = "application/json"
    }
})

if not response then
    warn("No response from Supabase.")
    return
end

if response.StatusCode ~= 200 then
    warn("Supabase returned:", response.StatusCode)
    return
end

local success, data = pcall(function()
    return HttpService:JSONDecode(response.Body)
end)

if not success then
    warn("Failed to decode response.")
    return
end

if not data[1] then
    warn("Invalid key or unsupported game.")
    return
end

local source = data[1].content

if type(source) ~= "string" or source == "" then
    warn("Script content is empty.")
    return
end

local chunk, err = loadstring(source)

if not chunk then
    warn("Compilation error:", err)
    return
end

local ok, runtimeErr = pcall(chunk)

if not ok then
    warn("Runtime error:", runtimeErr)
end
