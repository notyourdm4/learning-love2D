local Player = {
    x = 32,
    y = 0,
    w = 16,
    h = 16,
    speed = 115,
    grounded = false,
    gravity = 4,
    fall_speed = 180,
    jump_speed = -150,
    dx = 0,
    dy = 0,
    timer_coyote = 0.0,
    timer_coyote_max = 0.1,
    timer_buffer = 0.0,
    timer_buffer_max = 0.3
}

local util = require("src.scripts.util")
local input = require("src.scripts.input")
local animatable = require("src.scripts.animatable")

function Player.init(love)
    local texture = love.graphics.newImage("src/sprites/player.png")
    local images = {
        idle1 = love.graphics.newQuad(0, 0, 16, 16, texture:getWidth(), texture:getHeight()),
        idle2 = love.graphics.newQuad(16, 0, 16, 16, texture:getWidth(), texture:getHeight()),
        idle3 = love.graphics.newQuad(32, 0, 16, 16, texture:getWidth(), texture:getHeight()),
        run1 = love.graphics.newQuad(0, 16, 16, 16, texture:getWidth(), texture:getHeight()),
        run2 = love.graphics.newQuad(16, 16, 16, 16, texture:getWidth(), texture:getHeight()),
        run4 = love.graphics.newQuad(32, 16, 16, 16, texture:getWidth(), texture:getHeight()),
        run5 = love.graphics.newQuad(48, 16, 16, 16, texture:getWidth(), texture:getHeight()),
        crouch_A = love.graphics.newQuad(0, 32, 16, 16, texture:getWidth(), texture:getHeight()),
        crouch_B = love.graphics.newQuad(48, 32, 16, 16, texture:getWidth(), texture:getHeight()),
        jump = love.graphics.newQuad(16, 32, 16, 16, texture:getWidth(), texture:getHeight()),
        fall = love.graphics.newQuad(32, 32, 16, 16, texture:getWidth(), texture:getHeight())
    }

    Player.animatable = animatable:new(texture, images.idle1, 
    {
        idle = {images.idle1, images.idle2, images.idle3},
        run = {images.run1, images.run2, images.idle1, images.run4, images.run5, images.idle1},
        jump = {images.crouch_B, images.jump},
        fall = {images.fall}
    },
    {
        idle = {0.5, 0.5, 0.2},
        run = {0.1, 0.1, 0.08, 0.1, 0.1, 0.08},
        jump = {0.06, 0.5},
        fall = {0.0}
    }, "run"
    )

    Player.animatable:play()
end

function Player.update(dt)
    Player.timer_buffer = math.max(Player.timer_buffer - dt, 0.0)
    Player.timer_coyote = math.max(Player.timer_coyote - dt, 0.0)

    if input.get_axis("left", "right") ~= 0 then
        Player.dx = Player.dx + 10 * input.get_axis("left", "right")
        Player.dx = math.min(math.max(Player.dx, -Player.speed), Player.speed)
    else
        Player.dx = Player.dx - 5 * util.sign(Player.dx)
    end
    Player.dy = math.min(Player.dy + Player.gravity, Player.fall_speed)


    if Player.y >= 164 then
        Player.y = 164
        Player.dy = 0
    end

    if input.is_tapped("jump") then
        Player.timer_buffer = Player.timer_buffer_max
    end

    if Player.timer_buffer > 0 and Player.grounded then
        Player.dy = Player.jump_speed
        Player.animatable:play("jump", true, false)
    end

    Player.x = Player.x + Player.dx * dt
    Player.y = Player.y + Player.dy * dt

    Player.grounded = (Player.y >= 164)

    if Player.dx > 0 then
        Player.animatable.facing_right = true
    elseif Player.dx < 0 then
        Player.animatable.facing_right = false
    end

    if Player.grounded then
        if Player.dx == 0 then
            Player.animatable:play("idle")
        else
            Player.animatable:play("run")
        end
    elseif Player.dy > 0 then
        Player.animatable:play("fall")
    end

    Player.animatable:update(dt)
end

function Player.draw(love)
    Player.animatable:draw(love, Player.x, Player.y, Player.w)
end

return Player