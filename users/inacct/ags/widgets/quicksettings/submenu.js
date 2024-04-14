const SubMenu = ({title, icon, content, toggle}) => {
  let header_children = [
      Widget.Icon({
          size: 14,
          icon
      }),
      Widget.Label(title),
  ]
  if (toggle)
      header_children.push(Widget.Switch({
          hpack: "end",
          hexpand: true,
          ...toggle,
      }))

  return Widget.Box({
      class_name: "qs-submenu",
      hexpand: true,
      vertical: true,
      spacing: 8,
      children: [
          Widget.Box({
              spacing: 8,
              children: header_children,
          }),
          Widget.Separator({vertical: false}),
          content,
      ],
  })
}

export default SubMenu
