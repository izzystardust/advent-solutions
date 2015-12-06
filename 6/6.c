#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char lights[1000][1000];
char lights2[1000][1000];

int count(char what[1000][1000]) {
	int ret = 0;
	for (int i = 0; i < 1000; i++)
		for (int j = 0; j < 1000; j++)
			ret += what[i][j];
	return ret;
}

void set(char to, int x1, int y1, int x2, int y2) {
	for (int x = x1; x <= x2; x++)
		for (int y = y1; y <= y2; y++)
			lights[x][y] = to;
}

void set2(int by, int x1, int y1, int x2, int y2) {
	for (int x = x1; x <= x2; x++)
		for (int y = y1; y <= y2; y++) {
			lights2[x][y] += by;
			if (lights2[x][y] < 0) lights2[x][y] = 0;
		}
}

void toggle(int x1, int y1, int x2, int y2) {
	for (int x = x1; x <= x2; x++)
		for (int y = y1; y <= y2; y++)
			lights[x][y] = !lights[x][y];
}

void parse(char *line, int *x1, int *y1, int *x2, int *y2) {
	int read = sscanf(line, "%d,%d through %d,%d\n", x1, y1, x2, y2);
}

int main(int argc, char **argv) {

	char *line = NULL;
	size_t len = 0;
	ssize_t read = 0;

	memset(lights, 0, sizeof(lights));
	int x1, y1, x2, y2;
	size_t off;
	char new;
	int by;

	while ((read = getline(&line, &len, stdin)) != -1) {
		switch (line[1]) {
		case 'o':
			parse(line + 7, &x1, &y1, &x2, &y2);
			toggle(x1, y1, x2, y2);
			by = 2;
			break;
		case 'u':
			if (line[6] == 'n') {
				off = 8;
				new = 1;
				by = 1;
			} else {
				off = 9;
				new = 0;
				by = -1;
			}
			parse(line + off, &x1, &y1, &x2, &y2);
			set(new, x1, y1, x2, y2);
			break;
		default:
			printf("Fuckers\n");
		}
		set2(by, x1, y1, x2, y2);

	}
	printf("Lights lit: %d\n", count(lights));
	printf("Brightness: %d\n", count(lights2));

	free(line);
}
