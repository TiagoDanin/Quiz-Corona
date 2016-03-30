-- 
-- Quiz: sample project
-- By TiagoDanin
-- Version: 1.0.0

--[==[
The MIT License (MIT)

Copyright (c) 2016 Tiago Danin

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
]==]--
---------------------------------------------------------------------------------------

-- Libs --
local json = require("json")
local widget = require( "widget" )

-- Base --
local background = display.newImage("bg.jpg", display.contentCenterX, display.contentCenterY)
local question = ''
local answer = ''
local quest = ''
local game = false

local text = widget.newButton
{
	defaultFile = "bt2.png",
	label = "Question",
	labelColor = { 
		default = {1, 1, 1},
	},
	font = native.systemFont,
	fontSize = 21,
}
text.x = 160; text.y = 40

-- API Trivia --
local url = "http://jservice.io/api/random/" 

function trivia(event)
    
    if ( event.isError ) then
        question = 'Network error!'
        answer = 'Network error!'
    else
        local data = json.decode(event.response)

        question = data[1].question
        answer = data[1].answer
    end

	local ok = function(event)
	box:removeSelf()
	box = native.newTextBox(160, 80, 280, 230)
		box.anchorY = 0	
		box.text = answer
		box.size = 20
		box.isEditable = false
	end

	bt = widget.newButton
	{
		defaultFile = "bt.png",
		label = "View Answer",
		labelColor = { 
			default = {1, 1, 1},
		},
		font = native.systemFont,
		fontSize = 21,
		emSboss = true,
		onPress = ok,
	}
	bt.x = 160; bt.y = 340

	box = native.newTextBox(160, 80, 280, 230)
		box.anchorY = 0	
		box.text = question
		box.size = 20
		box.isEditable = false

	game = true
    return true
end

-- Menu --
function load(event)
	local new_question = function(event)

	if game then
		box:removeSelf()
		bt:removeSelf()
		game = false
		network.request(url, "GET", trivia)
	else
		network.request(url, "GET", trivia)
	end

end

	local new = widget.newButton
	{
		defaultFile = "bt.png",
		label = "New Question",
		labelColor = { 
			default = {1, 1, 1},
		},
		font = native.systemFont,
		fontSize = 21,
		emSboss = true,
		onPress = new_question,
	}
	new.x = 160; new.y = 420

end
timer.performWithDelay( 150, load )