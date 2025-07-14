import { icons, settings } from "../../utils.js"
import Popup from "../popupwindow.js"
import AudioWidgets from "./audio.js"
import NetworkWidgets from "./network.js"
import NotificationWidgets from "./notifications.js"
import PowerStack from "./power.js"

const Notifications = await Service.import('notifications')
const Audio = await Service.import('audio')
const Network = await Service.import('network')

const qs_state = Variable("Notifications")

// Menu Constructors
const QSPage = ({title, content = {}, scrollable = true}) => {
  const children = [
    Widget.Label({
      class_name: "header",
      label: title
    }),
    Widget.Separator({}),
    Widget.Box({
      vertical: true,
      spacing: 8,
      ...content,
    }),
  ]

  if (scrollable) {
    return Widget.Scrollable({
      class_name: "stack-pane",
      hscroll: "never",
      vscroll: "automatic",
      child: Widget.Box({
        vertical: true,
        spacing: 8,
        children
      })
    })
  } else {
    return Widget.Box({
      class_name: "stack-pane",
      vertical: true,
      spacing: 8,
      children
    })
  }
}

const NotificationsPage = QSPage({
  title: "Notifications",
  content: {
    children: [
      NotificationWidgets.NoteList(),
      Widget.Separator(),
      NotificationWidgets.NoteButtons(),
    ]
  },
  scrollable: false,
})
const AudioPage = QSPage({
  title: "Audio",
  content: {
    children: [
      AudioWidgets.VolumeEntry("sink"),
      AudioWidgets.VolumeEntry("source"),
      AudioWidgets.AudioMenu("sink"),
      AudioWidgets.AudioMenu("source"),
      AudioWidgets.MixerMenu(),
    ]
  },
})
const NetworkPage = QSPage({
  title: "Network",
  content: {
    children: [
      NetworkWidgets.PrimaryNetwork(),
      NetworkWidgets.WifiMenu(),
    ]
  },
})
const PowerPage = QSPage({
  title: "Power",
  content: {
    children: [
      PowerStack(),
    ]
  },
})

const Stack = () => Widget.Stack({
  transition: "over_left",
  children: {
    Notifications: NotificationsPage,
    Audio: AudioPage,
    Network: NetworkPage,
    Power: PowerPage,
  },
  shown: qs_state.bind()
})

// Export
const QuickSettings = () => Popup.Window({
  name: "quicksettings",
  margins: [settings.margin, 0],
  layout: "right",
  child_box: {
    children: [
      Stack(),
      Popup.Bar({
        layout: "right",
        centerButtons: [
          Popup.BarButton(qs_state,
            {
              icon: Notifications.bind("dnd")
                .transform(dnd => dnd ? icons.notifications.disabled : icons.notifications.enabled)
            }, "Notifications"),
          Popup.BarButton(qs_state,
            {
              setup: self => self.hook(Audio, _ => {
                self.icon = AudioWidgets.AudioIcon("sink")
              }, "speaker-changed")
            }, "Audio"),
          Popup.BarButton(qs_state,
            {
              icon: Network[Network.primary].bind("icon_name")
            }, "Network"),
        ],
        endButtons: [
          Popup.BarButton(qs_state,
            {
              icon: icons.power.shutdown
            }, "Power"),
        ],
      }),
    ]
  }
})

export default QuickSettings
