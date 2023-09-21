function print_centered_message(monitor, message, y)
    local width, height = monitor.getSize()
    local x = math.floor((width - #message) / 2) + 1
    --local y = math.floor(height / 2)
    monitor.setCursorPos(x, y)
    monitor.write(message)
end


local monitor = peripheral.wrap("left")
while true do
    local time = os.time() -- between  0 and 23.999

    if time >= 6 and time < 18 then
        phase = "DAYLIGHT"
        monitor.setBackgroundColor(colors.yellow)
        monitor.setTextColor(colors.blue)
        minutes_left = math.floor((18-time)/1.2) -- 20 tick per second => 1200 tick per minute
    else
        phase = "NIGHT"
        monitor.setBackgroundColor(colors.blue)
        monitor.setTextColor(colors.orange)
        if time < 6 then
        	minutes_left = math.floor((6-time)/1.2)
		else
            minutes_left = math.floor((30-time)/1.2)
        end
    end
    
    monitor.clear()
    print_centered_message(monitor, "day "..tostring(os.day()), 3)
    print_centered_message(monitor, phase, 5)
    print_centered_message(monitor, tostring(minutes_left).." min left", 6)

    sleep(5)
end
