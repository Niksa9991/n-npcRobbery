local Config = lib.require('shared/config')

local function Requirements(entity)
    return IsPedArmed(cache.ped, 7) and not IsEntityDead(entity) and IsPedHuman(entity) and not cache.vehicle
end

local function Animation(entity)
    if not lib.requestAnimDict('random@mugging3') then
        return
    end

    ClearPedTasksImmediately(entity)
    SetBlockingOfNonTemporaryEvents(entity, true)
    TaskStandStill(entity, Config.progresscircle.duration)
    FreezeEntityPosition(entity, true)
    lib.playAnim(entity, 'random@mugging3', 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)
end

local function RobberyFailed(entity)
    FreezeEntityPosition(entity, false)
    ClearPedTasksImmediately(entity)
    SetBlockingOfNonTemporaryEvents(entity, false)
    lib.notify({ title = 'Notification', description = 'Robbery failed', duration = 5000, type = 'error' })
end

local function RobberySuccess(entity)
    FreezeEntityPosition(entity, false)
    ClearPedTasksImmediately(entity)
    SetBlockingOfNonTemporaryEvents(entity, false)

    lib.callback('robbery:reward', false, function(success)
        if success then
            lib.notify({ title = 'Notification', description = 'Robbery success', duration = 5000, type = 'success' })
        end
    end)
end

local function PoliceDispatch()
    exports['aty_dispatch']:SendDispatch(
        'Armed robbery in progress', 
        '10-68', 
        461,
        {'police', 'sheriff'}, 
        'beep.mp3'
    )
end

local function StartRobbery(entity)
    PoliceDispatch()
    Animation(entity)
    
    local success = lib.progressCircle({
        duration = Config.progresscircle.duration,
        label = Config.progresscircle.label,
        position = Config.progresscircle.position,
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true },
        anim = { dict = Config.progresscircle.anim.dict, clip = Config.progresscircle.anim.clip },
    })

    if success then
        RobberySuccess(entity)
    else
        RobberyFailed(entity)
    end
end

exports.ox_target:addGlobalPed({
    {
        name = 'add_target',
        icon = Config.target.icon,
        label = Config.target.label,
        distance = Config.target.distance,
        canInteract = function(entity)
            return Requirements(entity)
        end,
        onSelect = function(data)
            StartRobbery(data.entity)
        end,
    }
})