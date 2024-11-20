import { App } from "astal/gtk3";
import { Variable, GLib, bind, exec } from "astal";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import Wp from "gi://AstalWp";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";

// Left Content

function Time({ format = "    %H:%M - %A %e" }) {
  const time = Variable<string>("").poll(
    1000,
    () => GLib.DateTime.new_now_local().format(format)!,
  );

  return (
    <label className="Time" onDestroy={() => time.drop()} label={time()} />
  );
}

function Workspaces() {
  const hypr = Hyprland.get_default();
  type ListIconsObject = {
    [key: number]: string;
  };

  const workspacesIcons: ListIconsObject = {
    1: "",
    2: "",
    3: "",
    4: "󰓇",
    5: "",
    6: "",
    7: "󰏫",
    8: "",
  };

  return (
    <box className="Workspaces">
      {bind(hypr, "workspaces").as((wss) =>
        wss
          .sort((a, b) => a.id - b.id)
          .map((ws) => (
            <button
              className={bind(hypr, "focusedWorkspace").as((fw) =>
                ws === fw ? "focused" : "",
              )}
              onClicked={() => ws.focus()}
            >
              {workspacesIcons[ws.id]}
            </button>
          )),
      )}
    </box>
  );
}

// Center Content

function Media() {
  const mpris = Mpris.get_default();

  return (
    <box className="Media">
      {bind(mpris, "players").as((ps) =>
        ps[0] ? (
          <box>
            <box
              className="Cover"
              valign={Gtk.Align.CENTER}
              css={bind(ps[0], "coverArt").as(
                (cover) => `background-image: url('${cover}');`,
              )}
            />
            <label
              label={bind(ps[0], "title").as(
                () => `${ps[0].title} - ${ps[0].artist}`,
              )}
            />
          </box>
        ) : (
          "Nothing Playing"
        ),
      )}
    </box>
  );
}

// Rigth Content
const format = (value: string) => {
  const ram_used = value.split("\n")[1].split(/\s+/)[2].replace("Gi", "");
  return ` ${ram_used} GB`;
};

function Ram() {
  const ram = Variable<string>("0").poll(200, "free -h", (out: string) =>
    out.split("\n")[1].split(/\s+/)[2].replace("Gi", ""),
  );

  return (
    <box className="Ram">
      <label label={bind(ram).as((r) => `    ${r} GB`)} />
    </box>
  );
}

function Cpu() {
  const cpu_user_usage_raw_watch = Variable<string>("0").watch(
    "mpstat -P ALL 1",
    (out: string) => {
      const value = out.match(/\s+all\s+(\d+\.\d+)/);

      const ret = value?.[1].toString();

      return ret ? ret : "0";
    },
  );
  let old = "0";
  //console.log(cpu_user_usage_raw_watch.get());

  return (
    <box className="Cpu">
      <label
        label={bind(cpu_user_usage_raw_watch).as((cpu_user_usage) => {
          if (cpu_user_usage.length > 1) {
            old = cpu_user_usage;
          }
          return `󰍛  ${old}%`;
        })}
      />
    </box>
  );
}

function Wifi() {
  const { wifi } = Network.get_default();

  return (
    <icon
      tooltipText={bind(wifi, "ssid").as(String)}
      className="Wifi"
      icon={bind(wifi, "iconName")}
    />
  );
}

function AudioSlider() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker!;

  return (
    <box className="AudioSlider">
      <icon icon={bind(speaker, "volumeIcon")} />
      <label
        label={bind(speaker, "volume").as(
          (v) => (v * 100).toFixed(0).toString() + "%",
        )}
      />
    </box>
  );
}

function BatteryLevel() {
  const bat = Battery.get_default();

  return (
    <box className="Battery" visible={bind(bat, "isPresent")}>
      <icon icon={bind(bat, "batteryIconName")} />
      <label
        label={bind(bat, "percentage").as((p) => `${Math.floor(p * 100)} %`)}
      />
    </box>
  );
}

function ChangeWallpaper() {
  return (
    <box className="ChangeWallpaper">
      <button onClick="/home/rlc/.config/swww/swwwallpaper.sh -n" label="" />
    </box>
  );
}

function SysTray() {
  const tray = Tray.get_default();

  return (
    <box className="Systray">
      {bind(tray, "items").as((items) =>
        items.map((item) => {
          if (item.iconThemePath) App.add_icons(item.iconThemePath);

          const menu = item.create_menu();

          return (
            <button
              tooltipMarkup={bind(item, "tooltipMarkup")}
              onDestroy={() => menu?.destroy()}
              onClickRelease={(self) => {
                menu?.popup_at_widget(
                  self,
                  Gdk.Gravity.SOUTH,
                  Gdk.Gravity.NORTH,
                  null,
                );
              }}
            >
              <icon gIcon={bind(item, "gicon")} />
            </button>
          );
        }),
      )}
    </box>
  );
}

// Main Widget

export default function Bar(monitor: Gdk.Monitor) {
  const anchor =
    Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT;

  return (
    <window
      className="Bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={anchor}
      margin={18}
      marginBottom={1}
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START}>
          <Time />
          <Workspaces />
        </box>
        <box>
          <Media />
        </box>
        <box hexpand halign={Gtk.Align.END}>
          <Ram />
          <Cpu />
          <Wifi />
          <AudioSlider />
          <BatteryLevel />
          <ChangeWallpaper />
          <SysTray />
        </box>
      </centerbox>
    </window>
  );
}
