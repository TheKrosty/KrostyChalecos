MyProofs = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj 
		end)
		Citizen.Wait(0)
	end
end)


function OpenProofsMenu()
	TriggerServerEvent('Proofs:GetProofs')
	local elements = {
		{label = 'Mis Chalecos', value = '1'},
		{label = 'Comprar Chalecos', value = '2'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mainmenu', {
		title    = 'Chalecos',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == '1' then
			OpenOwnedProofsMenu()
		elseif data.current.value == '2' then 
			OpenBuyProofsMenu()

		end
	end)
end

function OpenOwnedProofsMenu()
	local elements = {}


	for i=1,#Config.Proofs do
		if MyProofs[i] then
			table.insert(elements, {label = Config.Proofs[i].name, value = i})
		end
	end

	ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'myproofs', {
        title    = 'Mis Chalecos',
        align    = 'bottom-right',
        elements = elements
    }, function(data, menu)
        SetPedComponentVariation(PlayerPedId(), 9, Config.Proofs[data.current.value].id, Config.Proofs[data.current.value].texture, 0)
    end)
end

function OpenBuyProofsMenu()
	local elements = {}

	for i=1,#Config.Proofs do
		if not Config.Proofs[i].exclusive and not MyProofs[i] then 
			table.insert(elements, {label = Config.Proofs[i].name.. ' <span style="color:green;">$'..Config.Proofs[i].price..'</span>', value = i})
		end
	end

	if not elements[1] then 
		table.insert(elements, {label = '<span style="color:#67009e;">Ya tienes todos los chalecos!</span>', value = ''})
	end
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buyproofs', {
		title    = 'Comprar Chalecos',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('Proofs:BuyProofs', data.current.value)
	end)
end

Citizen.CreateThread(function()
    for k,v in ipairs(Config.Commands) do
        RegisterCommand(v, function(source, args, rawCommand)
            OpenProofsMenu()
        end, false)
    end
end)

RegisterCommand('chalecos', function()
	OpenProofsMenu()
end)



Citizen.CreateThread(function()
	while true do
		Wait(5)
		if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mainmenu') then 
			if IsControlJustPressed(0, 202) then 
				ESX.UI.Menu.CloseAll()
			end
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'myproofs') or ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'buyproofs') then 
			if IsControlJustPressed(0, 202) then 
				OpenProofsMenu()
			end
		end
	end
end)



RegisterNetEvent('Proofs:AddProofs')
AddEventHandler('Proofs:AddProofs', function(proofs)
	print(proofs)
	MyProofs[proofs] = true 
end)