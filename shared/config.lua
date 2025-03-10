return {
    target = {
        distance = 5.0,
        label = 'Rob NPC',
        icon = 'fas fa-gun',
    },

    progresscircle = {
        duration = 10000,
        label = 'Searching pockets...',
        position = 'bottom',
        anim = {
            dict = 'random@shop_robbery',
            clip = 'robbery_action_a',
        },
    },

    rewards = {
        money = math.random(250, 850),
    },
}