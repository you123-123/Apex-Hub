--[[ APEX Autofarm splits merged - 3 -> 1 ]]

-- === QUEST ===
local A=_G.Apex or {}
A.FarmQuest={}
function A.FarmQuest.Accept(id) return A.Farm and A.Farm.AcceptQuest and A.Farm.AcceptQuest(id) end
-- no return

-- === COMBAT ===
local A=_G.Apex or {}
A.FarmCombat={}
function A.FarmCombat.Attack(mob) return A.Combat and A.Combat.Attack and A.Combat.Attack(mob) end
-- no return

-- === STUCK ===
local A=_G.Apex or {}
A.FarmStuck={}
function A.FarmStuck.Check() return A.Farm and A.Farm.CheckStuck and A.Farm.CheckStuck() end
return A -- final
