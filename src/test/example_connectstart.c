/*
* This is an example of using PQconnectStart() (a blocking connection to the database).
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

void postgres_ping (const char* ci) {
	PGPing status;
	
	status = PQping(ci);
	
	if (status == PQPING_OK) {
		printf("libpq ping: OK\n");
	}
	else if (status == PQPING_REJECT) {
		printf("libpq ping: REJECT\n");
	}
	else if (status == PQPING_NO_RESPONSE) {
		printf("libpq ping: NO_RESPONSE\n");
	}
	else if (status == PQPING_NO_ATTEMPT) {
		printf("libpq ping: NO_ATTEMPT\n");
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

int main (int argc, const char* argv[]) {
	
	//create valid URI connection string
	const char* connection_info = "postgresql://postgres:passwordhere@localhost/dbname";

	//use URI connection string to connect to database
	PGconn* postgres_conn = PQconnectStart(connection_info);
	postgres_conn_status(postgres_conn);
	
	//check if non-blocking connection is usable
	int poll_status = PQconnectPoll(postgres_conn);
	while (poll_status != PGRES_POLLING_OK && poll_status != PGRES_POLLING_FAILED) {
		poll_status = PQconnectPoll(postgres_conn);
	}
	
	//print current connection status
	postgres_conn_status(postgres_conn);
	postgres_ping(connection_info);
	
	//clean up PGconn object
	PQfinish(postgres_conn);
	return 0;
}
