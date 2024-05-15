import Gdk30 from "gi://Gdk?version=3.0";
import Gtk30 from "gi://Gtk?version=3.0";

import Battery from "./widgets/battery";
import Clock from "./widgets/clock";
import CPU from "./widgets/cpu";
import Music from "./widgets/music";
import Network from "./widgets/network";
import RAM from "./widgets/ram";
import SysTray from "./widgets/systray";
import Volume from "./widgets/audio";
import WallChange from "./widgets/wallpaper";
import Workspaces from "./widgets/workspace";


// Generals
const widgetLeftGroup = (monitor: number ) =>
  Widget.Box({
    class_name: "left, blocks",
    hpack: "start",
    spacing: 8,
    vertical: false,
    children: [Clock(), Workspaces(monitor)],
  });

const widgetCenterGroup = () => {
  const children = [Music()]

  return Widget.Box({
    class_name: "blocks",
    hpack: "center",
    spacing: 8,
    vertical: false,
    children,
  });
};
const widgetRightGroup = () => Widget.Box({
    class_name: "blocks",
    hpack: "end",
    spacing: 8,
    vertical: false,
    children: [
      Network(),
      RAM(),
      CPU(),
      Volume(),
      Battery(),
      SysTray(),
      WallChange(),
    ],
  });

/*
 * Main Management
 */

const Bar = (gdkmonitor: Gdk30.Monitor,monitor: number) => {
  return Widget.Window({
    gdkmonitor,
    name: `bar-${monitor}`,
    class_name: `bar`,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    margins: [10, 20, 0, 20],
    child: Widget.CenterBox({
      spacing: 50,
      vertical: false,
      startWidget: widgetLeftGroup(monitor),
      centerWidget: widgetCenterGroup(),
      endWidget: widgetRightGroup(),
    }),
  });
};

const css = "/home/robert/.config/ags/style.css";
const pywal_css = "/home/robert/.cache/wal/colors.css";

// Listen wal changes
Utils.monitorFile(pywal_css, () => {
  setTimeout(async () => {
    App.resetCss();
    App.applyCss(css);
  }, 1000);
});

// Develop
Utils.monitorFile(css, () => {
  App.resetCss();
  App.applyCss(css);
});

App.config({
  style: css,
  // windows: [Bar(0), Bar(1)],
});

// GTK Windows Management
let monitorCount = 0


const addWindows = (windows: Gtk30.Window[], App: any) => {
  windows.forEach(win => App.addWindow(win))
}

const addMonitorWindows = (monitor: Gdk30.Monitor,App) => {
  addWindows([Bar(monitor,monitorCount++)], App)
  monitorCount++
}

const display = Gdk30.Display.get_default();
if (display != undefined) {
  for (let m = 0; m < display?.get_n_monitors(); m++) {
    const monitor = display?.get_monitor(m)
    if (monitor != null) addMonitorWindows(monitor,App)
  }
  
  display?.connect('monitor-added', (disp,monitor) => {
    addMonitorWindows(monitor,App)
  })

  display?.connect('monitor-removed', (disp,monitor) => {
    App.windows.forEach(win => {
      if(win.gdkmonitor === monitor) App.remove_window(win)
    })
  })
}
