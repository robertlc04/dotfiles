import { App } from "astal/gtk3";
import { monitorFile } from "astal/file";
import style from "./style.css";
import Bar from "./widget/Bar";

App.start({
  css: style,
  main() {
    App.get_monitors().map(Bar);
  },
});

function applyCss() {
  setTimeout(() => {}, 1200);
  App.apply_css("/home/rlc/.cache/wal/colors-gtk.css", true);
  App.apply_css(style, true);
}

monitorFile("/home/rlc/.cache/wal/colors-gtk.css", () => {
  console.log("cambio wal");
  App.reset_css();
  applyCss();
});

monitorFile("/home/rlc/.config/ags/style.css", () => {
  console.log("cambio main");
  App.reset_css();
  applyCss();
});
