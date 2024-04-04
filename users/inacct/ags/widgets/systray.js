const systemtray = await Service.import("systemtray")

const SysTrayItem = item => Widget.Button({
    child: Widget.Icon().bind('icon', item, 'icon'),
    tooltipMarkup: item.bind('tooltip_markup'),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
});

const SysTray = Widget.Box({
    class_name: "bar-widget",
    children: systemtray.bind('items').as(i => i.map(SysTrayItem))
})

export default SysTray
