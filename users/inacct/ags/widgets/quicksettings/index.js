import { icons } from "../../utils.js"
import { AudioMenu, VolumeEntry } from "./audio.js"

const WINDOW_NAME = "quicksettings"
const state = Variable("Notifications")

// Menu Constructors
const QSMenuButton = (icon, pane) => {
    return Widget.Button({
        class_name: "qs-button",
        child: Widget.Icon({
            icon: icon,
            size: 20
        }),
        onClicked: () => state.value = pane,
    })
}

const QSPage = ({title, content = Widget.Box({})}) => Widget.Scrollable({
    class_name: "qs-page",
    vexpand: true,
    hexpand: true,
    hscroll: "never",
    vscroll: "automatic",
    child: Widget.Box({
        vertical: true,
        spacing: 10,
        children: [
            Widget.Label({
                class_name: "header",
                label: title
            }),
            Widget.Separator({}),
            content
        ]
    })
})

const NotificationsPage = QSPage({
    title: "Notifications",
})
const AudioPage = QSPage({
    title: "Audio",
    content: Widget.Box({
        vertical: true,
        spacing: 8,
        children: [
            VolumeEntry("sink"),
            VolumeEntry("source"),
            AudioMenu("sink"),
            AudioMenu("source")
        ]
    })
})
const NetworkPage = QSPage({
    title: "Network",
})
const PowerPage = QSPage({
    title: "Power",
})

const NotificationsButton = QSMenuButton(icons.notification, "Notifications")
const AudioButton = QSMenuButton(icons.audio.volume.high, "Audio")
const NetworkButton = QSMenuButton(icons.network.wired, "Network")
const PowerButton = QSMenuButton(icons.power.shutdown, "Power", true)

const SidebarButtons = Widget.Box({
    vertical: true,
    vexpand: true,
    children: [
        // Actual Quick Settings
        Widget.Box({
            vexpand: true,
            vpack: "center",
            vertical: true,
            children: [
                NotificationsButton,
                AudioButton,
                NetworkButton,
            ]
        }),

        // Other Buttons
        Widget.Box({
            vertical: true,
            children: [
                PowerButton
            ]
        })
    ]
})

const Stack = Widget.Stack({
    transition: "over_left",
    children: {
        Notifications: NotificationsPage,
        Audio: AudioPage,
        Network: NetworkPage,
        Power: PowerPage,
    },
    shown: state.bind()
})

const QSContent = Widget.Box({
    class_name: "qs-content",
    children: [
        Stack,
        SidebarButtons,
    ]
})

const QSRevealer = Widget.Revealer({
    transition: "slide_left",
    transition_duration: 500,
    setup: self => self.hook(App, (_, wname, visible) => {
        if (wname === WINDOW_NAME)
            self.reveal_child = visible
    }),
    child: QSContent
})

const QuickSettings = Widget.Window({
    class_name: "popup-window",
    keymode: "on-demand",
    visible: false,
    anchor: ["right", "top", "bottom"],
    name: WINDOW_NAME,
    margins: [6, 0],
    child: Widget.Box({
        css: "padding: 1px;",
        child: QSRevealer
    }),
    setup: self => {
        self.keybind("Escape", () => App.closeWindow(self.name))
    }
})

export default QuickSettings
