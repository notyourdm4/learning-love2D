local Util = {}

function Util.sign(value)
    if value == 0 then
        return 0
    end
    return math.abs(value) / value
end

function Util.lerp(current, target, delta)
    return current + (target - current) * delta
end

function Util.lerp_dt(current, target, delta, dt)
    return target + (current - target) * math.exp(-dt * delta)
end

function Util.vector_length(x, y)
    return math.sqrt(x * x + y * y)
end

function Util.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

return Util