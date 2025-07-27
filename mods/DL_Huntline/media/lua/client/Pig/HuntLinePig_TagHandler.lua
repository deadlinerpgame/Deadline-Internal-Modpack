
require "lua_timers"
HuntLinePig = HuntLinePig or {}



function HuntLinePig.removeTag(targ)
    targ:clearAttachedAnimSprite()
end
function HuntLinePig.isTagEmpty(targ)
    return tostring(targ:getChildSprites())  == '[]'
end
function HuntLinePig.isHasTag(targ)
    return not HuntLinePig.isTagEmpty(targ)
end



function HuntLinePig.setTag(targ, int)

    targ:clearAttachedAnimSprite()

end
