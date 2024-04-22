import Bar from "./widgets/bar.js"
import QuickSettings from "./widgets/quicksettings/index.js"
import Launcher from "./widgets/launcher/index.js"

App.config({
  style: "./css/main.css",
  icons: "./assets",
  windows: [
    Bar(),
    QuickSettings(),
    Launcher(),
  ],
  closeWindowDelay: {
    quicksettings: 350,
    launcher: 350,
  }
})
