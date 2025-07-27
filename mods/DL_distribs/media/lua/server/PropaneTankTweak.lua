local item = ScriptManager.instance:getItem("Base.PropaneTank");
if item then
  item:DoParam("KeepOnDeplete = true");
end