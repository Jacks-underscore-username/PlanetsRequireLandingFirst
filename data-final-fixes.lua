for _, tech in pairs(data.raw["technology"]) do
    ---@type data.SpaceLocationPrototype
    local planet = nil
    if (tech.effects ~= nil) then
        for _, effect in pairs(tech.effects) do
            if (effect.space_location ~= nil) then
                for _, location in pairs(data.raw["planet"]) do
                    if (location.name == effect.space_location) then
                        planet = location
                        break
                    end
                end

                if (planet ~= nil) then
                    break
                end
            end
        end
    end
    if (planet ~= nil) then
        local tech_name = "visit-" .. planet.name
        for _, sub_tech in pairs(data.raw["technology"]) do
            if (sub_tech.research_trigger ~= nil and sub_tech.prerequisites ~= nil) then
                for index, parent_name in pairs(sub_tech.prerequisites) do
                    if (parent_name == tech.name) then
                        sub_tech.prerequisites[index] = tech_name
                    end
                end
            end
        end
        data:extend({
            {
                research_trigger = {
                    type = "scripted",
                    trigger_description = "Visit " .. planet.name,
                    icon = "__core__/graphics/icons/entity/character.png"

                },
                type = tech.type,
                name = tech_name,
                localised_name = "Visit " .. planet.name,
                prerequisites = { tech.name },
                icons = {
                    { icon = planet.icon },
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
