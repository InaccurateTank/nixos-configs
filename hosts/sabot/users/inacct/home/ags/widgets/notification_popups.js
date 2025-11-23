import GLib from "gi://GLib";
import { settings } from "../utils.js"

const Notifications = await Service.import('notifications')

const PopupNotification = n => {
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
    vertical: true,
    spacing: settings.spacing.standard,
    children: [
      // Notification Header
      Widget.Label({
        class_name: n.urgency,
        hpack: "start",
        label: n.summary,
      }),

      // Content
      Widget.Box({
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
const NotificationPopups = () => Widget.Window({
  layer: "overlay",
  name: "popupNotifications",
  anchor: ["top"],
  margins: [4],
  child: Widget.Box({
    class_name: "popup-notifications-list",
    css: 'padding: 1px;',
    vertical: true,
    spacing: settings.spacing.standard,
    attribute: {
      map: new Map(),

      dismiss: (self, id) => {
        if (self.attribute.map.has(id)) {
          const notif = self.attribute.map.get(id)
          self.attribute.map.delete(id)
          Utils.timeout(200, () => {
            notif.destroy()
          })
        }
      },

      notify: (self, id) => {
        const notif = Notifications.getPopup(id)
        if (Notifications.dnd || !notif)
          return
        if (self.attribute.map.has(id)) {
          self.attribute.dismiss(id)
        }
        const popup = PopupNotification(notif)
        self.attribute.map.set(id, popup)
        self.children = [popup, ...self.children]
      }
    },
    // children: Notifications.bind("popups")
    //   .as(n => n.map(PopupNotification).flat().reverse()),
    setup: self => {
      self.hook(Notifications, (_, id) => self.attribute.notify(self, id), "notified")
      self.hook(Notifications, (_, id) => self.attribute.dismiss(self, id), "dismissed")
      self.hook(Notifications, (_, id) => self.attribute.dismiss(self, id), "closed")
    }
  }),
  visible: Notifications.bind("popups")
    .as(p => p.length > 0)
})

export default NotificationPopups
