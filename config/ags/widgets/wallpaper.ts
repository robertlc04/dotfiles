const wallpaper_cmd = () => {Utils.exec("/home/robert/.config/swww/swwwallpaper.sh -n")}

const WallpaperChange = () => {
  return Widget.Button({
    class_name: "wallchange",
    label: "  ",
    onPrimaryClick: () => wallpaper_cmd()
  })
}

export default WallpaperChange
