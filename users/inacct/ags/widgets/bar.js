import Gtk from "gi://Gtk?version=3.0"
import Clock from "./clock.js"
import SysTray from "./systray.js"
import Workspaces from "./workspaces.js"
import WindowTitle from "./title.js"

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

const launcherButton = Widget.Box({
    class_names: ["bar-widget", "launcher-button"],
    child: Widget.Button({
        child: Widget.Icon({
            icon: 'nixos-symbolic',
            size: 20,
            css: 'color: #d5d8da; border: 0;'
          }),
        onClicked: () => App.toggleWindow("launcher"),
    })
})

const StartBox = Widget.Box({
    children: [
        launcherButton,
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
        Clock,
    ],
})

const Bar = Widget.Window({
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
