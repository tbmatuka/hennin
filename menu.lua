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

function menuLoveLoad()
	debug = ""
	
	menuStack = { }
	menuName = "default"
	
	menuLoadMenus()
	menuLoadCallbacks()
	
	menuCurrent = menuList[menuName]
	menuCurrent.highlighted = 1
	
	oldFont = love.graphics.getFont()
	gameNameFont = love.graphics.newFont(70)
	menuTitleFont = love.graphics.newFont(20)
end

function menuLoveDraw()
	love.mouse.setGrabbed(false)
	love.mouse.setVisible(true)
	
	love.graphics.setBackgroundColor(131, 192, 240) -- #83C0F0
	
	local font = oldFont
	
	local lineHeight
	local lineWidth
	
	local r, g, b = 0, 0, 0
	
	local menuTopY = math.floor(windowHeight * 0.1)
	
	font = gameNameFont
	love.graphics.setFont(font)
	lineHeight = font:getHeight()
	
	lineWidth = font:getWidth("Hennin")
	local gameNameX = math.floor((windowWidth - lineWidth) / 2)	
	
	love.graphics.print("Hennin", gameNameX, menuTopY)
	menuTopY = menuTopY + lineHeight + 10
	
	font = menuTitleFont
	love.graphics.setFont(font)
	lineHeight = font:getHeight()
	
	lineWidth = font:getWidth(menuCurrent.label)
	local menuTitleX = math.floor((windowWidth - lineWidth) / 2)
	
	love.graphics.print(menuCurrent.label, menuTitleX, menuTopY)
	menuTopY = menuTopY + lineHeight
	
	font = oldFont
	love.graphics.setFont(font)
	lineHeight = font:getHeight()
	
	--love.graphics.print(debug, 10, 10)
	
	local optionLabelX, optionLabelY
	for i = 1, #menuCurrent.options do
		lineWidth = font:getWidth(menuCurrent.options[i].label)
		optionLabelX = math.floor((windowWidth - lineWidth) / 2)	
		optionLabelY = menuTopY + (lineHeight + 12) * i
		
		if(xMouse > optionLabelX - 3 and xMouse < optionLabelX + lineWidth + 3 and yMouse > optionLabelY - 3 and yMouse < optionLabelY + lineHeight + 3) then
			menuCurrent.highlighted = i
		end
		
		if(menuCurrent.highlighted == i) then
			love.graphics.setColor(r, g, b, oldColorA)
		end
		
		--love.graphics.rectangle("line", optionLabelX - 3, optionLabelY - 3 , lineWidth + 6, lineHeight + 6)
		love.graphics.print(menuCurrent.options[i].label, optionLabelX, optionLabelY)
		love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
	end
end

function menuLoveMousepressed(x, y, button)
	if(button == 1) then
		menuSelectOption()
	elseif(button == 2) then
		menuCloseMenu()
	end
end

function menuLoveWheelmoved(x, y)
	if(y > 0) then
		-- scroll up
		menuHighlightPrevious()
	elseif(y < 0) then
		-- scroll down
		menuHighlightNext()
	end
end

function menuLoveUpdate()
	xMouse = love.mouse.getX()
	yMouse = love.mouse.getY()	
end

function menuLoveKeypressed(key)
	if key == 'escape' then
		menuCloseMenu()
	elseif key == 'up' then
		menuHighlightPrevious()
	elseif key == 'down' then
		menuHighlightNext()
	elseif key == 'return' or key == 'kpenter' then
		menuSelectOption()
	elseif key == "left" then
		menuCloseMenu()
	elseif key == "right" then
		menuSelectOption()
	end
end

function menuLoveResize()
	
end

function menuLoadMenus()
	menuList = {
		default = {
			name = "default",
			label = "Main menu",
			options = { {
				label = "New game",
				type = "normal",
				value = "newGame",
				callback = "newGame"
			},{
				label = "Game options",
				type = "normal",
				value = "gameOptions",
				callback = "subMenu"
			},{
				label = "Settings",
				type = "normal",
				value = "settings",
				callback = "subMenu"
			},{
				label = "Quit",
				type = "normal",
				value = "quit",
				callback = "back"
			} }
		},
		gameOptions = {
			name = "gameOptions",
			label = "Game options",
			options = { {
				label = "Game type",
				type = "multipleChoice",
				valueFunction = function ()
						return gameTypes[gameTypeId].label
					end
			},{
				label = "back",
				type = "normal",
				value = "back",
				callback = "back"
			} }
		},
		settings = {
			name = "settings",
			label = "Settings",
			options = { {
				label = "Sound",
				type = "normal",
				value = "sound",
				callback = "subMenu"
			},{
				label = "back",
				type = "normal",
				value = "back",
				callback = "back"
			} }
		},
	}
end

function menuLoadCallbacks()
	menuCallbacks = { }
	
	menuCallbacks["subMenu"] = function (option)
			local value = option.value or option:valueFunction()
			menuSwitchMenu(value)
		end
	
	menuCallbacks["sideMenu"] = function (option)
			local value = option.value or option:valueFunction()
			menuSwitchMenu(value, false)
		end
	
	menuCallbacks["back"] = function (option)
			menuCloseMenu()
		end
	
	menuCallbacks["newGame"] = function (option)
			mode = "game"
			gameNewGame()
		end
end

function menuHighlightNext()
	menuCurrent.highlighted = menuCurrent.highlighted + 1
	if(menuCurrent.highlighted > #menuCurrent.options) then
		menuCurrent.highlighted = 1
	end
end

function menuHighlightPrevious()
	menuCurrent.highlighted = menuCurrent.highlighted - 1
	if(menuCurrent.highlighted == 0) then
		menuCurrent.highlighted = #menuCurrent.options
	end
end

function menuSwitchMenu(newMenuName, stackCurrent)
	stackCurrent = stackCurrent or true
	
	if(stackCurrent) then
		menuStack[#menuStack + 1] = menuCurrent.name
	end
	
	menuCurrent = menuList[newMenuName]
	menuCurrent.highlighted = 1
end

function menuCloseMenu()
	if(#menuStack > 0) then
		-- close current submenu
		menuCurrent = menuList[menuStack[#menuStack]]
		menuStack[#menuStack] = nil
	else
		-- quit game
		love.event.quit()
	end
end

function menuSelectOption()
	if(menuCurrent.highlighted <= #menuCurrent.options and menuCurrent.highlighted > 0) then
		local callback = menuCallbacks[menuCurrent.options[menuCurrent.highlighted].callback] or menuCurrent.options[menuCurrent.highlighted].callbackFunction
		callback(menuCurrent.options[menuCurrent.highlighted])
	end
end
