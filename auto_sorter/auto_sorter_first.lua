ores_array = {
    -- overworld ores
    "minecraft:coal_ore",
    "minecraft:deepslate_coal_ore",
    "minecraft:iron_ore",
    "minecraft:deepslate_iron_ore",
    "minecraft:gold_ore",
    "minecraft:deepslate_gold_ore",
    "minecraft:copper_ore",
    "minecraft:deepslate_copper_ore",
    "minecraft:redstone_ore",
    "minecraft:deepslate_redstone_ore",
    "minecraft:lapis_ore",
    "minecraft:deepslate_lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:deepslate_diamond_ore",
    "minecraft:emerald_ore",
    -- nether ores
    "minecraft:nether_gold_ore",
    "minecraft:quartz_ore",
    "minecraft:ancient_debris",
    -- item ores
    "minecraft:coal",
    "minecraft:raw_iron",
    "minecraft:raw_gold",
    "minecraft:raw_copper",
    "minecraft:redstone",
    "minecraft:lapis_lazuli",
    "minecraft:diamond",
    "minecraft:emerald",
    "minecraft:quartz",
    "minecraft:gold_nugget"
}

foods_array = {
    "minecraft:pumpkin",
    "minecraft:wheat",
    "minecraft:hay_block",
    "minecraft:melon"
}


ores_tag_array = {
    "c:raw_materials", 
    "c:ingots", 
    "c:gems", 
    "c:dusts", 
    "c:nuggets",
    "c:storage_blocks"
}

equipment_tag_array = {
    "c:tools", 
    "c:armors", 
    "minecraft:arrows", 
    "c:potions"
}

food_tag_array = {
    "c:foods",
    "c:seeds",
}

wood_tag_array = {
    "minecraft:planks",
    "minecraft:logs", 
    "minecraft_slabs"
}



-- UTILITIES --
function object_is_in_array(element_name, array)
    for i = 1, #array do 
        if element_name == array[i] then
            return true
        end
    end
end

function item_has_tag(item_tags_array, chosen_tag_array)
    for group_name, _boolean in pairs(item_tags_array) do
        if object_is_in_array(group_name, chosen_tag_array) then
            return true
        end
    end
end
 
function face_barrel()
    local _block_is_found , block_data_table = turtle.inspect()
    while block_data_table.name ~= "minecraft:barrel" do
        turtle.turnLeft()
        _block_is_found , block_data_table = turtle.inspect()
    end
end


-- FILTERING --
function item_is_food(item_data_table)
    if item_has_tag(item_data_table.tags, food_tag_array) or object_is_in_array(item_data_table.name, foods_array) then
        face_barrel()
        turtle.drop()
        return true
    end
end

function item_is_ore(item_data_table)
    if object_is_in_array(item_data_table.name, ores_array) or item_has_tag(item_data_table.tags, ores_tag_array) then
        face_barrel()
        turtle.turnLeft()
        turtle.drop()
        return true
    end
end

function item_is_equipment(item_data_table)
    if item_has_tag(item_data_table.tags, equipment_tag_array) then
        face_barrel()
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.drop()
		return true
    end
end

function item_is_wood(item_data_table)
    local is_fuel, _string_if_false = turtle.refuel(0) -- it "burns" 0 items
    if is_fuel or item_has_tag(item_data_table.tags, wood_tag_array) then
        face_barrel()
        turtle.turnRight()
        turtle.drop()
		return true
    end
end

-- MAIN FUNCTION --
function auto_sort()
    for slot = 1, 16 do
        turtle.select(slot)
        local item_data_table = turtle.getItemDetail(slot, true)
        if item_data_table == nil then
            -- do nothing
        elseif item_is_food(item_data_table) then
            print(item_data_table.name .. " in foods")
        elseif item_is_ore(item_data_table) then
            print(item_data_table.name .. " in ores")
        elseif item_is_equipment(item_data_table) then
            print(item_data_table.name .. " in equipments")
        elseif item_is_wood(item_data_table) then
            print(item_data_table.name .. " in wood")
        else
            turtle.dropDown()
            print(item_data_table.name .. " dropped")
        end 
    end
end

while true do
    auto_sort()
    face_barrel()
    sleep(30)
end
