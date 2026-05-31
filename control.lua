script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.get_player(event.player_index)
    local surface = player.surface.name
    player.force.script_trigger_research("visit-" .. surface)
end)
