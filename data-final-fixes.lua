for _, tech in pairs(data.raw["technology"]) do
    ---@type data.SpaceLocationPrototype
    local planet = nil
    local planet_count = 0
    if (tech.effects ~= nil) then
        for _, effect in pairs(tech.effects) do
            if (effect.space_location ~= nil) then
                for _, location in pairs(data.raw["planet"]) do
                    if (location.name == effect.space_location) then
                        planet = location
                        planet_count = planet_count + 1
                    end
                end
            end
        end
    end
    if (planet ~= nil and planet_count == 1) then
        local tech_name = "visit-" .. planet.name
        local has_children = false
        for _, sub_tech in pairs(data.raw["technology"]) do
            if (sub_tech.research_trigger ~= nil and sub_tech.prerequisites ~= nil) then
                for index, parent_name in pairs(sub_tech.prerequisites) do
                    if (parent_name == tech.name) then
                        has_children = true
                        sub_tech.prerequisites[index] = tech_name
                    end
                end
            end
        end
        if (not has_children) then break end
        local localised_name = { "technology-description.visit-planet", { "space-location-name." .. planet.name } }
        data:extend({
            {
                research_trigger = {
                    type = "scripted",
                    trigger_description = localised_name,
                    icon = "__core__/graphics/icons/entity/character.png"

                },
                type = tech.type,
                name = tech_name,
                localised_name = localised_name,
                prerequisites = { tech.name },
                icons = {
                    {
                        icon = planet.icon,
                        scale = planet.icon_size
                    },
                    {
                        icon = "__core__/graphics/icons/entity/character.png",
                        scale = 1.5,
                        shift = { 32, 32 }
                    }
                }
            }
        })
    end
end
