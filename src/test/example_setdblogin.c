/*
* This is an example of using PQsetdbLogin() (a blocking connection to the database).
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

int main (int argc, const char* argv[]) {
	
	//create the necessary parameters for the function
	
	const char* host = "localhost";
	const char* port = "5432";
	const char* dbname = "";
	const char* options = "";
	const char* tty = "";
	const char* user = "postgres";
	const char* password = "";
	
	//use PQsetdbLogin to connect to database
	
	PGconn* postgres_conn = PQsetdbLogin(host, port, NULL, NULL, dbname, user, password);
	postgres_conn_status(postgres_conn);
	
	//clean up PGconn object
	PQfinish(postgres_conn);
	return 0;
}
