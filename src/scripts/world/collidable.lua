local Collidable = {}
Collidable.__index = Collidable

function Collidable:new(x, y, w, h)
    local obj = {
        x = x,
        y = y,
        w = w,
        h = h,
        px = 0,
        py = 0,
        dx = 0,
        dy = 0
    }
    setmetatable(obj, self)
    return obj
end


local input = require("src.scripts.input")

function Collidable:update(dt)
    if input.is_pressed("up") then
        self.dy = -50
    elseif input.is_pressed("down") then
        self.dy = 50
    else
        self.dy = 0
    end

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end


function Collidable:collide(other)
    local distance_x = other.x - self.x
    local distance_y = other.y - self.y

    local push_x = (other.w + self.w) / 2 - math.abs(distance_x)
    local push_y = (other.h + self.h) / 2 - math.abs(distance_y)

    if push_x <= 0 or push_y <= 0 then
        return false
    end

    if push_x < push_y then
        local px = (distance_x < 0 and -push_x or push_x)
        other.x = other.x + px
        other.px = self.dx

        if px ~= 0 and other.on_wall ~= nil and other.grounded ~= nil then
            other.on_wall = not other.grounded
            other.wall_normal = px
        end
    else
        local py = (distance_y < 0 and -push_y or push_y)
        other.y = other.y + py
        other.dy = self.dy
        other.py = self.dy
        other.px = self.dx

        if py < 0 and other.grounded ~= nil then
            other.grounded = true
        end
    end

    return true
end

function Collidable:draw(love)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
end


return Collidable