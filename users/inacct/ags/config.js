import Launcher from "./widgets/launcher.js"
import Bar from "./widgets/bar.js"
import QuickSettings from "./widgets/quicksettings/index.js"

App.config({
    style: "./css/main.css",
    icons: "./assets",
    windows: [
      Bar,
      Launcher,
      QuickSettings
    ],
})
