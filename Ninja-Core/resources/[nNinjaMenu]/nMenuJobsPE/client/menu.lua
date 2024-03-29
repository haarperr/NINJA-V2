--||@SuperCoolNinja.||--
local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Offre Emplois", "")
_menuPool:Add(mainMenu)

function AddMenuJobMenu(menu)

		--------------||SOUS MENU||----------------
		local submenu = _menuPool:AddSubMenu(menu, "~h~Emplois disponible", "")

		--------------||EVENT AUTRES||----------------
		local chome = NativeUI.CreateItem("Chômage", "")
		local testJob = NativeUI.CreateItem("Police", "")
		local ambuItem = NativeUI.CreateItem("Ambulancier", "")
		
		submenu.SubMenu:AddItem(chome)
		submenu.SubMenu:AddItem(testJob)
		submenu.SubMenu:AddItem(ambuItem)

		--------------||Selection LISTE JOBS||----------------
		submenu.SubMenu.OnItemSelect = function(menu, item)

		if item == chome then
			TriggerServerEvent("vMenu:UpdateServerjobs", 1)
		elseif item == testJob then
			TriggerServerEvent("vMenu:UpdateServerjobs", 2)
			TriggerServerEvent("vPolice:OnJoin")
		elseif item == ambuItem then
			TriggerServerEvent("vMenu:UpdateServerjobs", 3)
			TriggerServerEvent("nMedics:OnJoin")
		end
	end
end

AddMenuJobMenu(mainMenu)
_menuPool:MouseEdgeEnabled (false);
_menuPool:RefreshIndex()