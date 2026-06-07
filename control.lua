---@type table<string, string[]>
local planet_map = prototypes.mod_data["planets-require-landing-first-mod-data"].data

script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.get_player(event.player_index)
    if (player == nil or player.character == nil) then return end
    local surface = player.character.surface.name
    log("Player surface: " .. surface)
    for tech_name, planets in pairs(planet_map) do
        log("tech_name: " .. tech_name)
        for _, planet in pairs(planets) do
            log(" * planet: " .. planet)
            if (surface == planet) then
                player.force.script_trigger_research(tech_name)
            end
        end
    end
end)


function initializeTech()
    for _, tech in pairs(game.forces["player"].technologies) do
        local passed = false
        for trigger, _ in pairs(planet_map) do
            if (trigger == tech.name) then
                passed = true
                break
            end
        end

        if (passed) then
            passed = false
            for _, child in pairs(tech.successors) do
                if (child.researched) then
                    passed = true
                    break
                end
            end
        end

        if (passed) then
            log("Children of " .. tech.name .. " are researched, so it will be too")
            tech.researched = true
        end
    end
end

script.on_load(initializeTech)
script.on_init(initializeTech)
