debris_block_array = {
    "minecraft:dirt",
    "minecraft:cobblestone",
    "minecraft:stone",
    "minecraft:diorite",
    "minecraft:andesite",
    "minecraft:deepslate",
    "minecraft:gravel",
    "minecraft:granite",
    "minecraft:cobbled_deepslate",
    "minecraft:sand",
    "minecraft:netherrack"
}

-- UTILITIES --
function object_is_in_array(element_name, array)
    for i = 1, #array do 
        if element_name == array[i] then
            return true
        end
    end
end

function face_first_chest()
    local _block_is_found , block_data_table = turtle.inspect()
    while block_data_table.name ~= "ironchest:obsidian_chest" do
        turtle.turnLeft()
        _block_is_found , block_data_table = turtle.inspect()
    end
end


-- FILTERING --
function item_has_low_max_stack(slot)
    if turtle.getItemCount(slot) + turtle.getItemSpace(slot) < 64 then
        face_first_chest()
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.drop()
        return true
    end
end

function item_is_debris(item_data_table_name)
    if object_is_in_array(item_data_table_name, debris_block_array) then
        face_first_chest()
        turtle.turnRight()
        turtle.drop()
        return true
    end
end

function item_is_from_mod(block_data_table_name)
    mod_name = string.match(block_data_table_name, "([^:]+):") -- this filters whatever is before the ":"( minecraft:stone -> minecraft )
    if mod_name ~= "minecraft" then
        face_first_chest()
        turtle.turnLeft()
        turtle.drop()
        return true
    else
        face_first_chest()
        turtle.drop()
    end
end
    
-- MAIN FUNCTION --
function auto_sort()
    for slot = 1, 16 do
        turtle.select(slot)
        local item_data_table = turtle.getItemDetail(slot, true)
        if item_data_table == nil then
            -- do nothing
        elseif item_is_debris(item_data_table.name) then
            print(item_data_table.name .. " in debris")
        elseif item_has_low_max_stack(slot) then
            print(item_data_table.name .. " in specials")
        elseif item_is_from_mod(item_data_table.name) then
            print(item_data_table.name .. " in mods")
        else
            print(item_data_table.name .. " in vanilla")
        end 
    end
end
 
while true do
    auto_sort()
    face_first_chest()
    sleep(30)
end
