-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local mFloor = math.floor

local common = {}

--
-- Helper Variables
--
common.w 				   = display.contentWidth
common.h 				   = display.contentHeight
common.centerX 			= display.contentCenterX
common.centerY 			= display.contentCenterY
common.fullw			   = display.actualContentWidth 
common.fullh			   = display.actualContentHeight
common.unusedWidth		= common.fullw - common.w
common.unusedHeight		= common.fullh - common.h
common.left				   = 0 - common.unusedWidth/2
common.top 				   = 0 - common.unusedHeight/2
common.right 			   = common.w + common.unusedWidth/2
common.bottom 			   = common.h + common.unusedHeight/2

-- Clean up variables
common.w 				= mFloor(common.w+0.5)
common.h 				= mFloor(common.h+0.5)
common.left				= mFloor(common.left+0.5)
common.top				= mFloor(common.top+0.5)
common.right			= mFloor(common.right+0.5)
common.bottom			= mFloor(common.bottom+0.5)
common.fullw			= mFloor(common.fullw+0.5)
common.fullh			= mFloor(common.fullh+0.5)

--
-- Game Variables
--
common.debugEn		= false


--
-- World Settings
--
common.gridSize 	   = 80 -- set to 40 for debugging and demo 80 otherwise
common.worldWidth 	= 32 -- # gridSize units wide
common.worldHeight   = 24 -- # gridSize units tall

--
-- Player Settings
--
common.leftLimit = common.centerX - common.gridSize * 8
common.rightLimit = common.centerX + common.gridSize * 8
common.upLimit = common.centerY - common.gridSize * 6
common.downLimit = common.centerY + common.gridSize * 6

--
-- Enemy Settings
--
common.enemySpawnOffset = 150 -- For debug ONLY; Should normally be 0 or negative; Large enough values cause enemies to spawn 'on screen'.
common.enemyTweenTime   = 1000
common.maxEnemies       = 1
common.enemyBaseSpeed   = 60
common.enemyMinSpeed    = 75/2 -- 75
common.enemyMaxSpeed    = 150/2 -- 150

--
-- Arrow Settings
--
common.arrowsPerSecond 		= 5
common.arrowPeriod 			= 1000/common.arrowsPerSecond
common.arrowLifetime 		= 2000
common.arrowSpeed 			= 300 -- pixels per seconbd
common.maxArrows           = 3


common.gridColors = { {1,1,1,0.2}, {0,1,1,0.2}, }
common.gridColors2 = { {1,1,1,0.2}, {1,0,1,0.2}, }


-- Determine design orientation
common.orientation  	= ( common.w > common.h ) and "landscape"  or "portrait"
common.isLandscape 		= ( common.w > common.h )
common.isPortrait 		= ( common.h > common.w )

-- Further clean up variables
common.left 			= (common.left>=0) and math.abs(common.left) or common.left
common.top 				= (common.top>=0) and math.abs(common.top) or common.top

--
-- Helper Functions
--

--
-- Test if a display object is valid
--
function common.isValid( obj )
   return obj.removeSelf ~= nil
end

-- Shorthand for Runtime:*() functions
--
local pairs = _G.pairs
function common.isValid( obj ) 
	return (obj and obj.removeSelf ~= nil)
end

function common.listen( name, listener ) Runtime:addEventListener( name, listener ) end
function common.ignore( name, listener ) Runtime:removeEventListener( name, listener ) end
function common.autoIgnore( name, obj ) 
    if( not common.isValid( obj ) ) then
      ignore( name, obj )
      obj[name] = nil
      return true
    end
    return false 
end
function common.post( name, params, debuglvl )
   params = params or {}
   local event = { name = name }
   for k,v in pairs( params ) do event[k] = v end
   if( not event.time ) then event.time = getTimer() end
   if( debuglvl and debuglvl >= 2 ) then table.dump(event) end
   Runtime:dispatchEvent( event )
   if( debuglvl and debuglvl >= 1 ) then print("post( '" .. name .. "' )" ) end   
end

-- Normalize Rotations - Force rotation (number of object.rotation ) to be in range [ 0, 360 )
--
function common.normRot( toNorm )
	if( type(toNorm) == "table" ) then
		while( toNorm.rotation >= 360 ) do toNorm.rotation = toNorm.rotation - 360 end		
		while( toNorm.rotation < 0 ) do toNorm.rotation = toNorm.rotation + 360 end
		return 
	else
		while( toNorm >= 360 ) do toNorm = toNorm - 360 end
		while( toNorm < 0 ) do toNorm = toNorm + 360 end
	end
	return toNorm
end

--
-- Table counter for non-numerically indexed tables
--
function common.tableCount( tbl )
   local count = 0
   if( tbl ~= nil ) then
      for k,v in pairs( tbl ) do 
         count = count + 1
      end
   end
   return count
end
   


--
-- Collision Calculator For Easy Collision Calculations
--
local ccmgr = require "plugin.cc"

common.myCC = ccmgr:newCalculator()
common.myCC:addNames( "player", "enemy", "playerarrow", "enemyarrow", "other" )
common.myCC:collidesWith( "player", { "enemy", "enemyarrow" } )
common.myCC:collidesWith( "enemy", { "player", "playerarrow" } )
common.myCC:collidesWith( "other", { "player", "playerarrow", "enemyarrow" } )
--]]

return common