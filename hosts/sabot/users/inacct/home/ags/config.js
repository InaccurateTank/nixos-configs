import Bar from "./widgets/bar/index.js"
import QuickSettings from "./widgets/quicksettings/index.js"
import Launcher from "./widgets/launcher/index.js"
import NotificationPopups from "./widgets/notification_popups.js"

App.config({
  style: "./css/main.css",
  icons: "./assets",
  windows: [
    Bar(),
    QuickSettings(),
    Launcher(),
    NotificationPopups(),
  ],
  closeWindowDelay: {
    quicksettings: 350,
    launcher: 350,
  }
})
