
require "lua_timers"
HuntLineCow = HuntLineCow or {}



function HuntLineCow.removeTag(targ)
    targ:clearAttachedAnimSprite()
end
function HuntLineCow.isTagEmpty(targ)
    return tostring(targ:getChildSprites())  == '[]'
end
function HuntLineCow.isHasTag(targ)
    return not HuntLineCow.isTagEmpty(targ)
end



function HuntLineCow.setTag(targ, int)

    targ:clearAttachedAnimSprite()

end
