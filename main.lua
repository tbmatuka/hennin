--[[
The MIT License (MIT)

Copyright (c) 2014 Tin Benjamin Matuka

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

dofile("game.lua")
dofile("menu.lua")
dofile("endGame.lua")

function love.load()
	love.window.setTitle("Hennin")
	love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), { msaa = 2, minwidth = 800, minheight = 600, resizable = true })

	mode = "game"
	mode = "menu"
	
	windowWidth = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()
	
	oldColorR, oldColorG, oldColorB, oldColorA = love.graphics.getColor()
	
	gameLoveLoad()
	menuLoveLoad()
	endGameLoveLoad()
end

function love.draw()
	if(mode == "game") then
		gameLoveDraw()
	elseif(mode == "menu") then
		menuLoveDraw()
	elseif(mode == "endGame") then
		endGameLoveDraw()
	end
end

function love.mousepressed(x, y, button)
	if(mode == "game") then
		gameLoveMousepressed(x, y, button)
	elseif(mode == "menu") then
		menuLoveMousepressed(x, y, button)
	elseif(mode == "endGame") then
		endGameLoveMousepressed(x, y, button)
	end
end

function love.wheelmoved(x, y)
	if(mode == "game") then
		gameLoveWheelmoved(x, y)
	elseif(mode == "menu") then
		menuLoveWheelmoved(x, y)
	elseif(mode == "endGame") then
		endGameLoveWheelmoved(x, y)
	end
end

function love.update()
	if(mode == "game") then
		gameLoveUpdate()
	elseif(mode == "menu") then
		menuLoveUpdate()
	end
end

function love.keypressed(key)
	if(mode == "game") then
		gameLoveKeypressed(key)
	elseif(mode == "menu") then
		menuLoveKeypressed(key)
	elseif(mode == "endGame") then
		endGameLoveKeypressed(key)
	end
end

function love.resize(w, h)
	windowWidth = w
	windowHeight = h
	
	if(mode == "game") then
		gameLoveResize()
	elseif(mode == "menu") then
		menuLoveResize()
	elseif(mode == "endGame") then
		endGameLoveResize()
	end
end
