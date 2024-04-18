import { BarBox } from "../utils.js"

const timeVar = Variable("", {
    poll: [1000, ["date", "+%I:%M %p"]]
  })

const dateVar = Variable("", {
poll: [5000, ["date", "+%a %Y-%m-%d"]]
})

const Clock = BarBox([
    Widget.Label({
        class_name: "clock-time",
        hpack: "end",
        label: timeVar.bind()
    }),
    Widget.Label({
      class_name: "clock-date",
      hpack: "end",
      label: dateVar.bind()
    }),
], {
    css: "padding: 0 8px;",
    vertical: true
})

export default Clock
