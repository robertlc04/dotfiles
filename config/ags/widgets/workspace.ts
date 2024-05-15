import { hyprland } from "resource:///com/github/Aylur/ags/service/hyprland.js";

// Icons
const workspacesIcons = {
  "1": "",
  "2": "",
  "3": "",
  "4": "󰓇",
  "5": "",
  "6": "",
  "7": "󰏫",
  "8": "",
};


// Hyprland
const dispatch = (ws: string) =>
  hyprland.messageAsync(`dispatch workspace name:${ws}`);

const setStyle = (btn_name: string) => {
    const activeName: string =
      hyprland.active.workspace.bind("name").emitter.name;
    return btn_name === activeName ? "focused" : "button";
  };

const btnsInit = (monitor: number) => {
    return Array.from({ length: 4 }, (_, i) => i + (4* (monitor > 0 ? 1 : 0)) +1).map((i) =>
      Widget.Button({
        attribute: i,
        label: `${workspacesIcons[i]}`,
        onClicked: () => dispatch(i.toString()),
      }),
    );
  };

const labelWorkspaces = (monitor: number) => {
  return Widget.Box({
    class_name: "workspaces",
    children: btnsInit(monitor),

    setup: (self) =>
      self.hook(hyprland, () => {
        const ws_name = hyprland.workspaces.map((ws) => ws.name);
        self.children.forEach((btn) => {
          btn.visible =
            ws_name.indexOf(btn.attribute.toString()) > -1 ? true : false;
          btn.class_name = setStyle(btn.attribute.toString());
        });
      }),
  });
};

const Wokspaces = (monitor: number) =>
  Widget.EventBox({
    onScrollUp: () => dispatch("+1"),
    onScrollDown: () => dispatch("-1"),
    class_name: "workspaces",
    child: labelWorkspaces(monitor),
  });

export default Wokspaces
