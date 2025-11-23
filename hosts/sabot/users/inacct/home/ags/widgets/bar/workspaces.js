import { BarBox } from "../../utils.js";

const hyprland = await Service.import('hyprland')

const WorkspaceButton = (ws) => Widget.Button({
  class_name: "ws-button",
  vpack: "center",
  on_primary_click_release: () => hyprland.messageAsync(`dispatch workspace ${ws}`)
    .catch(logError),
}).hook(hyprland.active.workspace, button => {
  button.toggleClassName("ws-current", hyprland.active.workspace.id === ws);
})

const Workspaces = BarBox(Array.from({length: 10}, (_, i) => i + 1).map(i => WorkspaceButton(i)))
  .hook(hyprland, (box) => {
    box.children.forEach((button, i) => {
      const ws = hyprland.getWorkspace(i + 1);
      button.toggleClassName("ws-occupied", ws?.windows > 0);
    });
  }, "notify::workspaces")

export default Workspaces
