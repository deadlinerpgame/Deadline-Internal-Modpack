
require "lua_timers"
HuntLineRabbit = HuntLineRabbit or {}



function HuntLineRabbit.removeTag(targ)
    targ:clearAttachedAnimSprite()
end
function HuntLineRabbit.isTagEmpty(targ)
    return tostring(targ:getChildSprites())  == '[]'
end
function HuntLineRabbit.isHasTag(targ)
    return not HuntLineRabbit.isTagEmpty(targ)
end



function HuntLineRabbit.setTag(targ, int)

    targ:clearAttachedAnimSprite()

end
