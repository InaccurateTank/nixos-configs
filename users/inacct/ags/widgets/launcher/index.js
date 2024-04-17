import { icons, settings } from "../../utils.js"
import Popup from "../popupwindow.js"

const Applications = await Service.import("applications")

const AppButton = app => Widget.Button({
    hexpand: true,
    child: Widget.Box({
        spacing: 8,
        children: [
            Widget.Icon({
                icon: app.icon_name,
                size: 30,
            }),
            Widget.Label({
                hpack: "start",
                truncate: "end",
                label: app.name
            }),
        ],
    }),
    onClicked: () => {
        app.launch()
        App.closeWindow("launcher")
    },
    tooltip_text: app.description,
})

// Export
const Launcher = () => {
    const list_box = Widget.Box({
        vertical: true,
        vexpand: true,
        spacing: 8,
    })

    const entry = Widget.Entry({
        hexpand: true,
        placeholder_text: "Search...",
        primary_icon_name: icons.search,
        onAccept: ({text}) => {
            const list = Applications.query(text)
            if (list[0]) {
                App.toggleWindow("launcher")
                list[0].launch()
            }
        },
        onChange: ({text}) => {
            list_box.children = Applications.query(text)
                .map(AppButton)
                .flat()
            list_box.show_all()
        },
    })

    return Popup.Window({
        name: "launcher",
        margins: [settings.margin, 0],
        layout: "left",
        child_box: {
            children: [
                Widget.Box({
                    class_name: "launcher",
                    vertical: true,
                    spacing: 8,
                    children: [
                        // Header
                        Widget.Label({
                            class_name: "header",
                            label: "Applications",
                        }),
                        Widget.Separator(),

                        // Search
                        entry,

                        // Scrollable List
                        Widget.Scrollable({
                            hscroll: "never",
                            vscroll: "automatic",
                            child: list_box,
                        }),
                    ],
                }),
            ],
            setup: self => self.hook(App, (_, wname, visible) => {
                if (wname === "launcher" && visible) {
                    entry.set_text("-")
                    entry.set_text("")
                    entry.grab_focus()
                }
            }, "window-toggled"),
        },
    })
}

export default Launcher
