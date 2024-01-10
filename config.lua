Config = {
    FrameworkLoadinEvent = 'QBCore:Client:OnPlayerLoaded',
    peds = {
--[[         ['test'] = {
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
        }, ]]
        ['test2'] = {
            label = 'Talk to the Mechanic',
            icon = 'fa-solid fa-comment',
            model = "mp_m_waremech_01",
            coords = vector3(164.09, 6614.43, 31.92),
            heading = 90,
            event = 'con:mechanic'
        },
    }
}