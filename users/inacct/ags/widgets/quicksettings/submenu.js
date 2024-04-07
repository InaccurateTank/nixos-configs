const SubMenu = ({title, icon, content}) => Widget.Box({
  class_name: "qs-submenu",
  vertical: true,
  spacing: 8,
  children: [
      Widget.Box({
          spacing: 8,
          children: [
              Widget.Icon({
                  size: 14,
                  icon
              }),
              Widget.Label(title),
          ]
      }),
      Widget.Separator({vertical: false}),
      content,
  ]
})

export default SubMenu
