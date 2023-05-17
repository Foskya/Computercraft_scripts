resources_array = {
    "minecraft:coal",
    "minecraft:raw_iron",
    "minecraft:raw_gold",
    "minecraft:raw_copper",
    "minecraft:redstone",
    "minecraft:lapis_lazuli",
    "minecraft:diamond",
    "minecraft:emerald",
    "minecraft:quartz",
    "minecraft:gold_nugget",
    "minecraft:ancient_debris"
}

-- INVENTORY MANAGEMENT --
function block_is_ore(block_name)
    for j = 1, #resources_array do 
        if block_name == resources_array[j] then
            return true
        end
    end
    return false
end

function clean_inventory()
    for m = 1, 16 do
        local item_data_table = turtle.getItemDetail(m)
        if item_data_table ~= nil then
            if not block_is_ore(item_data_table.name) then
                turtle.select(m)
                turtle.drop()
            end
        end 
    end
end


-- UTILITIES --
function dig_in_front()
    while turtle.detect() do
        turtle.dig()
        os.sleep(0.5)
    end
end

function dig_up_and_down()
    while turtle.detectUp() or turtle.detectDown() do
        turtle.digUp()
        turtle.digDown()
    end
end

-- MOVEMENT --
function go_up_or_down()
    if direction_is_up then
        turtle.up()
        while turtle.detectUp() do
            turtle.digUp()
            os.sleep(0.5)
        end
    else
        turtle.down()
        turtle.digDown()
    end
end

function turn(width, current_turtle_floor, current_turtle_Y_position)
    if width % 2 == 0 and current_turtle_floor % 2 == 0 then
        if current_turtle_Y_position % 2 == 1 then
            turtle.turnRight()
            dig_in_front()
            turtle.forward()
            turtle.turnRight()
        else
            turtle.turnLeft()
            dig_in_front()
            turtle.forward()
            turtle.turnLeft()
        end
    else
        if current_turtle_Y_position % 2 == 1 then
            turtle.turnLeft()
            dig_in_front()
            turtle.forward()
            turtle.turnLeft()    
        else
            turtle.turnRight()
            dig_in_front()
            turtle.forward()
            turtle.turnRight()
        end
    end
    clean_inventory()
end

initial_block = 0
function dig_horizontically(width, lenght, current_turtle_floor) 
    for current_turtle_Y_position=1, width do
        for current_turtle_X_position = 1, (lenght - initial_block) do
            dig_in_front()
            turtle.forward()
            dig_up_and_down()
        end
        if current_turtle_Y_position < width then
            turn(width,current_turtle_floor,current_turtle_Y_position)
            dig_up_and_down()
        end
        initial_block = 1
    end
end

-- USER IMPUTS --
term.clear()
term.setCursorPos(1,1)
term.write("length: ")
local lenght = tonumber(read())
term.setCursorPos(1,2)
term.write("width:  ")
local width = tonumber(read())
term.setCursorPos(1,3)
term.write("height: ")
local height = tonumber(read())

direction_is_up = true
while true do
    term.setCursorPos(1,4)
    if direction_is_up then
        term.write("direction: [up]  down ")
    else
        term.write("direction:  up  [down]")
    end

    _name_of_event, key_pressed = os.pullEvent("key")
    if key_pressed == keys.left then
        direction_is_up = true
    elseif key_pressed == keys.right then
        direction_is_up = false
    elseif key_pressed == keys.enter or key_pressed == keys.numPadEnter then
        break
    end
end

term.setCursorPos(1,5)


-- APROXIMATE FUEL CHECK --
if height < 3 then
    height = 3
end

local floors = math.floor(height/3)
if (height % 3) ~= 0 then
    shallow_floors = 1 -- floors with hight < 3 bloks
else
    shallow_floors = 0 
end

local aproximate_distance_covered = (lenght * width * (floors + shallow_floors))
if aproximate_distance_covered > turtle.getFuelLevel() then 
    error("ERROR - fuel needed: "..aproximate_distance_covered)
end

-- MAIN FUNCTION --
for current_turtle_floor=1, floors do
    dig_horizontically(width, lenght, current_turtle_floor)
    turtle.turnLeft()
    turtle.turnLeft()
    if current_turtle_floor < floors then
        go_up_or_down()
        go_up_or_down()
        go_up_or_down()
    end
end

if (height % 3) == 1 then
    go_up_or_down()
    dig_horizontically(width,lenght,(floors+1))
elseif (height % 3) == 2 then
    go_up_or_down()
    go_up_or_down()
    dig_horizontically(width,lenght,(floors+1))
end

if direction_is_up then
    repeat turtle.down()
    until(turtle.detectDown())
end
