#include <stdio.h>
#include <string.h>

#define MAX_LINE_LENGTH 1024

int main() {
	FILE *tc_file, *core_file, *output_file;
	char line[MAX_LINE_LENGTH];
	char line2[MAX_LINE_LENGTH];
	char* i;
	long prev_pos = 0;
	tc_file = fopen("original_core.json", "r");
	core_file = fopen("modified_core.json", "r");
	output_file = fopen("output.json", "w");

	if (!tc_file || !core_file || !output_file) {
		perror("Error opening file");
		return 1;
	}



	while (fgets(line2, sizeof(line2), tc_file)) {
		if (strstr(line2, "tc") != NULL) {
			printf("found");
			break;
			}

	}

	// Copy content of the core file until "thread_core" is found
	while (fgets(line, sizeof(line), core_file)) {
		if (strstr(line, "thread_core") != NULL) {
			fputs(line2, output_file);
			strcpy(line2, line);
			// Insert content of tc file into the output
			while (fgets(line, sizeof(line), tc_file)) {
				if (strstr(line, "thread_core") != NULL) {
					break;
				}
				fputs(line, output_file);
				//prev_pos = ftell(output_file);

			}
			// Insert "thread_core" into the output
			//fseek(output_file, prev_pos - strlen(line), SEEK_SET);
			fputs(line2, output_file);
		}else	fputs(line, output_file);
	}


	fclose(tc_file);
	fclose(core_file);
	fclose(output_file);


	return 0;
}
