import { launcher } from "./launcher.js"

const launcherButton = Widget.Button({
  child: Widget.Icon({
    icon: 'nix-snowflake-symbolic',
    size: 20,
  }),
  onClicked: () => App.toggleWindow("launcher"),
})

const bar = Widget.Window({
  name: 'bar',
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  margins: 4,
  child: launcherButton,
})

App.addIcons(`${App.configDir}/assets/`)

App.config({
    windows: [
      bar,
      launcher
    ],
})
