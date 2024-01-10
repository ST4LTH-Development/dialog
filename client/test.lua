
RegisterCommand('deleteped', function()
    DeletePedByID('test')
end, false)

RegisterCommand('spawnped', function()
    SpawnPedByID('test', {
        label = 'Talk to stranger',
        icon = 'fa-solid fa-comment',
        model = "csb_avon",
        coords = vector3(165.48, 6612.81, 31.9),
        heading = 170,
        data = {
            firstname = 'John',
            lastname = 'Doe',
            text = 'Hey bud, how ya doin.',
            buttons = {
                { 
                    text = 'Im ok, how are you?',
                    data = {
                        text = 'Im cool rn, see you around!',
                        buttons = {
                            {
                                text = 'Se ya',
                                close = true
                            },
                        }
                    } 
                },
                { 
                    text = 'No sorry, im gonna leave', 
                    close = true 
                },
            }
        }
    })
end, false)

RegisterNetEvent('con:mechanic', function(ped)
    rep = 1
    data = {
        firstname = 'John',
        lastname = 'Doe',
        text = 'Hey bud, what can i do for you',
        type = 'Mechanic',
        rep = rep,
        buttons = {
            { text = "I wanna clock in", data = {
                text = 'Alright',
                buttons = {
                    { text = 'Clock in/out', event = 'con:clockin', close = true },
                    { text = 'Whatever, changed my mind', event = 'con:back' },
                }
            }},
            { text = "I'm gonna leave", close = true },
        }
    }
    OpenDialog(ped, data)
end)

RegisterNetEvent('con:back', function()
    data = {
        firstname = 'John',
        lastname = 'Doe',
        text = 'Hey bud, what can i do for you',
        type = 'Mechanic',
        rep = '2',
        buttons = {
            { text = "I wanna clock in", data = {
                    text = 'Alright',
                    buttons = {
                        { text = 'Clock in/out', event = 'con:clockin', close = true },
                        { text = 'Whatever changed my mind', event = 'con:back' },
                    }
                }
            },
            { text = "I'm gonna leave", close = true },
        }
    }

    SetDialog(data)
end)

RegisterNetEvent('con:clockin', function()
    print('123')
    TriggerEvent('QBCore:Notify', "clocked in", 'success')
end)