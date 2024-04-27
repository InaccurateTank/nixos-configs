import { BarBox, distro } from "../../utils.js"

const hyprland = await Service.import('hyprland')

const WindowTitle = BarBox([
  Widget.Label({
    class_name: "title-window",
    label: hyprland.active.client.bind("title").transform(title => title.length === 0 ? "Desktop" : title)
  }),
  Widget.Label({
    class_name: "title-program",
    label: hyprland.active.client.bind("class").transform(cls => cls.length === 0 ? distro : cls)
  }),
], {
  vertical: true
})

export default WindowTitle
