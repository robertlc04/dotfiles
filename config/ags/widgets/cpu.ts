
const errors = (value: string|undefined) => {
  if (value == undefined) return true
  if (!value.includes('\n')) return true 
  if (!value.includes('Cpu(s)')) return true 
  return false
}


const format = (value: string|undefined) => {
  if (errors(value)) {
    return "0"
  }
  const cpus_line = value.split('\n').find( line => line.includes("Cpu(s)"));
  const percent = cpus_line.split(/\s+/)[1].replace(',', '.')
  return `󰍛 ${percent}%`;
}

const cpu = Variable('', {
    poll: [
      1000,
      "top -b -n 1",
      (out) => format(out),
    ],
});

const CPU = () => {
  return Widget.Label({
    label: cpu.bind(),
  });
};

export default CPU
