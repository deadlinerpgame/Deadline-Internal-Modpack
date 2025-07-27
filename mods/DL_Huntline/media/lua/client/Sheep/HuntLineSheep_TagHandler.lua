
require "lua_timers"
HuntLineSheep = HuntLineSheep or {}



function HuntLineSheep.removeTag(targ)
    targ:clearAttachedAnimSprite()
end
function HuntLineSheep.isTagEmpty(targ)
    return tostring(targ:getChildSprites())  == '[]'
end
function HuntLineSheep.isHasTag(targ)
    return not HuntLineSheep.isTagEmpty(targ)
end



function HuntLineSheep.setTag(targ, int)

    targ:clearAttachedAnimSprite()

end
