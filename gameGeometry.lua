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

function collisionAll(a, b, c)
	local hitX, hitY = x0, 0
	local x, y = xMouse, yMouse
	local hitType, hitNode, hitPath = "", {}, { { x = hitX, y = y0 } }
	local oldHitX, oldHitY = hitX, y0
	local direction
	
	if(x < 0) then
		direction = "left"
	elseif(x > 0) then
		direction = "right"
	else
		direction = "up"
	end
	
	repeat
		-- if this is not our first bounce, adjust the line
		if(hitY > 0) then
			x = oldHitX
			y = hitY - (oldHitY - hitY)
			a, b, c = twoPointLine(hitX, hitY, x, y)
			
			if(hitType == "wallLeft") then
				direction = "right"
			else
				direction = "left"
			end
			
			oldHitX, oldHitY = hitX, hitY
		end
		
		-- check where we're hitting the side walls
		if(direction == "left") then
			hitX, hitY = collisionWallLeft(a, b, c)
			hitType = "wallLeft"
		elseif(direction == "right") then
			hitX, hitY = collisionWallRight(a, b, c)
			hitType = "wallRight"
		end
		
		-- check where we're hitting the top wall
		local xTop, yTop = collisionWallTop(a, b, c)
		if(yTop > hitY) then
			hitType = "wallTop"
			hitX, hitY = xTop, yTop
		end
		
		local nodeCollision = false
		for i = 1, rows, 1 do
			for j = 1, columns, 1 do
				if(node[i][j] ~= nil) then
					local nodeCol, nodeColX, nodeColY = collisionNode(a, b, c, node[i][j].x, node[i][j].y, direction)
					if(nodeCol and nodeColY >= hitY) then
						hitType = "node"
						hitNode = { row = i, column = j }
						hitX = nodeColX
						hitY = nodeColY
						nodeCollision = true
					end
				end
			end
		end
		
		hitPath[#hitPath + 1] = { x = hitX, y = hitY }
	until(hitType == "wallTop" or hitType == "node")
	
	return hitType, hitX, hitY, hitNode, hitPath
end

function twoPointLine(x1, y1, x2, y2)
	local a = y2 - y1
	local b = x1 - x2
	local c = x2 * y1 - x1 * y2
	
	return a, b, c
end

function collisionWallLeft(a, b, c)
	local x = wallLeftX + radiusCollision
	local y = - ( a * x + c ) / b
	
	return x, y
end

function collisionWallRight(a, b, c)
	local x = wallRightX - radiusCollision
	local y = - ( a * x + c ) / b
	
	return x, y
end

function collisionWallTop(a, b, c)
	local y = wallTopY + radiusCollision
	local x = - ( b * y + c ) / a
	
	return x, y
end

function collisionNode(a, b, c, x, y, direction)
	local collision = false -- true if nodes will collide

	-- sides to the triangle between node center, closest point to the
	-- line and the center of the resulting position for our new node
	local r2 = ( 2 * radiusCollision ) ^ 2 -- squared
	local d2 = ( ( a * x + b * y + c ) ^ 2 ) / ( ( a ^ 2 ) + ( b ^ 2 ) ) --squared
	local deltaZ = r2 - d2 -- squared
		
	local yCol, xCol
	
	if(d2 <= r2) then
		-- nodes will collide
		collision = true
		
		-- line at a right angle to our trajectory line
		local a2 = b / a
		local b2 = -1
		local c2 = y - ( b / a ) * x
		
		-- closest point from line to node center
		local x2 = (( c2 * b ) - ( c * b2 )) / (( a * b2 ) - ( a2 * b ))
		local y2 = lineYFromX(a, b, c, x2)
		
		-- if the line is pointing straight up, closest y coordinate to
		-- the point is at the same y
		if(direction == "up") then
			yCol = y + math.sqrt(deltaZ) * math.sin(math.atan(- a / b))
		elseif(direction == "right") then
			yCol = y2 - math.sqrt(deltaZ) * math.sin(math.atan(- a / b))
		elseif(direction == "left") then
			yCol = y2 + math.sqrt(deltaZ) * math.sin(math.atan(- a / b))
		end
		
		xCol = lineXFromY(a, b, c, yCol)
	end
	
	return collision, xCol, yCol
end

function aimConeCoordinates(a, b, c)
	local point0x, point0y, point1x, point1y, point2x, point2y
	
	-- line at a right angle to our trajectory line
	local a2 = b / a
	local b2 = -1
	local c2 = y0 - ( b / a ) * x0
	
	point0y = y0 - radiusNode * math.sin(math.atan(- a2 / b2))
	point2y = y0 + radiusNode * math.sin(math.atan(- a2 / b2))
	
	point0x = lineXFromY(a2, b2, c2, point0y)
	point2x = lineXFromY(a2, b2, c2, point2y)
	
	if(b < 0) then
		point1y = y0 + radiusNode * 5 * math.sin(math.atan(- a / b))
	elseif(b > 0) then
		point1y = y0 - radiusNode * 5 * math.sin(math.atan(- a / b))
	else
		point1y = y0 - radiusNode * 5
		
		point0y = y0
		point2y = y0
		
		point0x = x0 - radiusNode
		point2x = x0 + radiusNode
	end
	point1x = lineXFromY(a, b, c, point1y)
	
	return { point0x, point0y, point1x, point1y, point2x, point2y }
end

function lineXFromY(a, b, c, y)
	return (- ( b * y + c ) / a)
end

function lineYFromX(a, b, c, x)
	return (- ( a * x + c ) / b)
end
