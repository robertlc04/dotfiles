import network from "resource:///com/github/Aylur/ags/service/network.js";

const Network = () =>
  Widget.Box({
    spacing: 8,
    children: [
      Widget.Icon({
        icon: network.wifi.bind("icon_name"),
      }),
      Widget.Label({
        label: network.wifi.bind("ssid").as((ssid) => ssid || "Unknown"),
      }),
    ],
  });

export default Network;
