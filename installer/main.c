#include <stdio.h>
#include <string.h>
#include <unistd.h>
#define NOB_IMPLEMENTATION
#define NOB_STRIP_PREFIX
#include "nob.h"
//#include <stdlib.h>

#define package_is_installed_cmd "pacman", "-Q"
#define install_package "sudo", "pacman", "-S"
#define install_package_yay "sudo", "yay", "-Syu"
#define install_package_flatpak "flatpak", "install", "flathub"
#define clone_git(url) "git", "clone", url
#define Ohoh(S) nob_log(NOB_ERROR, "Ohoh %s",S);
#define sylink(S,D) "ln", "-sf", S, D

bool install_yay_deps() {
    Cmd cmd = {0};

    cmd_append(&cmd, install_package, "--needed" ,"git", "base-devel" );

    if(!nob_cmd_run_sync(cmd)) {
        return false;
    }

    return true;
}

bool install_yay() {

    Cmd cmd = {0};

    nob_log(NOB_INFO,"Verifing if git and other build devs are installed");
    cmd_append(&cmd,package_is_installed_cmd, "git", "base-devel");


    if(!nob_cmd_run_sync_and_reset(&cmd)) {
        if(!install_yay_deps()) {
            Ohoh("Complete the deps install")
            return false;
        }
    }

    cmd_append(&cmd,clone_git("https://aur.archlinux.org/yay.git"));

    if(!nob_cmd_run_sync_and_reset(&cmd)) {
        Ohoh("run clone git")
        return false;
    }

    if(!nob_get_file_type("./yay")) {
        Ohoh("Get yay dir")
        return false;
    }

    if(!nob_set_current_dir("./yay")) {
        Ohoh("Change yay dir")
        return false;
    }

    cmd_append(&cmd,"makepkg", "-si");

    if(!nob_cmd_run_sync_and_reset(&cmd)) {
        nob_log(NOB_ERROR, "Could'nt make the package yay");
        return false;
    }

    return true;
}

int change_work_dir() {
    if(!nob_mkdir_if_not_exists("./work_dir")) return 1;
    if(!nob_set_current_dir("./work_dir")) return  1;
    return 0;
}


// TODO: change delete the test config path
Nob_String_View configs_path(const char *home) {
    Nob_String_Builder config_dir = {0};

    nob_sb_append_cstr(&config_dir, home);
    nob_sb_append_cstr(&config_dir, "/.config_test");
    nob_sb_append_null(&config_dir);

    return nob_sb_to_sv(config_dir);
}

// TODO: change delete the test fonts path
Nob_String_View fonts_path(const char *home) {
    Nob_String_Builder fonts_dir = {0};
    nob_sb_append_cstr(&fonts_dir, home);
    nob_sb_append_cstr(&fonts_dir, "/.local/share/fonts_test");
    nob_sb_append_null(&fonts_dir);

    return nob_sb_to_sv(fonts_dir);
}

int make_folders_needed(const char *config, const char* fonts) {

    if(!nob_mkdir_if_not_exists(config)) return 1;
    if(!nob_mkdir_if_not_exists(fonts)) return 1;

    return 0;
}

int change_to_config_dir(const char* home) {
    const char* current_dir = nob_get_current_dir_temp();

    Nob_String_Builder correct_path = {0};
    nob_sb_append_cstr(&correct_path, home);
    nob_sb_append_cstr(&correct_path, "/dotfiles/installer/work_dir");

    Nob_String_Builder current_dir_cmp = {0};
    nob_sb_append_cstr(&current_dir_cmp, current_dir);

    nob_sb_append_null(&correct_path);
    nob_sb_append_null(&current_dir_cmp);

    if (!nob_sv_eq(nob_sb_to_sv(correct_path), nob_sb_to_sv(current_dir_cmp))) {
        return 1;
    }

    nob_sb_free(correct_path);
    nob_sb_free(current_dir_cmp);

    if(!nob_set_current_dir("../")) return  1;
    const char* new_current_dir = nob_get_current_dir_temp();

    nob_log(NOB_INFO, "NEW CURRENT DIR: %s",new_current_dir);

    return 0;
}

