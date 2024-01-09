
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