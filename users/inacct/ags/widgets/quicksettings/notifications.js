import GLib from "gi://GLib";
import { icons, settings } from "../../utils.js"

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
    spacing: settings.spacing.standard,
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
        spacing: settings.spacing.standard,
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
        spacing: settings.spacing.standard,
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

// Export
const NoteList = () => {
  const list = Widget.Box({
    vertical: true,
    vexpand: true,
    spacing: settings.spacing,
    children: Notifications.bind("notifications")
      .as(n => n.map(Notification).flat().reverse())
  })

  const empty = Widget.Box ({
    vertical: true,
    vexpand: true,
    vpack: "center",
    children: [
      Widget.Icon(icons.notifications.disabled),
      Widget.Label("Inbox is empty"),
    ]
  })

  return Widget.Scrollable({
    hscroll: "never",
    vscroll: "automatic",
    child: Widget.Stack({
      transition: "none",
      children: {
        List: list,
        Empty: empty,
      },
      shown: Notifications.bind("notifications")
        .as(n => n.length === 0 ? "Empty" : "List")
    }),
  })
}

const NoteButtons = () => Widget.Box({
  hpack: "center",
  spacing: settings.spacing.major,
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
