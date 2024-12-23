#define NOB_IMPLEMENTATION
#include "nob.h"
#include <json-c/json.h>

struct json_object* modify_json(struct json_object* json_array,const char* directory_new) {
	int alength = json_object_array_length(json_array);

	for (int i = 0; i < alength;i++) {
		
		struct json_object* item  = json_object_array_get_idx(json_array,i);

		struct json_object* directory_obj;
		if (json_object_object_get_ex(item,"directory",&directory_obj)) {
			const char *directory_src = json_object_get_string(directory_obj);
			// Print the original "directory" value
			if (memcmp(directory_src,"ADD_DIRECTORY",sizeof("ADD_DIRECTORY")) == 0 ) {
				json_object_object_add(item,"directory",json_object_new_string(directory_new));
				nob_log(NOB_INFO,"UPDATED TO: %s",directory_new);
			}
		}
	}
	return json_array;
}

int main(int argc, char **argv)
{
    NOB_GO_REBUILD_URSELF(argc, argv);
    Nob_Cmd cmd = {0};
    nob_cmd_append(&cmd, "cc", "-Wall", "-Wextra", "-o", "main", "main.c");
    if (!nob_cmd_run_sync_and_reset(&cmd)) return 1;
	
	struct json_object* json_parsed= json_object_from_file("./compile_commands.json");

	if (json_parsed == NULL) {
		return 1;
	}

	
	struct json_object* new_json = modify_json(json_parsed,nob_get_current_dir_temp());
	Nob_String_View data = nob_sv_from_cstr(json_object_to_json_string(new_json));
	
	nob_write_entire_file("./compile_commands.json",data.data,data.count);

    nob_cmd_append(&cmd, "./main");
    if (!nob_cmd_run_sync_and_reset(&cmd)) return 1;

    return 0;
}
