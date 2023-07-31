resources_array = {
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

directions_array = {"north", "west", "sud", "est"}

path_array = {}


-- UTILITIES --
function dig_forward()
    while turtle.detect() do
        turtle.dig()
        os.sleep(0.5)
    end
end

function dig_up()
    while turtle.detectUp() do
        turtle.digUp()
        os.sleep(0.5)
    end
end


-- INVENTORY --
function item_is_resource(block_name)
    for j = 1, #resources_array do 
        if block_name == resources_array[j] then
            return true
        end
    end
end

function clean_inventory()
    for m = 1, 16 do
        local item_data_table = turtle.getItemDetail(m)
        if item_data_table ~= nil and not item_is_resource(item_data_table.name) then
            turtle.select(m)
            turtle.drop()
        end 
    end
    turtle.select(1)
end


-- RESOURCES FINDER --
function face_toward_north()
    if path_array[#path_array] == "west" then
        turtle.turnRight()
    elseif path_array[#path_array] == "est" then
        turtle.turnLeft()
    elseif path_array[#path_array] == "sud" then
        turtle.turnRight()
        turtle.turnRight()
    end
end

function resource_is_around()
    for i = 1, #directions_array do
        local block_is_found , block_data_table = turtle.inspect()
        if block_is_found and item_is_resource(block_data_table.name) then
            table.insert(path_array, directions_array[i])
            clean_inventory()
            dig_forward()
            turtle.forward()
            return true
        end
        turtle.turnLeft()
    end
end

function resource_is_up()
    local block_up_is_found , block_up_data_table = turtle.inspectUp()
    if block_up_is_found and item_is_resource(block_up_data_table.name) then
        table.insert(path_array, "up")
        clean_inventory()
        dig_up()
        turtle.up()
        return true
    end
end

function resource_is_down()
    local block_down_is_found , block_down_data_table = turtle.inspectDown()
    if block_down_is_found and item_is_resource(block_down_data_table.name) then
        table.insert(path_array, "down")
        clean_inventory()
        turtle.digDown()
        turtle.down()
        return true
    end
end

function resource_is_near()
    if resource_is_around() then
        face_toward_north()
        return true
    elseif resource_is_up() or resource_is_down() then
        return true
    end
end

function backtrack_by_one()
    if path_array[#path_array] == "north" then
        turtle.back()
    elseif path_array[#path_array] == "west" then
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
    elseif path_array[#path_array] == "sud" then
        turtle.forward()
    elseif path_array[#path_array] == "est" then
        turtle.turnLeft()
        turtle.forward()
        turtle.turnRight()
    elseif path_array[#path_array] == "up" then
        turtle.down()
    elseif path_array[#path_array] == "down" then
        turtle.up()
    end
    path_array[#path_array] = nil
end

function look_for_resource_trail()
    resource_is_near()
    while #path_array ~= 0 do
        if not resource_is_near() then
            backtrack_by_one()
        end
    end
end


-- MAIN FUNCTION --
function strip_mine(lenght)
    for i = 1 , lenght do 
        look_for_resource_trail()
        dig_forward()
        turtle.forward()
    end
end

function strip_mine_down(lenght)
    for i = 1 , lenght do 
        look_for_resource_trail()
        turtle.digDown()
        turtle.down()
    end
end

function strip_mine_up(lenght)
    for i = 1 , lenght do 
        look_for_resource_trail()
        dig_up()
        turtle.up()
    end
end

term.clear()
term.setCursorPos(1,1)
term.write("lenght: ")
local lenght_imput = tonumber(read())

strip_mine_down(lenght_imput)
strip_mine(8)
strip_mine_up(lenght_imput)
