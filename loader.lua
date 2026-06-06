local HttpService = game:GetService("HttpService")

local SUPABASE_URL = "https://ncgvxzbpmzhskfdqnufs.supabase.co"
local SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5jZ3Z4emJwbXpoc2tmZHFudWZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA3MDc1MTcsImV4cCI6MjA5NjI4MzUxN30.EwwzR0cO_HTT-QJ6sXXgXyl0C_ZDEK9ECiW0zvRCUoo"

local placeId = game.PlaceId

local response = request({
    Url = string.format(
        "%s/rest/v1/scripts?game_id=eq.%s&select=content",
        SUPABASE_URL,
        tostring(placeId)
    ),
    Method = "GET",
    Headers = {
        ["apikey"] = SUPABASE_ANON_KEY,
        ["Authorization"] = "Bearer " .. SUPABASE_ANON_KEY,
        ["Content-Type"] = "application/json"
    }
})

if not response or not response.Success then
    warn("Failed to contact Supabase.")
    return
end

local ok, data = pcall(function()
    return HttpService:JSONDecode(response.Body)
end)

if not ok or not data or not data[1] then
    warn("No script found for PlaceId:", placeId)
    return
end

local source = data[1].content

local chunk, err = loadstring(source)

if not chunk then
    warn("Loadstring error:", err)
    return
end

local success, runtimeError = pcall(chunk)

if not success then
    warn("Runtime error:", runtimeError)
end
