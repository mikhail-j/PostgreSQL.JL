#=*
* This file defines the postgresql constants found in postgres/src/interfaces/libpq/libpq-fe.h.
*
* Copyright (C) 2016-2017 Qijia (Michael) Jin
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
*=#

using PostgreSQL;

#flags used by PQcopyResult()
const PG_COPYRES_ATTRS				= UInt8(0x01);
const PG_COPYRES_TUPLES				= UInt8(0x02);
const PG_COPYRES_EVENTS				= UInt8(0x04);
const PG_COPYRES_NOTICEHOOKS		= UInt8(0x08);

#statuses used by PQstatus()
const CONNECTION_OK						= ConnStatusType(0);
const CONNECTION_BAD					= ConnStatusType(1);
const CONNECTION_STARTED				= ConnStatusType(2);
const CONNECTION_MADE					= ConnStatusType(3);
const CONNECTION_AWAITING_RESPONSE		= ConnStatusType(4);
const CONNECTION_AUTH_OK				= ConnStatusType(5);
const CONNECTION_SETENV					= ConnStatusType(6);
const CONNECTION_SSL_STARTUP			= ConnStatusType(7);
const CONNECTION_NEEDED					= ConnStatusType(8);
const CONNECTION_CHECK_WRITABLE			= ConnStatusType(9);

const CONNECTION_STATUSES = Dict([
Tuple((CONNECTION_OK, "CONNECTION_OK")),
Tuple((CONNECTION_BAD, "CONNECTION_BAD")),
Tuple((CONNECTION_STARTED, "CONNECTION_STARTED")),
Tuple((CONNECTION_MADE, "CONNECTION_MADE")),
Tuple((CONNECTION_AWAITING_RESPONSE, "CONNECTION_AWAITING_RESPONSE")),
Tuple((CONNECTION_AUTH_OK, "CONNECTION_AUTH_OK")),
Tuple((CONNECTION_SETENV, "CONNECTION_SETENV")),
Tuple((CONNECTION_SSL_STARTUP, "CONNECTION_SSL_STARTUP")),
Tuple((CONNECTION_NEEDED, "CONNECTION_NEEDED")),
Tuple((CONNECTION_CHECK_WRITABLE, "CONNECTION_CHECK_WRITABLE"))
]);

#statuses used by PQconnectPoll()
const PGRES_POLLING_FAILED		= PostgresPollingStatusType(0);
const PGRES_POLLING_READING		= PostgresPollingStatusType(1);
const PGRES_POLLING_WRITING		= PostgresPollingStatusType(2);
const PGRES_POLLING_OK			= PostgresPollingStatusType(3);
const PGRES_POLLING_ACTIVE		= PostgresPollingStatusType(4);

#statuses used by PQresultStatus()
const PGRES_EMPTY_QUERY		= ExecStatusType(0);
const PGRES_COMMAND_OK		= ExecStatusType(1);
const PGRES_TUPLES_OK		= ExecStatusType(2);
const PGRES_COPY_OUT		= ExecStatusType(3);
const PGRES_COPY_IN			= ExecStatusType(4);
const PGRES_BAD_RESPONSE	= ExecStatusType(5);
const PGRES_NONFATAL_ERROR	= ExecStatusType(6);
const PGRES_FATAL_ERROR		= ExecStatusType(7);
const PGRES_COPY_BOTH		= ExecStatusType(8);
const PGRES_SINGLE_TUPLE	= ExecStatusType(9);

#statuses used by PQtransactionStatus()
const PQTRANS_IDLE		= PGTransactionStatusType(0);
const PQTRANS_ACTIVE	= PGTransactionStatusType(1);
const PQTRANS_INTRANS	= PGTransactionStatusType(2);
const PQTRANS_INERROR	= PGTransactionStatusType(3);
const PQTRANS_UNKNOWN	= PGTransactionStatusType(4);

#options used by PQsetErrorVerbosity()
const PQERRORS_TERSE	= PGVerbosity(0);
const PQERRORS_DEFAULT	= PGVerbosity(1);
const PQERRORS_VERBOSE	= PGVerbosity(2);

#options used by PQsetErrorContextVisibility()
const PQSHOW_CONTEXT_NEVER	= PGContextVisibility(0);
const PQSHOW_CONTEXT_ERRORS	= PGContextVisibility(1);
const PQSHOW_CONTEXT_ALWAYS	= PGContextVisibility(2);

#statuses used by PQping() and PQpingParams()
const PQPING_OK				= PGPing(0);
const PQPING_REJECT			= PGPing(1);
const PQPING_NO_RESPONSE	= PGPing(2);
const PQPING_NO_ATTEMPT		= PGPing(3);

#error field identifiers used by PQresultErrorField()
const PG_DIAG_SEVERITY					= PGErrorField('S');
const PG_DIAG_SEVERITY_NONLOCALIZED		= PGErrorField('V');
const PG_DIAG_SQLSTATE					= PGErrorField('C');
const PG_DIAG_MESSAGE_PRIMARY			= PGErrorField('M');
const PG_DIAG_MESSAGE_DETAIL			= PGErrorField('D');
const PG_DIAG_MESSAGE_HINT				= PGErrorField('H');
const PG_DIAG_STATEMENT_POSITION		= PGErrorField('P');
const PG_DIAG_INTERNAL_POSITION			= PGErrorField('p');
const PG_DIAG_INTERNAL_QUERY			= PGErrorField('q');
const PG_DIAG_CONTEXT					= PGErrorField('W');
const PG_DIAG_SCHEMA_NAME				= PGErrorField('s');
const PG_DIAG_TABLE_NAME				= PGErrorField('t');
const PG_DIAG_COLUMN_NAME				= PGErrorField('c');
const PG_DIAG_DATATYPE_NAME				= PGErrorField('d');
const PG_DIAG_CONSTRAINT_NAME			= PGErrorField('n');
const PG_DIAG_SOURCE_FILE				= PGErrorField('F');
const PG_DIAG_SOURCE_LINE				= PGErrorField('L');
const PG_DIAG_SOURCE_FUNCTION			= PGErrorField('R');
