/*
* Example initialization of parameters for PQconnectdbParams(), taking a filename argument passed to this program to find the file with specified parameters.
*
* Copyright (C) 2016 Qijia (Michael) Jin
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

int main (int argc, const char* argv[]) {
	long number_of_keywords = 3;
	long string_length = 32;
	
	//allocate the memory for the keywords
	char* keywords_alloc = malloc(sizeof(char*) * number_of_keywords * string_length);
	if (keywords_alloc == NULL) {
		printf("error: malloc failed!\n");
	}
	char** keywords = malloc(sizeof(char**) * number_of_keywords);
	if (keywords == NULL) {
		printf("error: malloc failed!\n");
	}

	//then allocate the memory for the values corresponding to keywords
	char* values_alloc = malloc(sizeof(char*) * number_of_keywords * string_length);
	if (values_alloc == NULL) {
		printf("error: malloc failed!\n");
	}
	char** values = malloc(sizeof(char**) * number_of_keywords);
	if (values == NULL) {
		printf("error: malloc failed!\n");
	}

	for (long i = 0; i < number_of_keywords; i++) {
		keywords[i] = keywords_alloc + (i * string_length);
		values[i] = values_alloc + (i * string_length);
	}
	
	//*(keywords + 0) = malloc(sizeof(char) * 32);
	strcpy(*(keywords + 0), "username");
	strcpy(*(values + 0), "postgres");
	//*(keywords + 1) = malloc(sizeof(char) * 32);
	strcpy(*(keywords + 1), "password");
	strcpy(*(values + 1), "*****");
	//*(keywords + 2) = malloc(sizeof(char) * 32);
	strcpy(*(keywords + 2), "hostaddr");
	strcpy(*(values + 2), "localhost");
	printf("keywords: %s %s %s\n", keywords[0], keywords[1], keywords[2]);
	printf("values: %s %s %s\n", values[0], values[1], values[2]);
	//free(*(keywords)) *(keywords + 1), *(keywords + 2));
	free(keywords);
	free(keywords_alloc);
	free(values);
	free(values_alloc);
	//printf("number of arguments: %i\n", argc);
	//long offset = 1;	//start from 1 since index 0 is the program name
	//while (argv[offset] != NULL) {
	//	printf("%s\n", argv[offset]);
	//	++offset;
	//}
	
	if (argc > 1) {		//check if a filename was given
		FILE* file_ref = fopen(argv[1], "r");
		if (file_ref != NULL) {
			char buffer_line[1024];
			char key[1024];
			char val[1024];
			bool isNull = 0;
			while (!isNull) {
				if ((fgets(buffer_line, 1024, file_ref)) != NULL) {
					long current_string_length = strcspn(buffer_line, "\r\n");
					if (current_string_length != 0 && buffer_line[0] != '#') {			//ignore empty lines or comments
						printf("length: %i\n", current_string_length);
						buffer_line[current_string_length] = '\0';		//remove carriage return character or newline character
						long delimiter_index = strcspn(buffer_line, "=");		//number of characters before delimiter
						memcpy(key, buffer_line, delimiter_index);
						key[delimiter_index] = 0;
						memcpy(val, buffer_line + delimiter_index + 1, strlen(buffer_line + delimiter_index + 1) + 1);
						printf("key: %s | val: %s\n", key, val);
						printf("%s\n", buffer_line);
					}
				}
				else {
					isNull = 1;
				}
			}
			fclose(file_ref);
		}
		else {
			printf("error: %s could not be found!", argv[1]);
		}
	}
	
	return 0;
}