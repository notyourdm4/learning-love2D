local World = {}
World.__index = World

local player = require("src.scripts.world.player")
local collidable = require("src.scripts.world.collidable")

local tiles = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 3,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 6,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 6,
    0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 6,
    0, 0, 0, 1, 3, 0, 4, 5, 3, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 6,
    0, 0, 0, 4, 6, 0, 4, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 1, 5, 6, 0, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}
local tiles_width = 20

--[[
local tiles = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 3, 0, 4, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 4, 6, 0, 4, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 5, 3, 0, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}
]]

local tile_texture
local tile_sprites

function World.init(love)
    tile_texture = love.graphics.newImage("src/sprites/tiles.png")
    tile_sprites = {
        love.graphics.newQuad(0, 0, 16, 16, tile_texture:getWidth(), tile_texture:getHeight()),
        love.graphics.newQuad(16, 0, 16, 16, tile_texture:getWidth(), tile_texture:getHeight()),
        love.graphics.newQuad(32, 0, 16, 16, tile_texture:getWidth(), tile_texture:getHeight()),
        love.graphics.newQuad(0, 16, 16, 16, tile_texture:getWidth(), tile_texture:getHeight()),
        love.graphics.newQuad(16, 16, 16, 16, tile_texture:getWidth(), tile_texture:getHeight()),
        love.graphics.newQuad(32, 16, 16, 16, tile_texture:getWidth(), tile_texture:getHeight()),
        love.graphics.newQuad(0, 32, 16, 16, tile_texture:getWidth(), tile_texture:getHeight()),
        love.graphics.newQuad(16, 32, 16, 16, tile_texture:getWidth(), tile_texture:getHeight()),
        love.graphics.newQuad(32, 32, 16, 16, tile_texture:getWidth(), tile_texture:getHeight())
    }
end

function World:new()
    local obj = {
        collidables = World:parse()
    }

    setmetatable(obj, self)
    return obj
end


function World:parse()
    local new_collidables = {}

    local tiles_b = {}

    for _, tile in ipairs(tiles) do
        table.insert(tiles_b, tile)
    end

    local topleft = nil
    local topright = nil
    local h = nil
    local y_top = nil

    for i, tile in ipairs(tiles_b) do
        if tile ~= 0 and topleft == nil then
            topleft = i
            y_top = math.floor((topleft - 1) / tiles_width)

            if (i % tiles_width == 0) then
                topright = i
            end
        end
        
        if tile ~= 0 and topleft ~= nil and (i % tiles_width == 0) then
            topright = i
        end

        if tile == 0 and topleft ~= nil and topright == nil then
            topright = i - 1
        end

        if topleft and topright then
            for column = topleft, topright, 1 do
                tiles_b[column] = 0
            end
            local broken_row = false
            h = 1
            while not broken_row and y_top + h < math.floor(#tiles / tiles_width) do
                for column = topleft, topright, 1 do
                    if tiles_b[column + tiles_width * h] == 0 then
                        broken_row = true
                        break
                    end
                end
                if broken_row then
                    break
                end
                for column = topleft, topright, 1 do
                    tiles_b[column + tiles_width * h] = 0
                end
                h = h + 1
            end

            local w = ( (topright - 1) % tiles_width + 1 - (topleft - 1) % tiles_width ) * 16
            local x = ( (topright - 1) % tiles_width + 1 ) * 16 - w / 2
            local y = ( y_top + h / 2 ) * 16

            print("("..x..", "..y..")".."->".."("..w..", "..(h * 16)..")")
            table.insert(new_collidables, collidable:new(x, y + 4, w, h * 16))
            topleft = nil
            topright = nil
        end
    end

    return new_collidables
end


function World:update(dt)
    for _, collidable in ipairs(self.collidables) do
        collidable:update(dt)
        collidable:collide(player)
    end
end


function World:draw(love)
    for index, tile in ipairs(tiles) do
        local x = (index - 1) % tiles_width
        local y = math.floor((index - 1) / tiles_width)

        if tile ~= 0 then
            love.graphics.draw(tile_texture, tile_sprites[tile], x * 16, y * 16 + 4)
        end
    end

    for _, collidable in ipairs(self.collidables) do
        collidable:draw(love)
    end
end


return World