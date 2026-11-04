local Animatable = {}
Animatable.__index = Animatable

function Animatable:new(texture, default_image, animations, animation_timers, default_animation)
    local obj = {
        texture = texture,
        image = default_image,
        animations = animations,
        animation = default_animation,
        animation_index = 1,
        animation_timers = animation_timers,
        animation_timer = 0.0,
        playing = false,
        looping = true,
        facing_right = true,
    }
    setmetatable(obj, self)
    return obj
end


function Animatable:play(animation, playing, looping)
    if playing == nil then
        playing = true
    end
    self.playing = playing

    if looping == nil then
        looping = true
    end
    self.looping = looping

    if animation ~= nil then
        if animation ~= self.animation then
            self.animation_index = 1
            self.animation_timer = self.animation_timers[animation][self.animation_index]
        end
        self.animation = animation
    end
end


function Animatable:update(dt)
    if self.playing then
        self.animation_timer = math.max(self.animation_timer - dt, 0.0)
    end
    if self.animation_timer <= 0.0 then
        if self.looping then
            self.animation_index = self.animation_index % #self.animations[self.animation] + 1
        else
            self.animation_index = math.min(self.animation_index + 1, #self.animations[self.animation])
        end
        self.animation_timer = self.animation_timers[self.animation][self.animation_index]
    end
    self.image = self.animations[self.animation][self.animation_index]
end

function Animatable:draw(love, x, y, w, h)
    if self.facing_right then
        love.graphics.draw(self.texture, self.image, x - w/2, y - h/2, 0, 1, 1)
    else
        love.graphics.draw(self.texture, self.image, x + w/2, y - h/2, 0, -1, 1)
    end
end

return Animatable