---------------------------------------------------------------------------------------------
-- each note corresponds to a ceratin amount of clicks on the noteblock:

-- F#  G  G#  A  A#  B  C  C#  D  D#  E   F 
-- 0   1  2   3  4   5  6  7   8  9   10  11
-- F#  G  G#  A  A#  B  C  C#  D  D#  E   F   F#
-- 12  13 14  15 16  17 18 19  20 21  22  23  24
 
-- since we will play music randomly we will use a pentatonic scale to make it sound armonius
-- F minor pentatonic scale:    F# A B C# E 
---------------------------------------------------------------------------------------------


-- SPEAKERS --
local speaker_right = peripheral.wrap("right")
local speaker_left = peripheral.wrap("left")


-- MAIN RITHM --
arpeggio_array_guitar = {
    0, 12, 7, 4,    -- arpeggio of  F#_major
    10, 22, 17, 14, -- arpeggio of  E_minor
    3, 15, 10, 19,  -- arpeggio of  A_major
    7, 19, 14, 12   -- arpeggio of  C#_5 + F#
}

arpeggio_array_bass = {
    0, 0, 0, 0,     -- F#
    10, 10, 10, 10, -- E
    3, 3, 3, 3,     -- A
    7, 7, 7, 7      -- C#
}


-- FUNCTIONS --
function random_harp_note(difficulty, harp_pitch)
    if math.random(difficulty) == 1 then
        speaker_right.playNote("harp",3, harp_pitch)
    end
end

function random_bell_note(difficulty, harp_pitch)
    if math.random(difficulty) == 1 then
        speaker_right.playNote("bell",3, harp_pitch)
    end
end

function random_pentatonic_note() -- also sets the tempo
    sleep(0.2)
    if is_low_pitch_time then
        random_harp_note(40,0)  -- F#
        random_harp_note(40,3)  -- A
        random_harp_note(40,5)  -- B
        random_harp_note(40,7)  -- C#
        random_harp_note(40,10) -- E

        random_bell_note(40,0)  -- F#
        random_bell_note(40,3)  -- A
        random_bell_note(40,5)  -- B
        random_bell_note(40,7)  -- C#
        random_bell_note(40,10) -- E
        is_low_pitch_time = false
    else
        is_low_pitch_time = true
    end
    sleep(0.2)
    speaker_left.playNote("basedrum",3, 1)
    random_harp_note(10,12) -- F#
    random_harp_note(10,15) -- A
    random_harp_note(10,17) -- B
    random_harp_note(10,19) -- C#
    random_harp_note(10,22) -- E
    random_harp_note(10,24) -- F#
end


-- MAIN -- 
while true do
    for note=1, #arpeggio_array_guitar do
        speaker_left.playNote("guitar",3, arpeggio_array_guitar[note])
        speaker_left.playNote("bass",3, arpeggio_array_bass[note])
        random_pentatonic_note()
    end
end
