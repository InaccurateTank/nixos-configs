import GLib from "gi://GLib";
import { icons } from "../../utils.js"

const Notifications = await Service.import('notifications')

const Notification = n => {
    let icon
    if (n.image) {
        icon = Widget.Box({
            hpack: "center",
            vpack: "center",
            css: `background-image: url('${n.image}');
                background-size: auto 100%;
                background-repeat: no-repeat;
                background-position: center;`,
        })
    } else if (Utils.lookUpIcon(n.app_icon)) {
        icon = Widget.Icon({
            hpack: "center",
            vpack: "center",
            icon: n.app_icon,
            size: 40,
        })
    }

    return Widget.Box({
        class_names: ["notification", n.urgency],
        vertical: true,
        spacing: 8,
        children: [
            // Notification Header
            Widget.CenterBox({
                startWidget: Widget.Label({
                    class_name: n.urgency,
                    hpack: "start",
                    label: n.summary,
                }),
                endWidget: Widget.Button({
                    class_name: "dismiss",
                    hpack: "end",
                    child: Widget.Icon(icons.exit),
                    onClicked: () => n.close()
                }),
            }),

            // Content
            Widget.Box({
                class_name: "ns-body",
                spacing: 8,
                children: [
                    icon,
                    Widget.Label({
                        vpack: "start",
                        hpack: "start",
                        xalign: 0,
                        justification: "left",
                        wrap: true,
                        label: n.body
                    })
                ]
            }),

            // Actions
            Widget.Box({
                spacing: 8,
                children: n.actions.map(action => Widget.Button({
                    hexpand: true,
                    child: Widget.Label(action.label),
                    on_clicked: () => n.invoke(action.id),
                }))
            }),

            // Notification Footer
            Widget.CenterBox({
                startWidget: Widget.Label({
                    class_name: "title-program",
                    hpack: "start",
                    label: n.app_name,
                }),
                endWidget: Widget.Label({
                    class_name: "title-program",
                    hpack: "end",
                    label: GLib.DateTime.new_from_unix_local(n.time).format("%Y-%m-%d %l:%M %p"),
                }),
            }),
        ]
    })
}

const List = () => Widget.Box({
    vertical: true,
    vexpand: true,
    spacing: 10,
    setup: self => self.hook(Notifications, self => {
        self.children = Notifications.notifications.reverse().map(Notification)
        self.visible = Notifications.notifications.length > 0
    }),
})

const Empty = () => Widget.Box ({
    vertical: true,
    vexpand: true,
    vpack: "center",
    visible: Notifications.bind("notifications").transform(n => n.length === 0),
    children: [
        Widget.Icon(icons.notification_empty),
        Widget.Label("Inbox is empty"),
    ]
})

// Export
const NoteList = () => Widget.Scrollable({
    hscroll: "never",
    vscroll: "automatic",
    child: Widget.Box({
        vertical: true,
        children: [
            List(),
            Empty(),
        ]
    }),
})

const NoteButtons = () => Widget.Box({
    hpack: "center",
    spacing: 20,
    children: [
        Widget.Button({
            class_name: "destructive-action",
            sensitive: Notifications.bind("notifications").transform(n => n.length > 0),
            child: Widget.Icon(icons.trash),
            onClicked: () => Notifications.clear(),
        }),
        Widget.Switch({
            vpack: "center",
            active: Notifications.bind("dnd").transform(dnd => !dnd),
            onActivate: ({active}) => Notifications.dnd = !active,
        }),
    ],
})

const NotificationWidgets = {
    NoteList,
    NoteButtons,
}

export default NotificationWidgets
