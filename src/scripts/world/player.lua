local Player = {
    x = 32,
    y = 0,
    w = 8,
    h = 16,
    speed = 125,
    grounded = false,
    on_wall = false,
    was_grounded = false,
    was_on_wall = false,
    wall_normal = 0,
    accel = 7,
    decel = 3.5,
    gravity = 5,
    fall_speed = 300,
    jump_speed = -200,
    wall_jump_speed = 150,
    jump_release_speed = -50,
    input_x = 0,
    dx = 0,
    dy = 0,
    px = 0,
    py = 0,
    timer_walljump = 0.0,
    timer_coyote = 0.0,
    timer_coyote_max = 0.2,
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
        run = {0.08, 0.08, 0.06, 0.08, 0.08, 0.06},
        jump = {0.06, 0.5},
        fall = {0.0}
    }, "run"
    )

    Player.animatable:play()
end


function Player.update(dt)
    if Player.timer_buffer > 0 and (Player.grounded or Player.on_wall or Player.timer_coyote > 0) then
        Player.timer_buffer = 0
        Player.dy = Player.jump_speed + math.min(0.0, Player.py)
        if (Player.on_wall or Player.timer_walljump > 0) and not Player.grounded then
            Player.dx = util.sign(Player.wall_normal) * Player.wall_jump_speed
        end
        Player.grounded = false
        Player.on_wall = false
        Player.was_grounded = false
        Player.was_on_wall = false
        Player.animatable:play("jump", true, false)
    end

    if not input.is_pressed("jump") and not Player.grounded and Player.dy < Player.jump_release_speed then
        Player.dy = Player.jump_release_speed
        Player.timer_buffer = 0
    end

    -- Coyote system?
    if not (Player.grounded or Player.on_wall) and (Player.was_grounded or Player.was_on_wall) then
        Player.timer_coyote = Player.timer_coyote_max
        if (Player.was_on_wall and not Player.was_grounded) then
            Player.timer_walljump = Player.timer_coyote_max
        end
    end
    Player.was_grounded = Player.grounded
    Player.was_on_wall = Player.on_wall

    if Player.grounded or Player.was_grounded then
        Player.timer_walljump = 0.0
    end

    Player.grounded = false
    Player.on_wall = false

    Player.timer_buffer = math.max(Player.timer_buffer - dt, 0.0)
    Player.timer_coyote = math.max(Player.timer_coyote - dt, 0.0)
    Player.timer_walljump = math.max(Player.timer_walljump - dt, 0.0)


    Player.input_x = input.get_axis("left", "right")
    if Player.input_x ~= 0 then
        Player.dx = Player.dx + Player.accel * Player.input_x
        -- Player.dx = math.min(math.max(Player.dx, -Player.speed), Player.speed)
        Player.dx = util.sign(Player.dx) * math.min(math.abs(Player.dx), Player.speed)
    else
        Player.dx = Player.dx - Player.accel * util.sign(Player.dx)
        if math.abs(Player.dx) <= Player.accel then
            Player.dx = 0
        end
    end

    Player.dy = math.min(Player.dy + Player.gravity, Player.fall_speed)

    if input.is_tapped("jump") then
        Player.timer_buffer = Player.timer_buffer_max
    end

    --[[
    if input.is_pressed("down") then
        Player.h = 8
    else
        Player.h = 16
    end
    ]]

    Player.x = Player.x + (Player.dx + Player.px) * dt
    Player.y = Player.y + Player.dy * dt

    if Player.y >= 172 then
        Player.y = 172
        Player.dy = 0
        Player.grounded = true
    end
end

function Player.animate(dt)
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
    else
        Player.animatable:play("jump", true, false)
    end

    Player.animatable:update(dt)
end


function Player.draw(love)
    Player.animatable:draw(love, Player.x, Player.y, 16, 16)

    -- love.graphics.rectangle("line", Player.x - Player.w / 2, Player.y - Player.h / 2, Player.w, Player.h)
end

return Player