local Input = {
    binds = {
        left = {"a"},
        right = {"d"},
        up = {"w"},
        down = {"s"},
        jump = {"space"},
    },
    tapped = {},
    pressed = {}
}

function Input.update(dt)
    for key, _ in pairs(Input.tapped) do
        Input.tapped[key] = false
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
    Input.pressed[key] = false
end

return Input