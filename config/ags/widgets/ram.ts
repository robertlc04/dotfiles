const errors = (value: string | undefined) => {
  if (value == undefined) return true;
  if (!value.includes("\n")) return true;
  return false;
};

const format = (value: string | undefined) => {
  if (errors(value)) return "0"

  const ram_used = value.split("\n")[1].split(/\s+/)[2].replace("Gi", "");

  return ` ${ram_used} GB`;
};

const ram = Variable("", {
  poll: [1000, "free -h", (out) => format(out)],
});

const RAM = () => {
  return Widget.Label({
    visible: ram.bind("value") != undefined,
    label: ram.bind(),
  });
};

export default RAM
