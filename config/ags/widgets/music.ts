const lengthCmp = (cmpValue: string) =>
  cmpValue.length > 35 ? `${cmpValue.slice(0, 32)}...` : cmpValue;

const playerctlMetadata = "playerctl -p spotify metadata --format {{title}}";

const metadata = Variable("", {
  poll: [
    100,
    playerctlMetadata,
    (out) => `  ${lengthCmp(out)}  `,
  ],
});

const Music = () => {
  return Widget.Label({
    maxWidthChars: 35,
    label: metadata.bind(),
  });
};

export default Music;
