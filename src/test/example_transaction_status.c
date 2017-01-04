/*
* This is an example of parsing executed SQL commands and checking SSL and transaction status.
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
#include <math.h>
#include <stdint.h>

void bswap_double (double* double_var) {		//swap byte order of the given double
	double bbuff;
	char* bbuff_b = (char *)&bbuff;
	char* dv_b = (char *)double_var;
	bbuff_b[0] = dv_b[7];
	bbuff_b[1] = dv_b[6];
	bbuff_b[2] = dv_b[5];
	bbuff_b[3] = dv_b[4];
	bbuff_b[4] = dv_b[3];
	bbuff_b[5] = dv_b[2];
	bbuff_b[6] = dv_b[1];
	bbuff_b[7] = dv_b[0];
	*(double_var) = bbuff;
}

void postgres_result_status (PGresult* pqres) {
	ExecStatusType status;
	
	status = PQresultStatus(pqres);
	
	if (status == PGRES_EMPTY_QUERY) {
		printf("libpq execution result status: EMPTY_QUERY\n");
	}
	else if (status == PGRES_COMMAND_OK) {
		printf("libpq execution result status: COMMAND_OK\n");
	}
	else if (status == PGRES_TUPLES_OK) {
		printf("libpq execution result status: TUPLES_OK\n");
	}
	else if (status == PGRES_COPY_OUT) {
		printf("libpq execution result status: COPY_OUT\n");
	}
	else if (status == PGRES_COPY_IN) {
		printf("libpq execution result status: COPY_IN\n");
	}
	else if (status == PGRES_BAD_RESPONSE) {
		printf("libpq execution result status: BAD_RESPONSE\n");
	}
	else if (status == PGRES_NONFATAL_ERROR) {
		printf("libpq execution result status: NONFATAL_ERROR\n");
	}
	else if (status == PGRES_FATAL_ERROR) {
		printf("libpq execution result status: FATAL_ERROR\n");
	}
	else if (status == PGRES_COPY_BOTH) {
		printf("libpq execution result status: COPY_BOTH\n");
	}
	else if (status == PGRES_SINGLE_TUPLE) {
		printf("libpq execution result status: SINGLE_TUPLE\n");
	}
}

void postgres_ssl_enabled (PGconn* pgc) {
	int isUsed = PQsslInUse(pgc);
	
	if (isUsed) {
		printf("libpq connection is using SSL.\n");
	}
	else {
		printf("libpq connection is not using SSL.\n");
	}
}

void postgres_transaction_status (PGconn* pgc) {
	PGTransactionStatusType status;
	
	status = PQtransactionStatus(pgc);
	
	if (status == PQTRANS_IDLE) {
		printf("libpq transaction status: IDLE\n");
	}
	else if (status == PQTRANS_ACTIVE) {
		printf("libpq transaction status: ACTIVE\n");
	}
	else if (status == PQTRANS_INTRANS) {
		printf("libpq transaction status: INTRANS\n");
	}
	else if (status == PQTRANS_INERROR) {
		printf("libpq transaction status: INERROR\n");
	}
	else if (status == PQTRANS_UNKNOWN) {
		printf("libpq transaction status: UNKNOWN\n");
	}
}

void postgres_server_version (PGconn* pgc) {
	int s_version = PQserverVersion(pgc);
	
	if (s_version != 0) {	//is this connection even properly established?
		//parse returned version integer into revision format
		int revision = s_version % 100;
		s_version = (int)floor(s_version*.01);
		
		int minor = s_version % 100;
		s_version = (int)floor(s_version*.01);
		
		int major = s_version % 100;
		
		printf("postgresql server version: %i.%i.%i\n", major, minor, revision);
	}
	else {
		printf("error: no valid libpq server connection found!\n");
	}
}

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

void postgres_conn_poll_status (PGconn* pgc) {
	PostgresPollingStatusType status;
	
	status = PQconnectPoll(pgc);
	
	if (status == PGRES_POLLING_FAILED) {
		printf("libpq poll status: FAILED\n");
	}
	else if (status == PGRES_POLLING_READING) {
		printf("libpq poll status: READING\n");
	}
	else if (status == PGRES_POLLING_WRITING) {
		printf("libpq poll status: WRITING\n");
	}
	else if (status == PGRES_POLLING_OK) {
		printf("libpq poll status: OK\n");
	}
	else if (status == PGRES_POLLING_ACTIVE) {
		printf("libpq poll status: ACTIVE\n");
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
			
			PGconn* postgres_nb_param_conn = PQconnectStartParams(keys, vals, 0);
			postgres_conn_status(postgres_nb_param_conn);
			
			//check if non-blocking connection is usable
			int poll_status = PQconnectPoll(postgres_nb_param_conn);
			while (poll_status != PGRES_POLLING_OK && poll_status != PGRES_POLLING_FAILED) {
				poll_status = PQconnectPoll(postgres_nb_param_conn);
			}
			
			//print current connection status
			postgres_conn_status(postgres_nb_param_conn);
			postgres_param_ping(keys,vals, 0);
			
			postgres_transaction_status(postgres_nb_param_conn);
			postgres_server_version(postgres_nb_param_conn);
			postgres_ssl_enabled(postgres_nb_param_conn);
			
			//run SQL statement with PQexec()
			PGresult* first_sql_command;
			first_sql_command = PQexec(postgres_nb_param_conn, "SELECT * FROM example_balance;");
			postgres_result_status(first_sql_command);
			printf("SQL command executed: %s\n", PQcmdStatus(first_sql_command));
			printf("number of rows affected by SQL command: %s\n", PQcmdTuples(first_sql_command));
			printf("number of rows returned: %i | number of columns returned: %i\n", PQntuples(first_sql_command), PQnfields(first_sql_command));
			//Oid column_zero = PQftype(first_sql_command, 0);
			//Oid column_one = PQftype(first_sql_command, 1);
			//Oid column_two = PQftype(first_sql_command, 2);
			printf("column 1 oid: %u | column 2 oid: %u | column 3 oid: %u\n", PQftype(first_sql_command, 0), PQftype(first_sql_command, 1), PQftype(first_sql_command, 2));
			printf("column 1 fmt_code: %i | column 2 fmt_code: %i | column 3 fmt_code: %i\n", PQfformat(first_sql_command, 0), PQfformat(first_sql_command, 1), PQfformat(first_sql_command, 2));
			printf("column names: %s %s %s\n", PQfname(first_sql_command, 0), PQfname(first_sql_command, 1), PQfname(first_sql_command, 2));
			printf("row 1: %s %s %s\n", PQgetvalue(first_sql_command, 0, 0), PQgetvalue(first_sql_command, 0, 1), PQgetvalue(first_sql_command, 0, 2));
			printf("row 2: %s %s %s\n", PQgetvalue(first_sql_command, 1, 0), PQgetvalue(first_sql_command, 1, 1), PQgetvalue(first_sql_command, 1, 2));
			printf("row 3: %s %s %s\n", PQgetvalue(first_sql_command, 2, 0), PQgetvalue(first_sql_command, 2, 1), PQgetvalue(first_sql_command, 2, 2));
			
			//run SQL statement with PQexecParams(), specifying binary format results
			PGresult* second_sql_command;
			second_sql_command = PQexecParams(postgres_nb_param_conn, "SELECT * FROM example_balance;", 0, NULL, NULL, NULL, NULL, 1);
			postgres_result_status(second_sql_command);
			printf("SQL command executed: %s\n", PQcmdStatus(second_sql_command));
			printf("number of rows affected by SQL command: %s\n", PQcmdTuples(second_sql_command));
			printf("number of rows returned: %i | number of columns returned: %i\n", PQntuples(second_sql_command), PQnfields(second_sql_command));
			//Oid column_zero = PQftype(second_sql_command, 0);
			//Oid column_one = PQftype(second_sql_command, 1);
			//Oid column_two = PQftype(second_sql_command, 2);
			printf("column 1 oid: %u | column 2 oid: %u | column 3 oid: %u\n", PQftype(second_sql_command, 0), PQftype(second_sql_command, 1), PQftype(second_sql_command, 2));
			printf("column 1 format code: %i | column 2 format code: %i | column 3 format code: %i\n", PQfformat(second_sql_command, 0), PQfformat(second_sql_command, 1), PQfformat(second_sql_command, 2));
			printf("column names: %s %s %s\n", PQfname(second_sql_command, 0), PQfname(second_sql_command, 1), PQfname(second_sql_command, 2));
			
			int64_t* parsebigint = malloc(sizeof(char) * 8);
			double* parsedouble = malloc(sizeof(char) * 8);
			int nrows = PQntuples(second_sql_command);
			int ncols = PQnfields(second_sql_command);
			
			for (int i = 0; i < nrows; i++) {
				memcpy(parsebigint, PQgetvalue(second_sql_command, i, 0), 8);
				parsebigint[0] = __builtin_bswap64(*(parsebigint));		//use gcc's builtin 64 bit byte swap function
				
				memcpy(parsedouble, PQgetvalue(second_sql_command, i, 1), 8);
				bswap_double(parsedouble);
				
				printf("row %i: %lli %f %s\n", i + 1, parsebigint[0], parsedouble[0], PQgetvalue(second_sql_command, i, 2));
			}
			
			free(parsebigint);
			free(parsedouble);

			//clean up PGresult objects
			PQclear(first_sql_command);
			PQclear(second_sql_command);
			
			//clean up PGconn object
			PQfinish(postgres_nb_param_conn);
			
			//clean up allocated objects
			free(values_alloc);
			free(keywords_alloc);
			free(values);
			free(keywords);
		}
	}
	else {
		printf("error: A filename was not given as an argument.\n\nUsage: example_connectstartparams [filename]\n");
	}
	return 0;
}