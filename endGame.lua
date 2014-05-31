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

function endGameLoveLoad()
	endGameReason = nil
	
	endGameReasonFont = love.graphics.newFont(70)
	endGameQuestionFont = love.graphics.newFont(20)
	endGameYesNoFont = love.graphics.newFont(16)
end

function endGameLoveDraw()
	love.mouse.setVisible(true)
	love.mouse.setGrabbed(false)
	
	love.graphics.setBackgroundColor(131, 192, 240) -- #83C0F0
	
	local font = oldFont
	
	local lineHeight
	local lineWidth
	
	local r, g, b = 0, 0, 0
	
	local textTopY = math.floor(windowHeight * 0.2)
	
	font = gameNameFont
	love.graphics.setFont(font)
	lineHeight = font:getHeight()
	
	local reasonText, questionText, yesText, yesInstructions, noText, noInstructions
	
	yesText = "Yes, start a new game"
	yesInstructions = "To start a new game press 'space', 'return' or 'left click'."
	noText = "No, exit to the menu"
	noInstructions = "To exit press 'escape' or 'right click'."
	
	if(endGameReason == "quit") then
		reasonText = "Had enough?"
		questionText = "Are you sure you want to quit?"
		yesText = "Yes, exit to the menu"
		yesInstructions = "To exit press 'escape' or 'right click'."
		noText = "No, continue playing"
		noInstructions = "To go back to your game press 'space', 'return' or 'left click'."
	elseif(endGameReason == "won") then
		reasonText = "Victory!"
		questionText = "Congratulations, you won!"
	elseif(endGameReason == "lost") then
		reasonText = "GAME OVER"
		questionText = "You lost..."
	end
	
	lineWidth = font:getWidth(reasonText)
	local printX = math.floor((windowWidth - lineWidth) / 2)	
	
	love.graphics.print(reasonText, printX, textTopY)
	textTopY = textTopY + lineHeight + 10
	
	font = endGameQuestionFont
	love.graphics.setFont(font)
	lineHeight = font:getHeight()
	
	lineWidth = font:getWidth(questionText)
	printX = math.floor((windowWidth - lineWidth) / 2)
	
	love.graphics.print(questionText, printX, textTopY)
	textTopY = textTopY + lineHeight + 30
	
	
	-- print yes text
	font = endGameYesNoFont
	love.graphics.setFont(font)
	lineHeight = font:getHeight()
	
	lineWidth = font:getWidth(yesText)
	printX = math.floor((windowWidth - lineWidth) / 2)
	
	love.graphics.print(yesText, printX, textTopY)
	textTopY = textTopY + lineHeight + 10
	
	font = oldFont
	love.graphics.setFont(font)
	lineHeight = font:getHeight()
	
	lineWidth = font:getWidth(yesInstructions)
	printX = math.floor((windowWidth - lineWidth) / 2)
	
	love.graphics.print(yesInstructions, printX, textTopY)
	textTopY = textTopY + lineHeight + 30
	
	-- print no text
	font = endGameYesNoFont
	love.graphics.setFont(font)
	lineHeight = font:getHeight()
	
	lineWidth = font:getWidth(noText)
	printX = math.floor((windowWidth - lineWidth) / 2)
	
	love.graphics.print(noText, printX, textTopY)
	textTopY = textTopY + lineHeight + 10
	
	font = oldFont
	love.graphics.setFont(font)
	lineHeight = font:getHeight()
	
	lineWidth = font:getWidth(noInstructions)
	printX = math.floor((windowWidth - lineWidth) / 2)
	
	love.graphics.print(noInstructions, printX, textTopY)
end

function endGameLoveMousepressed(x, y, button)
	if(button == "l") then
		mode = "game"
		if(endGameReason ~= "quit") then
			gameNewGame()
		else
			gameLoveResize()
		end
	elseif(button == "r") then
		mode = "menu"
	end
end

function endGameLoveKeypressed(key)
	if key == 'escape' then
		mode = "menu"
	elseif key == 'return' or key == 'kpenter' or key == ' ' then
		mode = "game"
		if(endGameReason ~= "quit") then
			gameNewGame()
		else
			gameLoveResize()
		end
	end	
end

function endGameLoveResize()
	
end
