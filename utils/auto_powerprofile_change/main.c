#define NOB_IMPLEMENTATION
#define NOB_STRIP_PREFIX
#include "nob.h"

#define BAT0_LEVEL "/sys/class/power_supply/BAT0/capacity"
#define BAT1_LEVEL "/sys/class/power_supply/BAT1/capacity"


#define BAT0_STATUS "/sys/class/power_supply/BAT0/status"
#define BAT1_STATUS "/sys/class/power_supply/BAT1/status"

enum PowerProfiles {
	PowerSaver = 20,
	Balanced,
	Performance
};

enum PluggedIn {
	Charging = 0,
	Discharging
};

int set_power_profile(enum PowerProfiles profile) {
	Cmd cmd = {0};

	cmd_append(&cmd,"powerprofilesctl", "set");

	switch(profile) {
		case PowerSaver:
			cmd_append(&cmd,"power-saver");
			break;
		case Balanced:
			cmd_append(&cmd,"balanced");
			break;
		case Performance:
			cmd_append(&cmd,"performance");
			break;
	}

	if(!cmd_run_sync(cmd)) return 1;
	return 0;
}

int main() {

	String_Builder battery_level_sb = {0};
	String_Builder battery_status_sb = {0};

	if ( !read_entire_file(BAT0_LEVEL, &battery_level_sb) ) {
		nob_log(NOB_INFO,"Battery 0 don't exist");
		goto BAT1;
	};

	if ( !read_entire_file(BAT0_STATUS, &battery_status_sb) ) {
			nob_log(NOB_INFO,"Battery 0 don't exist");
	};

BAT1:

	if ( !read_entire_file(BAT1_LEVEL, &battery_level_sb) ) {
		nob_log(NOB_INFO,"Battery 1 don't exist");
		goto NO_BAT;
	};


	if ( !read_entire_file(BAT1_STATUS, &battery_status_sb) ) {
		nob_log(NOB_INFO,"Battery 1 don't exist");
	};


	const int battery_level = atoi(battery_level_sb.items);
	nob_sb_free(battery_level_sb);

	enum PowerProfiles profile = Performance;
	enum PluggedIn status = Discharging;

	if(strcmp(battery_status_sb.items,"Discharging") < 0) {
		status = Charging;
	};
	nob_sb_free(battery_status_sb);

	switch (status) {
		case Charging:
			nob_log(INFO,"Charging");
			return set_power_profile(profile);
		case Discharging:
			nob_log(INFO,"Discharging");
			profile = battery_level > 20 ? Balanced : PowerSaver;
			return set_power_profile(profile);
	}


	return 1;

NO_BAT:
	if (battery_level_sb.count == 0) {
		nob_log(NOB_ERROR, "NO Battery founded");
		return 1;
	}

}
