import { systemTray } from "resource:///com/github/Aylur/ags/service/systemtray.js";

const itemIcon = (item) =>
  Widget.Icon({ class_name: "systray_icon" }).bind("icon", item, "icon");

const Items = (item) => {
  return Widget.Button({
    class_name: "systray_button",
    child: itemIcon(item),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
  });
};

const SysTray = () =>
  Widget.Box({
    class_name: "systray",
    children: systemTray.bind("items").as((i) => i.map(Items)),
  });

export default SysTray;
