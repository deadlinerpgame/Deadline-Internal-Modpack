
require "lua_timers"
HuntLineDeer = HuntLineDeer or {}



function HuntLineDeer.removeTag(targ)
    targ:clearAttachedAnimSprite()
end
function HuntLineDeer.isTagEmpty(targ)
    return tostring(targ:getChildSprites())  == '[]'
end
function HuntLineDeer.isHasTag(targ)
    return not HuntLineDeer.isTagEmpty(targ)
end



function HuntLineDeer.setTag(targ, int)

    targ:clearAttachedAnimSprite()

end
