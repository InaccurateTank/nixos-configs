import { launcher } from "./launcher.js"

const launcherButton = Widget.Button({
  child: Widget.Icon({
    icon: 'nixos-symbolic',
    size: 20,
    css: 'color: #d5d8da;'
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
