
require "lua_timers"
HuntLineRat = HuntLineRat or {}



function HuntLineRat.removeTag(targ)
    targ:clearAttachedAnimSprite()
end
function HuntLineRat.isTagEmpty(targ)
    return tostring(targ:getChildSprites())  == '[]'
end
function HuntLineRat.isHasTag(targ)
    return not HuntLineRat.isTagEmpty(targ)
end



function HuntLineRat.setTag(targ, int)

    targ:clearAttachedAnimSprite()

end
