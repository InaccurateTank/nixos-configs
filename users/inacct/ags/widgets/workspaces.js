const hyprland = await Service.import('hyprland')

const WorkspaceButton = (ws) => Widget.EventBox({
    on_primary_click_release: () => hyprland.messageAsync(`dispatch workspace ${ws}`)
        .catch(logError),
    child: Widget.Label(`${ws}`)
}).hook(hyprland.active.workspace, button => {
    button.toggleClassName("active", hyprland.active.workspace.id === ws);
})

const Workspaces = Widget.EventBox({
    child: Widget.Box({
      class_names: ["bar-widget", "ws-container"],
      children: Array.from({length: 10}, (_, i) => i + 1).map(i => WorkspaceButton(i)),
    })
      .hook(hyprland, box => {
        box.children.forEach((button, i) => {
          const ws = hyprland.getWorkspace(i + 1);
          const ws_before = hyprland.getWorkspace(i);
          const ws_after = hyprland.getWorkspace(i + 2);
          //toggleClassName is not part od Gtk.Widget, but we know box.children only includes AgsWidgets
          //@ts-ignore
          button.toggleClassName("occupied", ws?.windows > 0);
          //@ts-ignore
          button.toggleClassName("occupied-left", !ws_before || ws_before?.windows <= 0);
          //@ts-ignore
          button.toggleClassName("occupied-right", !ws_after || ws_after?.windows <= 0);
        });
      }, "notify::workspaces")
  });

export default Workspaces
