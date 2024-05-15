const volumeIcons = {
  100: "",
  50: "",
  0: "󰝟",
};

const setIcon = (value: number) => {
    if (value > 50) return volumeIcons[100];
    if (value < 51 && value > 20) return volumeIcons[50];
    return volumeIcons[0];
  };

const format_output = (value: String) => {
  if (value == undefined) {
    return 'none volume'
  }
  const percentRaw = value.split("\n")[4].split(" ")[5]
  const percentValue = Number.parseInt(percentRaw.slice(1,percentRaw.length-2));
  return `${setIcon(percentValue)} ${percentValue}%`
}

const volumeValue = Variable("", {
    poll: [
      100,
      "amixer get Master",
      (out) => {
        return format_output(out) ;
      },
    ],
  });

const Volume = () => {
  return Widget.Label({
    label: volumeValue.bind(),
  });
};

export default Volume

