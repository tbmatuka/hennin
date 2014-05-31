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

dofile("gameGeometry.lua")

function gameLoveLoad()
	colors = { "blue", "red", "green", "yellow", "grey", "purple", "cyan" }
	colorsRgb = {
		{ 85, 127, 255 },
		{ 255, 85, 85 },
		{ 85, 192, 85 },
		{ 255, 255, 64 },
		{ 200, 200, 200 },
		{ 128, 0, 128 },
		{ 85, 255, 255 }
		}
	
	dangerFont = love.graphics.getFont(20)
end

function gameNewGame()

	A = 1
	B = 1
	C = 0
	
	rows = 10
	columns = 17
	dangerMax = 12
	initalRows = 5
	deathRow = rows + 1
	
	danger = 0
	wallRows = 0
		
	initalSeed = os.time()
	math.randomseed(initalSeed)
	
	availableColors = { }
	
	node = { }
	
	gameLoveResize()
	
	local colorId
	for i = 1, rows + 1 do
		node[i] = {}
		for j = 1, columns, 1 do
			if (i <= initalRows) then
				colorId = math.random(1, #colors)
				nodeAdd(i, j, colorId)
			end
		end
	end
	
	math.randomseed(initalSeed)
	currentColorId = math.random(1, #colors)
	nextColorId = math.random(1, #colors)
	nextColorSeed = initalSeed + 1
end

function gameLoveDraw()
	local r, g, b = 0, 0, 0
	
	-- paint background
	love.graphics.setBackgroundColor(131, 192, 240) -- #83C0F0
	
	-- hide and grab mouse
	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)
	
	-- move the field to make x0 the middle
	love.graphics.translate(bufferLeft - wallLeftX, 0)
	
	-- draw death block
	r, g, b = 255, 85, 85
	love.graphics.setColor(r, g, b, 128)
	love.graphics.rectangle("fill", wallLeftX, y0 - radiusNode * 2, width, radiusNode * 2)
	love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
	
	-- draw top wall block
	r, g, b = 85, 150, 205
	love.graphics.setColor(r, g, b, 128)
	love.graphics.rectangle("fill", wallLeftX, bufferBottom, width, wallTopY - bufferBottom)
	love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
		
	-- draw walls
	love.graphics.line(wallLeftX, wallTopY, wallLeftX, y0) -- left wall
	love.graphics.line(wallRightX, wallTopY, wallRightX, y0) -- right wall
	love.graphics.line(wallLeftX, wallTopY, wallRightX, wallTopY) -- top wall
	
	-- draw all nodes
	for i = 1, rows do
		for j = 1, columns do
			if(node[i][j] ~= nil) then
				local r, g, b = getRgbForId(node[i][j].colorId)
				if(node[i][j].visited == true) then
					r, g, b = 0, 0, 0
				end
				love.graphics.setColor(r, g, b, oldColorA)
				love.graphics.circle("fill", node[i][j].x, node[i][j].y, radiusNode, 100)
				love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
				love.graphics.circle("line", node[i][j].x, node[i][j].y, radiusNode, 100)
			end
		end
	end
	
	-- check what we'd hit if we fired
	local hitType, hitX, hitY, hitNode, hitPath = collisionAll(A, B, C)
	
	-- highlight the node we'd hit
	if(hitType == "node") then
		--love.graphics.circle("fill", node[hitNode.row][hitNode.column].x, node[hitNode.row][hitNode.column].y, radiusNode, 100)
	end
	
	-- show what we'd hit
	local oldHitX, oldHitY = x0, y0
	for i = 1, #hitPath, 1 do
		--love.graphics.print("i: " .. i .. " x: " .. hitPath[i].x .. " y: " .. hitPath[i].y, 15 - width / 2, 300 + 15 * i)
		love.graphics.line(oldHitX, oldHitY, hitPath[i].x, hitPath[i].y)
		oldHitX, oldHitY = hitPath[i].x, hitPath[i].y
	end
	
	love.graphics.circle("line", hitX, hitY, radiusNode, 100)
	
	-- draw the aim cone
	conePolygon = aimConeCoordinates(A, B, C)
	
	r, g, b = 85, 150, 205
	love.graphics.setColor(r, g, b, 128)
	love.graphics.polygon("fill", conePolygon)
	love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
	love.graphics.line(conePolygon)
	
	-- draw current node
	r, g, b = getRgbForId(currentColorId)
	love.graphics.setColor(r, g, b, oldColorA)
	love.graphics.circle("fill", x0, y0, radiusNode, 100)
	love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
	
	love.graphics.circle("line", x0, y0, radiusNode, 100)
	
	-- draw next node
	r, g, b = getRgbForId(nextColorId)
	love.graphics.setColor(r, g, b, oldColorA)
	love.graphics.circle("fill", x0 + 2 * radiusNode, y0 + bufferBottom / 4, radiusNode / 2, 100)
	love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
	
	love.graphics.circle("line", x0 + 2 * radiusNode, y0 + bufferBottom / 4, radiusNode / 2, 100)
	
	-- danger level
	local font = dangerFont
	love.graphics.setFont(font)
	local lineHeight = font:getHeight()
	local lineWidth = font:getWidth("DANGER: " .. danger .. "/" .. dangerMax)
	
	love.graphics.print("DANGER: " .. danger .. "/" .. dangerMax, wallLeftX + 5, y0 - lineHeight - 5)
	
	-- debug info
	if false then
		love.graphics.print("radiusCollision: " .. radiusCollision, wallLeftX + 5, bufferBottom + 5 + 15 * 0)
		
		local row, column = nodeFromCoordinates(hitX, hitY)
		love.graphics.print("row: " .. row, wallLeftX + 5, bufferBottom + 5 + 15 * 1)
		love.graphics.print("a b c: " .. A .. " " .. B .. " " .. C, wallLeftX + 5, bufferBottom + 5 + 15 * 2)
	end
end

function gameLoveUpdate()
	xMouse = love.mouse.getX() + wallLeftX - bufferLeft
	yMouse = love.mouse.getY()
	
	if(yMouse >= y0) then
		yMouse = y0 - 1
	end
	
	A, B, C = twoPointLine(x0, y0, xMouse, yMouse)
end

function gameLoveMousepressed(x, y, button)
	if(button == "r") then
		endGameReason = "quit"
		mode = "endGame"
	else
		-- check if aim is too low and raise if needed
		if(y >= y0) then
			y = y0 - 1
		end
		
		-- loop until we hit something other than side walls
		xMouse, yMouse = x + wallLeftX - bufferLeft, y
		A, B, C = twoPointLine(x0, y0, xMouse, yMouse)
		
		-- check for collision
		local a, b, c = A, B, C
		local hitType, hitX, hitY, hitNode, hitPath
		
		hitType, hitX, hitY, hitNode, hitPath = collisionAll(a, b, c)
		
		-- add the new node
		local row, column = nodeFromCoordinates(hitX, hitY)
		nodeAdd(row, column, currentColorId)
		
		-- check if it connected to 2 of the same kind
		local nodesConnected = { }
		nodeFlood(row, column, currentColorId)
		for i = 1, rows + 1 do
			for j = 1, columns do
				if(node[i][j] ~= nil and node[i][j].visited == true and node[i][j].colorId == currentColorId) then
					nodesConnected[#nodesConnected + 1] = { row = i, column = j }
				end
				
				if(node[i][j] ~= nil) then
					node[i][j].visited = false
				end
			end
		end
		
		-- increase danger
		danger = danger + 1
		
		-- add to score
		-- score = score + (#nodesConnected * 10)
		
		if(#nodesConnected >= 3) then
			for i = 1, #nodesConnected do
				nodeRemove(nodesConnected[i].row, nodesConnected[i].column)
			end
		
			-- check if it dropped some more
			local i = 1
			for j = 1, columns do
				if(node[i][j] ~= nil) then
					node[i][j].visited = true
					nodeFlood(i, j)
				end
			end
			
			local nodesToDrop = { }
			for i = 1, rows + 1 do
				for j = 1, columns do
					if(node[i][j] ~= nil and node[i][j].visited == false) then
						nodesToDrop[#nodesToDrop + 1] = { row = i, column = j }
					end
					
					if(node[i][j] ~= nil) then
						node[i][j].visited = false
					end
				end
			end
			
			-- add to score
			-- score = score + (#nodesToDrop * 100)
			
			-- drop the nodes
			for i = 1, #nodesToDrop do
				nodeRemove(nodesToDrop[i].row, nodesToDrop[i].column)
			end
			
			-- lower danger
			if(#nodesToDrop > 0) then
				danger = danger - 1 - #nodesToDrop
				if(danger < 0) then
					danger = 0
				end
			end
		end
		
		-- check if we cleared the level
		local allClear = true
		availableColors = { }
		for i = 1, rows + 1 do
			for j = 1, columns do
				if(node[i][j]) then
					availableColors[node[i][j].colorId] = true
					allClear = false
				end
			end
		end
		
		if(allClear) then
			debug = "Game over, you won :)"
			endGameReason = "won"
			mode = "endGame"
		end
		
		-- lower the wall if we're over the danger threshold
		if(danger > dangerMax) then
			wallRows = wallRows + 1
			gameLoveResize()
			danger = 0
			deathRow = deathRow - 1
		end
		
		-- check if a node is sticking under the limit
		local gameFailed = false
		for j = 1, columns do
			if(node[deathRow][j]) then
				gameFailed = true
			end
		end
		
		if(gameFailed) then
			debug = "Game over, you lost :("
			endGameReason = "lost"
			mode = "endGame"
		end
		
		-- change color for the next node and generate another one
		currentColorId = nextColorId
		
		repeat
			math.randomseed(nextColorSeed)
			nextColorId = math.random(1, #colors)
			nextColorSeed = nextColorSeed + 1
		until (allClear or availableColors[nextColorId] == true)
	end
end

function gameLoveKeypressed(key)
	if key == 'escape' then
		endGameReason = "quit"
		mode = "endGame"
	end
end

function gameLoveResize()
	bufferLeft = 10
	bufferBottom = 10
	
	local radiusNodeCorrection = 0
	repeat
		radiusNode = math.floor((windowWidth - 20) / (columns * 2 + 1)) - radiusNodeCorrection -- collision radius
		width = radiusNode * (columns * 2 + 1) -- field width in pixels
		if(width % 2 == 1) then width = width + 1 end
		height = radiusNode * (rows + 1) * 2 -- field height in pixels
		radiusNodeCorrection = radiusNodeCorrection + 1
	until (height + bufferBottom < windowHeight)
	
	radiusCollision = math.floor(radiusNode * 0.9)
	
	height = height - wallRows * radiusNode * 2
	
	-- buffers
	bufferTop = windowHeight - height - bufferBottom
	bufferRight = windowWidth - width - bufferLeft
	
	-- launcher coordinates
	x0 = 0
	y0 = windowHeight - bufferBottom
	
	-- wall coordinates
	wallRightX = width / 2
	wallLeftX = -wallRightX
	wallTopY = y0 - height
	
	xMouse = love.mouse.getX() + wallLeftX - bufferLeft
	yMouse = love.mouse.getY()
	
	for i = 1, rows do
		for j = 1, columns do
			if(node[i] and node[i][j]) then
				node[i][j].x, node[i][j].y = nodeCoordinatesFromNode(i, j)
			end
		end
	end
end

function nodeAdd(row, column, colorId)
	local x, y = nodeCoordinatesFromNode(row, column)
	
	node[row][column] = { colorId = colorId, x = x, y = y, visited = false }
end

function nodeCoordinatesFromNode(row, column)
	local x, y
	if(row % 2 == 0) then
		x = (radiusNode * 2 * column) + wallLeftX
	else
		x = (radiusNode * 2 * (column - 1)) + radiusNode  + wallLeftX
	end
	y = (radiusNode * 2 * (row - 1)) + radiusNode + wallTopY
	
	return x, y
end

function nodeRemove(row, column)
	node[row][column] = nil
end

function nodeFlood(row, column, colorId)
	for i = 1, 6 do
		local nodeRow, nodeColumn = nodeGetNeighbour(row, column, i)
		if(node[nodeRow] and node[nodeRow][nodeColumn] and node[nodeRow][nodeColumn].visited == false) then
			node[nodeRow][nodeColumn].visited = true
			if(colorId == nil or node[nodeRow][nodeColumn].colorId == colorId) then
				nodeFlood(nodeRow, nodeColumn, colorId)
			end
		end
	end
end

function nodeGetNeighbour(row, column, direction)
	local i, nodeRow, nodeColumn
	
	if(direction == 1) then
		-- left
		nodeRow = row
		nodeColumn = column - 1
	elseif(direction == 4) then
		-- right
		nodeRow = row
		nodeColumn = column + 1
	elseif(row % 2 == 1) then
		if(direction == 2) then
			-- up left
			nodeRow = row - 1
			nodeColumn = column - 1
		elseif(direction == 3) then
			-- up right
			nodeRow = row - 1
			nodeColumn = column
		elseif(direction == 5) then
			-- down right
			nodeRow = row + 1
			nodeColumn = column
		elseif(direction == 6) then
			-- down left
			nodeRow = row + 1
			nodeColumn = column - 1
		end
	else
		if(direction == 2) then
			-- up left
			nodeRow = row - 1
			nodeColumn = column
		elseif(direction == 3) then
			-- up right
			nodeRow = row - 1
			nodeColumn = column + 1
		elseif(direction == 5) then
			-- down right
			nodeRow = row + 1
			nodeColumn = column + 1
		elseif(direction == 6) then
			-- down left
			nodeRow = row + 1
			nodeColumn = column
		end		
	end
	
	return nodeRow, nodeColumn
end

function nodeFromCoordinates(x, y)
	local row = math.ceil((y - wallTopY) / (2 * radiusNode))
	local column
	
	if(row % 2 == 1) then
		column = math.ceil((x - wallLeftX) / (2 * radiusNode))
		if (column > columns) then
			column = columns
		end
	else
		column = math.ceil((x - wallLeftX - radiusNode) / (2 * radiusNode))
		if (column < 1) then
			column = 1
		end
	end
	
	return row, column
end

function getRgbForId(colorId)
	return colorsRgb[colorId][1], colorsRgb[colorId][2], colorsRgb[colorId][3]
end
