import Gtk from "gi://Gtk?version=3.0"
import { BarBox, icons } from "../utils.js"
import Clock from "./clock.js"
import SysTray from "./systray.js"
import Workspaces from "./workspaces.js"
import WindowTitle from "./title.js"
import AudioWidgets from "./quicksettings/audio.js"

const Network = await Service.import('network')
const Notifications = await Service.import('notifications')
const Audio = await Service.import('audio')

const BarCorner = (place) => Widget.DrawingArea({
  class_name: "bar-widget",
  setup: widget => {
    const h = widget.get_allocated_height()
    const w = h / 2
    widget.set_size_request(w, h);
    widget.on("draw", (widget, cr) => {
      const context = widget.get_style_context()
      const c = context.get_property("background-color", Gtk.StateFlags.NORMAL)
      const border_color = context.get_border_color(Gtk.StateFlags.NORMAL)
      const border_width = context.get_border(Gtk.StateFlags.NORMAL).bottom
      const h = widget.get_allocated_height()
      const w = h / 2
      widget.set_size_request(w, h)
      switch (place) {
        case "left":
          // Fill
          cr.moveTo(0,0)
          cr.lineTo(w, 0)
          cr.lineTo(w, h)
          cr.lineTo(0, h / 2)
          cr.closePath()
          cr.setSourceRGBA(c.red, c.green, c.blue, c.alpha)
          cr.fillPreserve()
          cr.clip()

          // Border
          cr.moveTo(0, 0)
          cr.lineTo(0, h / 2)
          cr.lineTo(w, h)
          cr.setLineWidth(border_width * 2)
          cr.setSourceRGBA(border_color.red, border_color.green, border_color.blue, border_color.alpha)
          cr.stroke()
          break
        case "right":
          // Fill
          cr.moveTo(0,0)
          cr.lineTo(w, 0)
          cr.lineTo(w, h / 2)
          cr.lineTo(0, h)
          cr.closePath()
          cr.setSourceRGBA(c.red, c.green, c.blue, c.alpha)
          cr.fillPreserve()
          cr.clip()

          // Border
          cr.moveTo(0, h)
          cr.lineTo(w, h / 2)
          cr.lineTo(w, 0)
          cr.setLineWidth(border_width * 2)
          cr.setSourceRGBA(border_color.red, border_color.green, border_color.blue, border_color.alpha)
          cr.stroke()
          break
      }
    })
  }
})

const LauncherButton = BarBox([
  Widget.Button({
    class_name: "bar-button",
    child: Widget.Icon({
        icon: 'nixos-symbolic',
        size: 20,
      }),
    onClicked: () => App.toggleWindow("launcher"),
  })
])

const QuickSettingsButton = BarBox([
  Widget.Button({
    class_name: "qs-button",
    child: Widget.Box({
      spacing: 4,
      children: [
        Widget.Icon({
          icon: Notifications.bind("dnd").as(dnd => dnd ? icons.notifications.disabled : icons.notifications.enabled)
        }),
        Widget.Icon().hook(Audio, self => {
          self.icon = AudioWidgets.AudioIcon("sink")
        }, "speaker-changed"),
        Widget.Icon().hook(Audio, self => {
          self.icon = AudioWidgets.AudioIcon("source")
        }, "microphone-changed"),
        Widget.Icon({
          icon: Network[Network.primary].bind("icon_name")
        }),
      ],
    }),
    onClicked: () => App.toggleWindow("quicksettings"),
  })
])

const StartBox = Widget.Box({
  children: [
    LauncherButton,
    Workspaces,
    BarCorner("right"),
  ],
})

const CenterBox = Widget.Box({
  children: [
    BarCorner("left"),
    WindowTitle,
    BarCorner("right"),
  ],
})

const EndBox = Widget.Box({
  hpack: "end",
  children: [
    BarCorner("left"),
    SysTray,
    QuickSettingsButton,
    Clock,
  ],
})

const Bar = () => Widget.Window({
  name: 'bar',
  class_name: "bar",
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  child: Widget.CenterBox({
    startWidget: StartBox,
    centerWidget: CenterBox,
    endWidget: EndBox,
  }),
})

export default Bar
