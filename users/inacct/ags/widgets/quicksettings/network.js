import { Capitalize, icons } from "../../utils.js"
import SubMenu from "./submenu.js"

const Network = await Service.import('network')

// Desktop has no wifi so this is more future placeholder than anything...
const NetworkEntry = ap => Widget.Box({
    children: [
        Widget.Icon({
            icon: ap.icon_name
        }),
        Widget.Label({
            label: ap.ssid
        }),
    ]
})

// Export
const WifiMenu = () => SubMenu({
    title: "Wifi",
    icon: Network.wifi.bind("icon_name"),
    content: Widget.Box({
        visible: Network.wifi.bind("enabled"),
        vertical: true,
        hexpand: true,
        setup: self => self.hook(Network.wifi, self => {
            if (self.visible) {
                self.children = Array.from(Network.wifi.access_points.sort((a, b) => b.strength - a.strength)
                    .map(NetworkEntry))
            }
        }),
    }),
    toggle: {
        active: Network.wifi.bind("enabled"),
        onActivate: ({ active }) => {
            Network.wifi.enabled = active
        },
        // setup: self => {print(self.sensitive)}
        setup: self => self.hook(Network.wifi, self => {
            const down = Network.wifi.state === "unknown" || "unmanaged"
            if (down)
                Network.wifi.enabled = false
            self.sensitive = !down
        }, "notify::state")
    }
})

const PrimaryNetwork = () => Widget.Box({
    hexpand: true,
    vertical: true,
    spacing: 8,
    children: [
        Widget.Box({
            hexpand: true,
            children: [
                Widget.Label("Type:"),
                Widget.Label({
                    hpack: "end",
                    hexpand: true,
                    label: Network.bind("primary").transform(net => Capitalize(net))
                }),
            ]
        }),
        Widget.Box({
            hexpand: true,
            children: [
                Widget.Label("State:"),
                Widget.Label({
                    hpack: "end",
                    hexpand: true,
                    label: Network[Network.primary].bind("internet").transform(net => Capitalize(net))
                }),
            ]
        }),
        Widget.Box({
            hexpand: true,
            children: [
                Widget.Label("Connectivity:"),
                Widget.Label({
                    hpack: "end",
                    hexpand: true,
                    label: Network.bind("connectivity").transform(net => Capitalize(net))
                }),
            ]
        }),
        Widget.Button({
            hexpand: true,
            onClicked: () => Utils.execAsync(["nm-connection-editor"]),
            child: Widget.Label("Advanced Settings")
        }),
    ]
})

const NetworkWidgets = {
    PrimaryNetwork,
    WifiMenu
}

export default NetworkWidgets
