AcceptItemFunction = AcceptItemFunction or {}

function AcceptItemFunction.Anvil(container, item)
    return item ~= nil and item:hasTag("DLIngot")
end
