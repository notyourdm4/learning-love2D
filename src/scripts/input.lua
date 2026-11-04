local Input = {
    binds = {
        left = {"a", "left"},
        right = {"d", "right"},
        up = {"w", "up"},
        down = {"s", "down"},
        jump = {"space", "z"},
    },
    tapped = {},
    antitapped = {},
    pressed = {}
}

function Input.update(dt)
    for key, _ in pairs(Input.tapped) do
        Input.tapped[key] = false
    end
    for key, _ in pairs(Input.antitapped) do
        Input.antitapped[key] = false
    end
end

function Input.is_tapped(keybind)
    for _, key in pairs(Input.binds[keybind]) do
        if Input.tapped[key] then
            return true
        end
    end
    return false
end

function Input.is_antitapped(keybind)
    for _, key in pairs(Input.binds[keybind]) do
        if Input.antitapped[key] then
            return true
        end
    end
    return false
end

function Input.is_pressed(keybind)
    for _, key in pairs(Input.binds[keybind]) do
        if Input.pressed[key] then
            return true
        end
    end
    return false
end

function Input.get_axis(negative, positive)
    local axis = 0

    if Input.is_pressed(negative) then
        axis = axis - 1
    end

    if Input.is_pressed(positive) then
        axis = axis + 1
    end

    return axis
end

function Input.on_key_press(key)
    Input.tapped[key] = true
    Input.pressed[key] = true
end

function Input.on_key_release(key)
    Input.antitapped[key] = true
    Input.pressed[key] = false
end

return Input