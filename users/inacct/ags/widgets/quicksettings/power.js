import PowerService from "../../services/powerservice.js"
import { icons, settings } from "../../utils.js"

const PowerButton = (label) => Widget.Button({
  hexpand: true,
  child: Widget.Box({
    spacing: settings.spacing.standard,
    children: [
      Widget.Icon({
        icon: icons.power[label.toLowerCase()]
      }),
      Widget.Label(label),
    ],
  }),
  onClicked: () => PowerService.action(label.toLowerCase())
})

const Buttons = () => Widget.Box({
  vertical: true,
  spacing: settings.spacing.standard,
  children: [
    PowerButton("Sleep"),
    PowerButton("Logout"),
    PowerButton("Reboot"),
    PowerButton("Shutdown"),
  ],
})

const Verify = () => Widget.Box({
  vertical: true,
  vexpand: true,
  vpack: "center",
  spacing: settings.spacing.standard,
  children: [
    Widget.Label({
      label: PowerService.bind("title")
    }),
    Widget.Separator({}),
    Widget.Label("Are you sure you want to continue?"),
    Widget.Box({
      hexpand: true,
      hpack: "center",
      spacing: settings.spacing.major,
      homogeneous: true,
      children: [
        Widget.Button({
          label: "No",
          onClicked: () => PowerService.cancel(),
        }),
        Widget.Button({
          label: "Yes",
          onClicked: () => Utils.exec(PowerService.cmd),
        }),
      ]
    }),
  ],
})

// Export
const PowerStack = () => Widget.Stack({
  transition: "none",
  children: {
    Buttons: Buttons(),
    Verify: Verify(),
  },
  setup: self => {
    self.hook(PowerService, _ => {
      self.shown = "Verify"
    })
    self.hook(PowerService, _ => {
      self.shown = "Buttons"
    }, "canceled")
    self.hook(App, (_, wname, visible) => {
      if (wname === "quicksettings" && !visible)
      PowerService.cancel()
    }, "window-toggled")
  }
})

export default PowerStack
