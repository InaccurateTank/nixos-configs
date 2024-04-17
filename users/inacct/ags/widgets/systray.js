import { BarBox } from "../utils.js";

const systemtray = await Service.import("systemtray")

const SysTrayItem = item => Widget.Button({
    class_name: "bar-button",
    child: Widget.Icon().bind('icon', item, 'icon'),
    tooltipMarkup: item.bind('tooltip_markup'),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
});

const SysTray = BarBox(systemtray.bind('items').as(i => i.map(SysTrayItem)))

export default SysTray
