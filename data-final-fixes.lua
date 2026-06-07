---@type table<string, string[]>
local planet_map = {}
for _, tech in pairs(data.raw["technology"]) do
    ---@type data.SpaceLocationPrototype[]
    local planets = {}
    if (tech.effects ~= nil) then
        for _, effect in pairs(tech.effects) do
            if (effect.space_location ~= nil) then
                if (effect.space_location == "maraxsis-trench" or effect.space_location == "linox-planet_linox" or effect.space_location == "foliax") then goto continue end
                for _, location in pairs(data.raw["planet"]) do
                    if (location.name == effect.space_location) then
                        table.insert(planets, location)
                    end
                end
                ::continue::
            end
        end
    end
    if (#planets > 0) then
        local id = ""
        for index, planet in pairs(planets) do
            if (index == 1) then
                id = id .. planet.name
            else
                id = id .. "-" .. planet.name
            end
        end
        log("Making tech for planet " .. id)
        local tech_name = "visit-" .. id
        planet_map[tech_name] = {}
        for _, planet in pairs(planets) do
            table.insert(planet_map[tech_name], planet.name)
        end
        local has_children = false
        for _, sub_tech in pairs(data.raw["technology"]) do
            if (sub_tech.research_trigger ~= nil and sub_tech.prerequisites ~= nil) then
                for index, parent_name in pairs(sub_tech.prerequisites) do
                    if (parent_name == tech.name) then
                        has_children = true
                        log(" * Moving child tech " .. sub_tech.name)
                        sub_tech.prerequisites[index] = tech_name
                    end
                end
            end
        end
        local localised_name
        if (#planets == 1) then
            localised_name = { "technology-description.visit-planet", { "space-location-name." .. planets[1].name } }
        else
            localised_name = { "technology-description.visit-planet-or", { "space-location-name." .. planets[1].name } }
            local prev = localised_name
            for index, planet in pairs(planets) do
                if (index > 1) then
                    if (index == #planets) then
                        local tmp = { "technology-description.visit-planet-or-chain", { "space-location-name." .. planet.name } }
                        table.insert(prev, tmp)
                        prev = tmp
                    else
                        table.insert(prev, { "space-location-name." .. planet.name })
                    end
                end
            end
        end
        ---@type (data.IconData)[]
        local icons
        if (tech.icons == nil) then
            icons = { {
                icon = tech.icon,
                icon_size = tech.icon_size
            } }
        else
            ---@diagnostic disable-next-line: cast-local-type
            icons = table.deepcopy(tech.icons)
        end
        ---@diagnostic disable-next-line: param-type-mismatch
        table.insert(icons,
            {
                icon = "__core__/graphics/icons/entity/character.png",
                scale = 1.5,
                shift = { 32, 32 }
            }
        )
        if (has_children) then
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
                    icons = icons
                }
            })
        else
            log(" * Skipped " .. tech_name .. " as it has no children")
        end
    end
end


data:extend({
    {
        type = "mod-data",
        name = "planets-require-landing-first-mod-data",
        data = planet_map
    }
})
