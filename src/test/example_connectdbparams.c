/*
* This is an example of using PQconnectdbParams() (a blocking connection to the database).
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

#include <libpq-events.h>
#include <libpq-fe.h>
#include <postgres_ext.h>
#include <pg_config_ext.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

void postgres_param_ping (const char * const * keywords, const char * const * values, int expand_dbname) {
	PGPing status;
	
	status = PQpingParams(keywords, values, expand_dbname);
	
	if (status == PQPING_OK) {
		printf("libpq parameter ping: OK\n");
	}
	else if (status == PQPING_REJECT) {
		printf("libpq parameter ping: REJECT\n");
	}
	else if (status == PQPING_NO_RESPONSE) {
		printf("libpq parameter ping: NO_RESPONSE\n");
	}
	else if (status == PQPING_NO_ATTEMPT) {
		printf("libpq parameter ping: NO_ATTEMPT\n");
	}
}


void postgres_conn_status (PGconn* pgc) {
	ConnStatusType status;
	
	status = PQstatus(pgc);

	if (status == CONNECTION_OK) {
		printf("libpq status: OK\n");
	}
	else if (status == CONNECTION_BAD) {
		printf("libpq status: BAD\n");
	}
	else if (status == CONNECTION_STARTED) {
		printf("libpq status: CONNECTION_STARTED\n");
	}
	else if (status == CONNECTION_MADE) {
		printf("libpq status: CONNECTION_MADE\n");
	}
	else if (status == CONNECTION_AWAITING_RESPONSE) {
		printf("libpq status: AWAITING_RESPONSE\n");
	}
	else if (status == CONNECTION_AUTH_OK) {
		printf("libpq status: AUTH_OK\n");
	}
	else if (status == CONNECTION_SETENV) {
		printf("libpq status: SETENV\n");
	}
	else if (status == CONNECTION_SSL_STARTUP) {
		printf("libpq status: SSL_STARTUP\n");
	}
	else if (status == CONNECTION_NEEDED) {
		printf("libpq status: CONNECTION_NEEDED\n");
	}
}


long countParams(const char * filename) {
	long count = 0;
	FILE* file_ref = fopen(filename, "r");
	if (file_ref != NULL) {
		char buffer_line[1024];
		bool isNull = 0;
		while (!isNull) {
			if ((fgets(buffer_line, 1024, file_ref)) != NULL) {
				long current_string_length = strcspn(buffer_line, "\r\n");
				if (current_string_length != 0 && buffer_line[0] != '#') {			//ignore empty lines or comments
					++count;
				}
			}
			else {
				isNull = 1;
			}
		}
		fclose(file_ref);
	}
	else {
		printf("error: %s could not be found!", filename);
		return -1;
	}
	return count;
}

int main (int argc, const char* argv[]) {
	long param_count;
	char* keywords_alloc;
	char* values_alloc;
	char** keywords;
	char** values;

	if (argc > 1) {		//check if a filename was given
		param_count = countParams(argv[1]);
		//printf("number of parameters: %li\n", param_count);
		if (param_count != -1) {
			keywords_alloc = (char *)malloc((sizeof(char *) * 1024) * param_count);
			values_alloc = (char *)malloc((sizeof(char *) * 1024) * param_count);
			keywords = (char **)malloc(sizeof(char **) * (param_count + 1));		//has to be null terminated
			values = (char **)malloc(sizeof(char **) * (param_count + 1));			//has to be null terminated
			
			for (long i = 0; i < param_count; i++) {
				keywords[i] = keywords_alloc + (1024 * i);
				values[i] = values_alloc + (1024 * i);
			}
			keywords[param_count] = NULL;
			values[param_count] = NULL;
			
			FILE* file_ref = fopen(argv[1], "r");
			if (file_ref != NULL) {
				char buffer_line[1024];
				char key[1024];
				char val[1024];
				bool isNull = 0;
				long index = 0;
				while (!isNull) {
					if ((fgets(buffer_line, 1024, file_ref)) != NULL) {
						long current_string_length = strcspn(buffer_line, "\r\n");
						if (current_string_length != 0 && buffer_line[0] != '#') {			//ignore empty lines or comments
							//printf("length: %i\n", current_string_length);
							buffer_line[current_string_length] = '\0';		//remove carriage return character or newline character
							long delimiter_index = strcspn(buffer_line, "=");		//number of characters before delimiter
							memcpy(key, buffer_line, delimiter_index);
							key[delimiter_index] = 0;
							memcpy(val, buffer_line + delimiter_index + 1, strlen(buffer_line + delimiter_index + 1) + 1);
							strcpy(*(keywords + index), key);
							strcpy(*(values + index), val);
							//printf("key: %s | val: %s\n", *(keywords+index), *(values + index));
							//printf("%s\n", buffer_line);
							++index;
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
			
			const char * const * keys = (const char * const *)keywords;
			const char * const * vals = (const char * const *)values;
			
			PGconn* postgres_param_conn = PQconnectdbParams(keys, vals, 1);
			postgres_conn_status(postgres_param_conn);
			postgres_param_ping(keys,vals, 1);
			//clean up PGconn object
			PQfinish(postgres_param_conn);
			
			//clean up allocated objects
			free(values_alloc);
			free(keywords_alloc);
			free(values);
			free(keywords);
		}
	}
	else {
		printf("error: A filename was not given as an argument.\n\nUsage: example_connectdb [filename]\n");
	}
	return 0;
}