int swww_syslink_configuration(const char* path) {

    const char* wall_links_name[3] = {"wall.dark","wall.light","wall.set", NULL};

    const char* sww_path =  nob_temp_sprintf("%s/swww",path);
    const char* dark_path =  nob_temp_sprintf("%s/swww/dark",path);
    const char* light_path =  nob_temp_sprintf("%s/swww/light",path);

    Nob_File_Paths dark_walls_path = {0};
    Nob_File_Paths light_walls_path = {0};

    nob_read_entire_dir(dark_path, &dark_walls_path);
    nob_read_entire_dir(light_path, &light_walls_path);

    Nob_String_Builder link_light_path = {0};
    Nob_String_Builder link_dark_path = {0};

    nob_sb_append_cstr( &link_light_path, nob_temp_sprintf("%s/%s",light_path,*light_walls_path.items) );
    nob_sb_append_cstr( &link_dark_path, nob_temp_sprintf("%s/%s",dark_path,*dark_walls_path.items) );

    nob_sb_append_null(&link_light_path);
    nob_sb_append_null(&link_dark_path );

    NOB_FREE((dark_walls_path).items);
    NOB_FREE((light_walls_path).items);

    int ok = 0;

    // Dark Wallpaper syslink maked
    ok = symlink(
        link_dark_path.items,
        nob_temp_sprintf("%s/%s",sww_path,wall_links_name[0])
    );

    if(ok != 0) {
        nob_sb_free(link_dark_path);
        nob_sb_free(link_light_path);
        return -1;
    }

    // Light Wallpaper syslink maked
    ok = symlink(
        link_light_path.items,
        nob_temp_sprintf("%s/%s",sww_path,wall_links_name[1])
    );

    if(ok != 0) {
        nob_sb_free(link_dark_path);
        nob_sb_free(link_light_path);
        return -1;
    }

    // Set Wallpaper syslink maked
    ok = symlink(
        link_dark_path.items,
        nob_temp_sprintf("%s/%s",sww_path,wall_links_name[2])
    );

    if(ok != 0) {
        nob_sb_free(link_dark_path);
        nob_sb_free(link_light_path);
        return -1;
    }

    nob_log(NOB_INFO,"OK");

    nob_sb_free(link_dark_path);
    nob_sb_free(link_light_path);

    return 0;
}


int main(/* int argc, char **argv */) {

    const char* HOME = getenv("HOME");
    Nob_Fd cleaner = nob_fd_open_for_read("/dev/null");

    if (HOME == NULL) {
      nob_log(NOB_ERROR,"Home variable don't detected");
      quick_exit(-1);
    }

    // Setting fonts and config paths

    Nob_String_View config_path = configs_path(HOME);
    Nob_String_View font_path = fonts_path(HOME);

    nob_log(NOB_INFO,"Making a the config and fonts folder");
    if(make_folders_needed(config_path.data,font_path.data)) {
        nob_log(NOB_ERROR,"Can't create a .config and local fonts dir");
        exit(-1);
    }

    /* Work Dir creation */
    nob_log(NOB_INFO,"Making a temp folder for downloads");
    if (change_work_dir()) {
        nob_log(NOB_ERROR,"Can't create a temp work dir");
        exit(-1);
    }

    /* Global command INIT */
    Cmd cmd = {0};

    nob_log(NOB_INFO,"Verifing if yay it's installed");

    /* Basic detections For Yay */
    cmd_append(&cmd, "pacman","-Q","yay");
    if ( !cmd_run_sync_redirect_and_reset( &cmd, (Nob_Cmd_Redirect) {
        .fdout = &cleaner,
        .fderr = &cleaner
    }) ) {
        if(!install_yay()) {
            nob_log(NOB_INFO,"Reinstall your fuck :v");
        } else {
            nob_log(NOB_INFO, "YAY INSTALLED SUCCESFULLY");
        }
    }

    change_to_config_dir(HOME);

    nob_copy_directory_recursively("../config", config_path.data );

    nob_log(NOB_INFO, "Complete the copy of the configs to: %s",config_path.data);

    nob_copy_directory_recursively( "../fonts" , font_path.data);

    nob_log(NOB_INFO, "Complete the copy of the fonts to: %s",font_path.data);


    nob_log(NOB_INFO, "Symlinking Swww files for work with the bash script");

    if(swww_syslink_configuration(config_path.data) == -1 )  {
        Ohoh("SYSLINK");
        quick_exit(1);
    }

    nob_log(NOB_INFO, "Install daily use packages");

    /* Install daily use packages */
    const char* packages = "aylurs-gtk-shell-git hyprland alacritty nvim swappy grim wofi slurp pamixer alsa-tools brightnessctl python-pywal16 swww ImageMagick flatpak unzip p7zip zen-browser-avx2-bin" ;
    cmd_append(&cmd, install_package_yay, packages);
    if (!nob_cmd_run_sync_and_reset(&cmd)) return 1;

    /* Flatpak install */

    nob_log(NOB_INFO, "Config Flathub");
    cmd_append(&cmd,"flatpak", "remote-add", "--if-not-exists",  "flathub", "https://dl.flathub.org/repo/flathub.flatpakrepo");
    if (!nob_cmd_run_sync_and_reset(&cmd)) return 1;


    nob_log(NOB_INFO, "Flatpaks Install");

    cmd_append(&cmd,install_package_flatpak, "com.librumreader.librum" );
    if (!nob_cmd_run_sync_and_reset(&cmd)) return 1;
    cmd_append(&cmd,install_package_flatpak, "com.spotify.Client" );
    if (!nob_cmd_run_sync_and_reset(&cmd)) return 1;
    cmd_append(&cmd,install_package_flatpak, "com.github.flxzt.rnote" );
    if (!nob_cmd_run_sync_and_reset(&cmd)) return 1;

    nob_fd_close(cleaner);

    nob_log(NOB_INFO,"DONE!!");
    exit(0);
}
