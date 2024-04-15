// Utilities to help in the creation of popup windows

const Layout = Object.freeze({
  left: {
      anchor: ["left", "top", "bottom"],
      class_name: "left",
      transition: "slide_right",
  },
  right: {
      anchor: ["right", "top", "bottom"],
      class_name: "right",
      transition: "slide_left",
  },
  center: {
      anchor: [],
      class_name: "center",
      transition: "crossfade",
  }
})

// Exports
const BarButton = (stack_variable, icon, pane) => Widget.Button({
  child: Widget.Icon({
      icon,
      size: 16
  }),
  onClicked: () => {stack_variable.value = pane},
  setup: self => self.hook(stack_variable, self => {
      self.toggleClassName("current", stack_variable.value === pane);
  })
})

const Bar = ({
  layout,
  startButtons = [],
  centerButtons = [],
  endButtons = [],
  ...props
}) => {
  const vertical = !(Layout[layout] === Layout.center)
  return Widget.CenterBox({
      class_names: ["popup-bar", Layout[layout].class_name],
      vertical,
      vexpand: vertical,
      hexpand: Layout[layout] === Layout.center,
      startWidget: Widget.Box({
          vertical,
          children: startButtons
      }),
      centerWidget: Widget.Box({
          vertical,
          children: centerButtons
      }),
      endWidget: Widget.Box({
          vertical,
          vpack: "end",
          children: endButtons
      }),
      ...props,
  })
}

const Window = ({
  name,
  margins,
  layout = "center",
  child_box = {},
  extra_props = {},
}) => Widget.Window({
  ...extra_props,
  name,
  anchor: Layout[layout].anchor,
  margins,
  class_name: "popup-window",
  keymode: "on-demand",
  visible: false,
  // Revealer doesn't work without default size
  child: Widget.Box({
      css: "padding: 1px;",
      child: Widget.Revealer({
          reveal_child: false,
          transition: Layout[layout].transition,
          transition_duration: 350,
          setup: self => self.hook(App, (_, wname, visible) => {
              if (wname === name)
                  self.reveal_child = visible
          }, "window-toggled"),
          child: Widget.Box({
              class_names: ["popup-content", Layout[layout].class_name],
              ...child_box
          }),
      })
  }),
  setup: self => self.keybind("Escape", () => App.closeWindow(name))
})

const Popup = {
  Window,
  Bar,
  BarButton,
}

export default Popup
