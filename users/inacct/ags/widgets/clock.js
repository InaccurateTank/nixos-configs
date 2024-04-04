const timeVar = Variable("", {
  poll: [1000, ["date", "+%H:%M %p"]]
})

const dateVar = Variable("", {
poll: [5000, ["date", "+%a %Y-%m-%d"]]
})

const Clock = Widget.EventBox({
  child: Widget.Box({
    class_names: ["clock", "bar-widget"],
    vertical: true,
    children: [
      Widget.Label({
        class_name: "clock-date",
        hpack: "end",
        label: dateVar.bind()
      }),
      Widget.Label({
        class_name: "clock-time",
        hpack: "end",
        label: timeVar.bind()
      }),
    ],
  })
})

export default Clock
