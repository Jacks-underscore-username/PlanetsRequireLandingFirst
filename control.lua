script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.get_player(event.player_index)
    if (player == nil or player.character == nil) then return end
    local surface = player.character.surface.name
    local tech_name = "visit-" .. surface
    if (player.force.technologies[tech_name] ~= nil) then
        player.force.script_trigger_research(tech_name)
    end
end)
