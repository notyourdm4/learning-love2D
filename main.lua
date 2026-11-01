

local canvas
local canvas_scale = 1
local canvas_x, canvas_y
local screen_width, screen_height

function love.load()
    screen_width, screen_height = love.graphics.getDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest")
    canvas = love.graphics.newCanvas(screen_width, screen_height)
    canvas_scale = math.min(screen_width / canvas:getWidth(), screen_height / canvas:getHeight())
    canvas_x = 0
    canvas_y = 0
end


function love.resize(w, h)
    screen_width = w
    screen_height = h
    canvas_scale = math.min(w / canvas:getWidth(), h / canvas:getHeight())
    canvas_x = (w - (canvas:getWidth() * canvas_scale)) / 2
    canvas_y = (h - (canvas:getHeight() * canvas_scale)) / 2
end


function love.update(dt)

end


function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0.1, 0.1, 0.2)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 10, 10, 10, 10)

    love.graphics.setCanvas()
    love.graphics.draw(canvas, canvas_x, canvas_y, 0, canvas_scale, canvas_scale)
end