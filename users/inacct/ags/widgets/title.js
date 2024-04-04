const hyprland = await Service.import('hyprland')

const WindowTitle = Widget.Box ({
    class_name: "bar-widget",
    vertical: true,
    children: [
        Widget.Label({
            class_name: "title-window",
            label: hyprland.active.client.bind("title").transform(title => title.length === 0 ? "Desktop" : title)
        }),
        Widget.Label({
            class_name: "title-program",
            label: hyprland.active.client.bind("class").transform(cls => cls.length === 0 ? "Desktop" : cls)
        }),
    ]
})

export default WindowTitle
