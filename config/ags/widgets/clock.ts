const time = Variable("", {
    poll: [1000, 'date "+%H:%M"', (out) => `  ${out}`],
  });

const Clock = () => {
  return Widget.Label({
    hpack: "center",
    class_name: "clock",
    label: time.bind(),
  });
};

export default Clock
