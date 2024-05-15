const batteryIcons = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];

const batteryInfo = () => Utils.exec("cat /sys/class/power_supply/BAT0/uevent");

const batteryFormat = () => {
  const raw = batteryInfo()
  const status = raw.split("\n")[2].split("=")[1]
  const percent = raw.split("\n")[12].split("=")[1];
  const icon = percent !== "100" ? parseInt(percent.charAt(0))  : 10;

  return { 'status': status, 'percent': percent, 'icon': icon }
}

const setClass = (status: string, percent: string) => {
    const numberPercent = parseInt(percent);
    if (numberPercent < 20 && status !== "Charging") {
      return "battery_low";
    }
    return status === "Discharging" ? "consuming" : "charging";
  };

const Battery = () => {
  return Widget.Label({}).poll(100, (self) => {
    const battery = batteryFormat()
    self.label = `${batteryIcons[battery.icon]} ${battery.percent}`;
    self.class_name = setClass(battery.status, battery.percent);
  });
};

export default Battery
