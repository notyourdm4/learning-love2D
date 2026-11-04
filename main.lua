
local input = require("src.scripts.input")
local player = require("src.scripts.world.player")

local canvas
local canvas_data = {scale = 1.0, draw_x = 0, draw_y = 0}
local screen = { width = 320, height = 180 }

local ticks = 0
local tick_period = 1

function love.load()
    screen.width, screen.height = love.graphics.getDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest")

    canvas = love.graphics.newCanvas(screen.width, screen.height)
    canvas_data.scale = math.min(screen.width / canvas:getWidth(), screen.height / canvas:getHeight())
    player.init(love)
end


function love.update(dt)
    ticks = ticks + 1
    if ticks >= tick_period then
        ticks = 0
    else
        return
    end

    player.update(dt)
    input.update(dt)
end


function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0.1, 0.1, 0.2)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 10, 10, 10, 10)

    player.draw(love)

    love.graphics.setCanvas()
    love.graphics.draw(canvas, canvas_data.draw_x, canvas_data.draw_y, 0, canvas_data.scale, canvas_data.scale)
end


function love.resize(w, h)
    screen.width = w
    screen.height = h
    canvas_data.scale = math.min(w / canvas:getWidth(), h / canvas:getHeight())
    canvas_data.draw_x = (w - (canvas:getWidth() * canvas_data.scale)) / 2
    canvas_data.draw_y = (h - (canvas:getHeight() * canvas_data.scale)) / 2
end


function love.keypressed(key, scancode, isrepeat)
    input.on_key_press(key)
end


function love.keyreleased(key, scancode, isrepeat)
    input.on_key_release(key)
end