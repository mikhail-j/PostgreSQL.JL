#=*
* PostgreSQL libpq functions
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

#count the number of parameters in given file for connectdbParams() and pingParams()
function countParams(filename::String)
	local count = Int64(0);
	local file_ref = open(filename, "r");
	while (!eof(file_ref))
		current_line = strip(readline(file_ref));
		if (length(current_line) != 0 && current_line[1] != '#')
			count = count + Int64(1);
		end
	end
	close(file_ref);
	return count;
end

#=*
*	These functions create a non-blocking socket libpq connection (PGconn).
*=#

#start non-blocking libpq connection
function connectStart(conninfo::String)
	return ccall((:PQconnectStart, PostgreSQL.lib.libpq), Ptr{PGconn}, (Ptr{UInt8},), Base.unsafe_convert(Ptr{UInt8}, conninfo));
end

function connectStart(conninfo::Ptr{UInt8})
	return ccall((:PQconnectStart, PostgreSQL.lib.libpq), Ptr{PGconn}, (Ptr{UInt8},), conninfo);
end

function connectStartParams(keywords::Ptr{Ptr{UInt8}}, values::Ptr{Ptr{UInt8}}, expand_dbname::Cint)
	return ccall((:PQconnectStartParams, PostgreSQL.lib.libpq), Ptr{PGconn}, (Ptr{Ptr{UInt8}}, Ptr{Ptr{UInt8}}, Cint,), keywords, values, expand_dbname);
end

#argument is the name of the file that has parameters delimited by '=' to separate keywords and values
function connectStartParams(filename::String)
	local param_count = countParams(filename);
	local keywords = Array(Ptr{UInt8}, param_count+Int64(1));
	local values = Array(Ptr{UInt8}, param_count+Int64(1));
	local file_ref = open(filename, "r");
	local array_index = Int64(1);
	while (!eof(file_ref))
		current_line = strip(readline(file_ref));
		if (length(current_line) != 0 && current_line[1] != '#')
			equal_dlm = searchindex(current_line, '=');
			if (equal_dlm == 1)		#keyword not found!
				error("connectStartParams() keyword not found!");
			elseif (equal_dlm != 0)
				keywords[array_index] = Base.unsafe_convert(Ptr{UInt8}, current_line[1:equal_dlm-1]);
				values[array_index] = Base.unsafe_convert(Ptr{UInt8}, current_line[equal_dlm+1:end]);
				array_index = array_index + Int64(1);
			end
		end
	end
	keywords[array_index] = Ptr{UInt8}(C_NULL);		#has to be null terminated
	values[array_index] = Ptr{UInt8}(C_NULL);		#has to be null terminated
	close(file_ref);
	return connectStartParams(Base.unsafe_convert(Ptr{Ptr{UInt8}}, keywords), Base.unsafe_convert(Ptr{Ptr{UInt8}}, values), Cint(0));
end

#=*
*	These functions create a blocking socket libpq connection (PGconn).
*=#

#start blocking libpq connection
function connectdb(conninfo::String)
	return ccall((:PQconnectdb, PostgreSQL.lib.libpq), Ptr{PGconn}, (Ptr{UInt8},), Base.unsafe_convert(Ptr{UInt8}, conninfo));
end

function connectdb(conninfo::Ptr{UInt8})
	return ccall((:PQconnectdb, PostgreSQL.lib.libpq), Ptr{PGconn}, (Ptr{UInt8},), conninfo);
end

function connectdbParams(keywords::Ptr{Ptr{UInt8}}, values::Ptr{Ptr{UInt8}}, expand_dbname::Cint)
	return ccall((:PQconnectdbParams, PostgreSQL.lib.libpq), Ptr{PGconn}, (Ptr{Ptr{UInt8}}, Ptr{Ptr{UInt8}}, Cint,), keywords, values, expand_dbname);
end

#argument is the name of the file that has parameters delimited by '=' to separate keywords and values
function connectdbParams(filename::String)
	local param_count = countParams(filename);
	local keywords = Array(Ptr{UInt8}, param_count+Int64(1));
	local values = Array(Ptr{UInt8}, param_count+Int64(1));
	local file_ref = open(filename, "r");
	local array_index = Int64(1);
	while (!eof(file_ref))
		current_line = strip(readline(file_ref));
		if (length(current_line) != 0 && current_line[1] != '#')
			equal_dlm = searchindex(current_line, '=');
			if (equal_dlm == 1)		#keyword not found!
				error("connectdbParams() keyword not found!");
			elseif (equal_dlm != 0)
				keywords[array_index] = Base.unsafe_convert(Ptr{UInt8}, current_line[1:equal_dlm-1]);
				values[array_index] = Base.unsafe_convert(Ptr{UInt8}, current_line[equal_dlm+1:end]);
				array_index = array_index + Int64(1);
			end
		end
	end
	keywords[array_index] = Ptr{UInt8}(C_NULL);		#has to be null terminated
	values[array_index] = Ptr{UInt8}(C_NULL);		#has to be null terminated
	close(file_ref);
	return connectdbParams(Base.unsafe_convert(Ptr{Ptr{UInt8}}, keywords), Base.unsafe_convert(Ptr{Ptr{UInt8}}, values), Cint(0));
end

#start blocking libpq connection, parameters set to null will use the default settings
function setdbLogin(pghost::Ptr{UInt8}, pgport::Ptr{UInt8}, pgoptions::Ptr{UInt8}, pgtty::Ptr{UInt8}, dbName::Ptr{UInt8}, login::Ptr{UInt8}, pwd::Ptr{UInt8})
	return ccall((:PQsetdbLogin, PostgreSQL.lib.libpq), Ptr{PGconn},
		(Ptr{UInt8}, Ptr{UInt8}, Ptr{UInt8}, Ptr{UInt8}, Ptr{UInt8}, Ptr{UInt8}, Ptr{UInt8},),
		pghost, pgport, pgoptions, pgtty, pgdbName, login, pwd);
end

#=*
*	The following functions are to be used with non-blocking libpq connections.
*=#

#get the polling status of non-blocking libpq connection
function connectPoll(conn::PGconn)
	return ccall((:PQconnectPoll, PostgreSQL.lib.libpq), PostgresPollingStatusType, (Ptr{PGconn},), conn);
end

#reset non-blocking libpq connection, returns 1 if connection reset started and 0 if connection reset attempt failed
function resetStart(conn::Ptr{PGconn})
	return ccall((:PQresetStart, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#get the polling status of resetting libpq connection
function resetPoll(conn::Ptr{PGconn})
	return ccall((:PQresetPoll, PostgreSQL.lib.libpq), PostgresPollingStatusType, (Ptr{PGconn},), conn);
end

"""
	consumeInput() tries to consume input on the non-blocking socket of the libpq connection and returns 1 if nothing wrong occurred and 0 otherwise.
	
	The libpq documentation explains that PQ.errorMessage() can check what error occurred when PQ.consumeInput() returned 0, https://www.postgresql.org/docs/9.5/static/libpq-async.html
	
"""
function consumeInput(conn::Ptr{PGconn})
	return ccall((:PQconsumeInput, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#check if using getResult() on the non-blocking socket libpq connection will wait for server input, returns 1 if query result is not ready and 0 if the query result is ready
function isBusy(conn::Ptr{PGconn})
	return ccall((:PQisBusy, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#get the next available query result on non-blocking socket libpq connection, returns null if there are currently no more results
function getResult(conn::Ptr{PGconn})
	return ccall((:PQgetResult, PostgreSQL.lib.libpq), Ptr{PGresult}, (Ptr{PGconn},), conn);
end

#send query for information on previously prepared statement from a statement name, returns 1 if sent and 0 otherwise
function sendDescribePrepared(conn::Ptr{PGconn}, stmtName::Ptr{UInt8})
	return ccall((:PQsendDescribePrepared, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn}, Ptr{UInt8},), conn, stmtName);
end

function sendDescribePrepared(conn::Ptr{PGconn}, stmtName::String)
	return ccall((:PQsendDescribePrepared, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn}, Ptr{UInt8},), conn, Base.unsafe_convert(Ptr{UInt8}, stmtName));
end

#send query for information on existing cursor from given portal name and doesn't wait for the result, returns 1 if sent and 0 otherwise
function sendDescribePortal(conn::Ptr{PGconn}, portalName::Ptr{UInt8})
	return ccall((:PQsendDescribePortal, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn}, Ptr{UInt8},), conn, portalName);
end

function sendDescribePortal(conn::Ptr{PGconn}, portalName::String)
	return ccall((:PQsendDescribePortal, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn}, Ptr{UInt8},), conn, Base.unsafe_convert(Ptr{UInt8}, portalName));
end

#check if there is a pending notification from a LISTEN or NOTIFY command previously submitted, returns null if there are no pending notifications
function notifies(conn::Ptr{PGconn})
	return ccall((:PQnotifies, PostgreSQL.lib.libpq), Ptr{PGnotifies}, (Ptr{PGconn},), conn);
end

#=*
*
*	The following functions get the connection options used by PQ.connectdb() and returns a PQconninfoOption object.
*
*	The libpq documentation recommends that PQconninfoOption be freed with PQ.conninfoFree() to avoid memory leaks, https://www.postgresql.org/docs/9.5/static/libpq-connect.html
*
*=#

#get the default connection options
function conndefaults()
	return ccall((:PQconndefaults, PostgreSQL.lib.libpq), Ptr{PQconninfoOption}, ());
end

#get the connection options used by given libpq connection
function conninfo(conn::Ptr{PGconn})
	return ccall((:PQconninfo, PostgreSQL.lib.libpq), Ptr{PQconninfoOption}, (Ptr{PGconn},), conn);
end

"""
	conninfoParse() gets the connection options based on a valid PQconnectdb() connection string and returns NULL on success.

	The Ptr{UInt8} in errmsg and the returned Ptr{PQconninfoOption} are C_NULL when the function failed to allocate enough memory.

	The libpq documentation recommends that the allocated errmsg should be freed by PQ.freemem() and the allocated Ptr{PQconninfoOption} be freed by PQ.conninfoFree().

"""
function conninfoParse(conninfo::Ptr{UInt8}, errmsg::Ptr{Ptr{UInt8}})
	return ccall((:PQconninfoParse, PostgreSQL.lib.libpq), Ptr{PQconninfoOption}, (Ptr{UInt8}, Ptr{Ptr{UInt8}},), conninfo, errmsg);
end

function conninfoParse(conninfo::String, errmsg::Ptr{Ptr{UInt8}})
	return ccall((:PQconninfoParse, PostgreSQL.lib.libpq), Ptr{PQconninfoOption}, (Ptr{UInt8}, Ptr{Ptr{UInt8}},), Base.unsafe_convert(Ptr{UInt8}, conninfo), errmsg);
end

#=*
*
*	A Ptr{UInt8} array of 1 element is an alternative to a allocated Ptr{Ptr{UInt8}} object returned by Libc.malloc(sizeof(Ptr{Ptr{UInt8}})).
*
*	Using an allocated memory space returned by Libc.malloc() requires the Ptr{Ptr{UInt8}} variable to be freed with Libc.free() after the PQmemfree() is 
*
*	used on the PQ.conninfoParse() to free the allocated Ptr{UInt8} object.
*
*=#
function conninfoParse(conninfo::String, errmsg::Array{Ptr{UInt8}, 1})
	return ccall((:PQconninfoParse, PostgreSQL.lib.libpq), Ptr{PQconninfoOption},
	(Ptr{UInt8}, Ptr{Ptr{UInt8}},),
	Base.unsafe_convert(Ptr{UInt8}, conninfo),Base.unsafe_convert(Ptr{Ptr{UInt8}}, errmsg));
end

#=*
*	The following functions give the status and information used to create the existing PGconn.
*=#

#get status of libpq PGconn
function status(conn::Ptr{PGconn})
	return ccall((:PQstatus, PostgreSQL.lib.libpq), ConnStatusType, (Ptr{PGconn},), conn);
end

#get server transaction status of libpq PGconn
function transactionStatus(conn::Ptr{PGconn})
	return ccall((:PQtransactionStatus, PostgreSQL.lib.libpq), PGTransactionStatusType, (Ptr{PGconn},), conn);
end

#try to flush the queued output data on the libpq connection, returns 0 on success and 1 if queue could not be completely flushed (this could occur on non-blocking) and -1 if the flush attempt failed
function flush(conn::Ptr{PGconn})
	return ccall((:PQflush, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#get client encoding ID
function clientEncoding(conn::Ptr{PGconn})
	return ccall((:PQclientEncoding, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#get string form of encoding based on encoding ID that is returned from clientEncoding()
function encoding_to_char(encoding_id::Cint)
	return unsafe_string(ccall((:pg_encoding_to_char, PostgreSQL.lib.libpq), Ptr{UInt8}, (Cint,), encoding_id));
end

#set client encoding given encoding string, returns 0 on success and -1 otherwise
function setClientEncoding(conn::Ptr{PGconn}, encoding::Ptr{UInt8})
	return ccall((:PQsetClientEncoding, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn}, Ptr{UInt8},), conn, encoding);
end

function setClientEncoding(conn::Ptr{PGconn}, encoding::String)
	return ccall((:PQsetClientEncoding, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn}, Ptr{UInt8},), conn, Base.unsafe_convert(Ptr{UInt8}, encoding));
end

#get string form of the parameter of the postgresql server corresponding to the given parameter name, a list of these parameters can be found at https://www.postgresql.org/docs/9.5/static/libpq-status.html
function parameterStatus(conn::Ptr{PGconn}, paramName::Ptr{UInt8})
	return unsafe_string(ccall((:PQparameterStatus, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn}, Ptr{UInt8},), conn, paramName));
end

function parameterStatus(conn::Ptr{PGconn}, paramName::String)
	return unsafe_string(ccall((:PQparameterStatus, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn}, Ptr{UInt8},), conn, Base.unsafe_convert(Ptr{UInt8}, paramName)));
end

#get the database name associated with the libpq connection
function db(conn::Ptr{PGconn})
	return unsafe_string(ccall((:PQdb, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn},), conn));
end

#get the username of the libpq connection
function user(conn::Ptr{PGconn})
	return unsafe_string(ccall((:PQuser, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn},), conn));
end

#get the password of the libpq connection
function pass(conn::Ptr{PGconn})
	return unsafe_string(ccall((:PQpass, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn},), conn));
end

#get the server host of the libpq connection
function host(conn::Ptr{PGconn})
	return unsafe_string(ccall((:PQhost, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn},), conn));
end

#get the port of the libpq connection
function port(conn::Ptr{PGconn})
	return unsafe_string(ccall((:PQport, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn},), conn));
end

#get the debug tty of the connection, obsolete according to libpq documentation at https://www.postgresql.org/docs/9.5/static/libpq-status.html
function tty(conn::Ptr{PGconn})
	return unsafe_string(ccall((:PQtty, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn},), conn));
end

#get the command-line options passed when the libpq connection was created
function options(conn::Ptr{PGconn})
	return unsafe_string(ccall((:PQoptions, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn},), conn));
end

#get the file descriptor of the socket used in a given libpq connection
function socket(conn::Ptr{PGconn})
	return ccall((:PQsocket, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#get the process ID of the postgresql server process
function backendPID(conn::Ptr{PGconn})
	return ccall((:PQbackendPID, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#check if failed libpq connection required a password, returns 1 if true and 0 otherwise
function connectionNeedsPassword(conn::Ptr{PGconn})
	return ccall((:PQconnectionNeedsPassword, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn},), conn);
end

#check if failed libpq connection used a password, returns 1 if true and 0 otherwise
function connectionUsedPassword(conn::Ptr{PGconn})
	return ccall((:PQconnectionUsedPassword, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn},), conn);
end

#get usable PGcancel object from a PGconn object
function getCancel(conn::Ptr{PGconn})
	return ccall((:PQgetCancel, PostgreSQL.lib.libpq), Ptr{PGcancel}, (Ptr{PGconn},), conn);
end

#free PGcancel variable
function freeCancel(cancel::Ptr{PGcancel})
	return ccall((:PQfreeCancel, PostgreSQL.lib.libpq), Void, (Ptr{PGcancel},), cancel);
end

#requests for cancellation of the current command being processed, 1 - request successfully sent/0 - otherwise
function cancel(cancel::Ptr{PGcancel}, errbuf::Ptr{UInt8}, errbufsize::Cint)
	return ccall((:PQcancel, PostgreSQL.lib.libpq), Cint, (Ptr{PGcancel}, Ptr{UInt8}, Cint,), cancel, errbuff, errbuffsize);
end

#free PGconn variable
function finish(conn::Ptr{PGconn})
	return ccall((:PQfinish, PostgreSQL.lib.libpq), Void, (Ptr{PGconn},), conn);
end

#reset blocking libpq connection
function reset(conn::Ptr{PGconn})
	return ccall((:PQreset, PostgreSQL.lib.libpq), Void, (Ptr{PGconn},), conn);
end

#set whether libpq PGconn is non-blocking, returns 0 on success and -1 if something went wrong
function setnonblocking(conn::Ptr{PGconn}, arg::Cint)
	return ccall((:PQsetnonblocking, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn}, Cint,), conn, arg);
end

#check if libpq PGconn is non-blocking
function isnonblocking(conn::Ptr{PGconn})
	return ccall((:PQisnonblocking, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#check if the loaded libpq library is thread safe, returns 1 if true and 0 if false
function isthreadsafe()
	return ccall((:PQisthreadsafe, PostgreSQL.lib.libpq), Cint, ());
end

#ping for status of postgresql server
function ping(conninfo::String)
	return ccall((:PQping, PostgreSQL.lib.libpq), PGPing, (Ptr{UInt8},), Base.unsafe_convert(Ptr{UInt8}, conninfo));
end

function ping(conninfo::Ptr{UInt8})
	return ccall((:PQping, PostgreSQL.lib.libpq), PGPing, (Ptr{UInt8},), conninfo);
end

function pingParams(keywords::Ptr{Ptr{UInt8}}, values::Ptr{Ptr{UInt8}}, expand_dbname::Cint)
	return ccall((:PQpingParams, PostgreSQL.lib.libpq), PGPing, (Ptr{Ptr{UInt8}}, Ptr{Ptr{UInt8}}, Cint,), keywords, values, expand_dbname);
end

#argument is the name of the file that has parameters delimited by '=' to separate keywords and values
function pingParams(filename::String)
	local param_count = countParams(filename);
	local keywords = Array(Ptr{UInt8}, param_count+Int64(1));
	local values = Array(Ptr{UInt8}, param_count+Int64(1));
	local file_ref = open(filename, "r");
	local array_index = Int64(1);
	while (!eof(file_ref))
		current_line = strip(readline(file_ref));
		if (length(current_line) != 0 && current_line[1] != '#')
			equal_dlm = searchindex(current_line, '=');
			if (equal_dlm == 1)		#keyword not found!
				error("pingParams() keyword not found!");
			elseif (equal_dlm != 0)
				keywords[array_index] = Base.unsafe_convert(Ptr{UInt8}, current_line[1:equal_dlm-1]);
				values[array_index] = Base.unsafe_convert(Ptr{UInt8}, current_line[equal_dlm+1:end]);
				array_index = array_index + Int64(1);
			end
		end
	end
	keywords[array_index] = Ptr{UInt8}(C_NULL);		#has to be null terminated
	values[array_index] = Ptr{UInt8}(C_NULL);		#has to be null terminated
	close(file_ref);
	return pingParams(Base.unsafe_convert(Ptr{Ptr{UInt8}}, keywords), Base.unsafe_convert(Ptr{Ptr{UInt8}}, values), Cint(0));
end

#=*
*	The following functions help send SQL commands, describe previously prepared SQL statements, and describe existing cursors on a blocking socket libpq connection.
*=#

#send SQL command over PGconn
function exec(conn::Ptr{PGconn}, command::Ptr{UInt8})
	return ccall((:PQexec, PostgreSQL.lib.libpq), Ptr{PGresult}, (Ptr{PGconn}, Ptr{UInt8},), conn, command);
end

function execParams(conn::Ptr{PGconn}, command::Ptr{UInt8}, nParams::Cint, paramValues::Ptr{Ptr{UInt8}}, paramLengths::Ptr{Cint}, paramFormats::Ptr{Cint}, resultFormat::Cint)
	return ccall((:PQexecParams, PostgreSQL.lib.libpq),
					Ptr{PGresult},
					(Ptr{PGconn}, Ptr{UInt8}, Cint, Ptr{Ptr{UInt8}}, Ptr{Cint}, Ptr{Cint}, Cint,),
					conn, command, nParams, paramValues, paramLengths, paramFormats, resultFormat);
end

#prepare SQL statement, function blocks until PGresult is received (unless returned C_NULL)
function prepare(conn::Ptr{PGconn}, stmtName::Ptr{UInt8}, query::Ptr{UInt8}, nParams::Cint, paramTypes::Ptr{PQOid})
	return ccall((:PQprepare, PostgreSQL.lib.libpq), Ptr{PGresult}, (Ptr{PGconn}, Ptr{UInt8}, Ptr{UInt8}, Cint, Ptr{PQOid},), conn, stmtName, query, nParams, paramTypes);
end

#execute a prepared SQL statement
function execPrepared(conn::Ptr{PGconn}, stmtName::Ptr{UInt8}, nParams::Cint, paramValues::Ptr{Ptr{UInt8}}, paramLengths::Ptr{Cint}, paramFormats::Ptr{Cint}, resultFormat::Cint)
	return ccall((:PQexecPrepared, PostgreSQL.lib.libpq),
			Ptr{PGresult},
			(Ptr{PGconn}, Ptr{UInt8}, Cint, Ptr{Ptr{UInt8}}, Ptr{Cint}, Ptr{Cint}, Cint,),
			conn, stmtName, nParams, paramValues, paramLengths, paramFormats, resultFormat);
end

#get information on previously prepared statement, this functions blocks until completion
function describePrepared(conn::Ptr{PGconn}, stmtName::Ptr{UInt8})
	return ccall((:PQdescribePrepared, PostgreSQL.lib.libpq), Ptr{PGresult}, (Ptr{PGconn}, Ptr{UInt8},), conn, stmtName);
end

function describePrepared(conn::Ptr{PGconn}, stmtName::String)
	return ccall((:PQdescribePrepared, PostgreSQL.lib.libpq), Ptr{PGresult}, (Ptr{PGconn}, Ptr{UInt8},), conn, Base.unsafe_convert(Ptr{UInt8}, stmtName));
end

#get information on existing cursor from given portal name, this function blocks until completion
function describePortal(conn::Ptr{PGconn}, portalName::Ptr{UInt8})
	return ccall((:PQdescribePortal, PostgreSQL.lib.libpq), Ptr{PGresult}, (Ptr{PGconn}, Ptr{UInt8},), conn, portalName);
end

function describePortal(conn::Ptr{PGconn}, portalName::String)
	return ccall((:PQdescribePortal, PostgreSQL.lib.libpq), Ptr{PGresult}, (Ptr{PGconn}, Ptr{UInt8},), conn, Base.unsafe_convert(Ptr{UInt8}, portalName));
end

#=*
*	The following functions get the status of a query result and possible error messages.
*=#

#get PQresult status
function resultStatus(res::Ptr{PGresult})
	return ccall((:PQresultStatus, PostgreSQL.lib.libpq), ExecStatusType, (Ptr{PGresult},), res);
end

#get string form of PQresult status
function resStatus(status::ExecStatusType)
	return unsafe_string(ccall((:PQresStatus, PostgreSQL.lib.libpq), Ptr{UInt8}, (ExecStatusType,), status));
end

#get string form of PQresult error message
function resultErrorMessage(res::Ptr{PGresult})
	return unsafe_string(ccall((:PQresultErrorMessage, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult},), res));
end

#get string form of PQresult error message, this function allows you to specify the verbosity of the error message
function resultVerboseErrorMessage(res::Ptr{PGresult}, verbosity::PGVerbosity, show_context::PGContextVisibility)
	return unsafe_string(ccall((:PQresultVerboseErrorMessage, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult}, PGVerbosity, PGContextVisibility,), res, verbosity, show_context));
end

#get error corresponding to PQresult and error field identifier
function resultErrorField(res::Ptr{PGresult}, fieldcode::Cint)
	return unsafe_string(ccall((:PQresultErrorField, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult}, Cint,), res, fieldcode));
end

function resultErrorField(res::Ptr{PGresult}, fieldcode::Cchar)
	return unsafe_string(ccall((:PQresultErrorField, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult}, Cint,), res, Cint(fieldcode)));
end

function resultErrorField(res::Ptr{PGresult}, fieldcode::Char)
	return unsafe_string(ccall((:PQresultErrorField, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult}, Cint,), res, Cint(fieldcode)));
end

#=*
*	These functions help retrieve data from query results (PGresult).
*=#

#get number of rows in query result
function ntuples(res::Ptr{PGresult})
	return ccall((:PQntuples, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult},), res);
end

#get number of columns in query result
function nfields(res::Ptr{PGresult})
	return ccall((:PQnfields, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult},), res);
end

"""
	binaryTuples() checks if query result contains binary data or text data, returns 1 only if all columns are binary.
	
	PQbinaryTuples() is not recommended in libpq documentation, https://www.postgresql.org/docs/9.5/static/libpq-exec.html
	
"""
function binaryTuples(res::Ptr{PGresult})
	return ccall((:PQbinaryTuples, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult},), res);
end

"""
	fname() gets the string form of the column name associated with a given column number.

	Column numbers start at 0, https://www.postgresql.org/docs/9.5/static/libpq-exec.html
	
"""
function fname(res::Ptr{PGresult}, field_num::Cint)
	return unsafe_string(ccall((:PQfname, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult}, Cint,), res, field_num));
end

#get column number of column name, returns -1 if no columns matched
function fnumber(res::Ptr{PGresult}, column_name::Ptr{UInt8})
	return ccall((:PQfnumber, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult}, Ptr{UInt8},), res, column_name);
end

function fnumber(res::Ptr{PGresult}, column_name::String)
	return ccall((:PQfnumber, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult}, Ptr{UInt8},), res, Base.unsafe_convert(Ptr{UInt8}, column_name));
end

#get the table PQOid corresponding to the given column number
function ftable(res::Ptr{PGresult}, column_number::Cint)
	return ccall((:PQftable, PostgreSQL.lib.libpq), PQOid, (Ptr{PGresult}, Cint,), res, column_number);
end

"""
	ftablecol() gets the column number in the original table of a query result column.
	
	Although queried results have columns starting from 0, table column numbers are nonzero numbers.
	
	This function returns 0 if the specified column was not found or your libpq protocol version is earlier than 3.0, https://www.postgresql.org/docs/9.5/static/libpq-exec.html
	
"""
function ftablecol(res::Ptr{PGresult}, column_number::Cint)
	return ccall((:PQftablecol, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult}, Cint,), res, column_number);
end

#check if the column corresponding the the column number is in binary (1) or text (0)
function fformat(res::Ptr{PGresult}, column_number::Cint)
	return ccall((:PQfformat, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult}, Cint,), res, column_number);
end

#get size of allocated bytes in column specified by the column number
function fsize(res::Ptr{PGresult}, column_number::Cint)
	return ccall((:PQfsize, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult}, Cint,), res, column_number);
end

#get type modifier of column, returns -1 to indicate "no information available" or the column's datatype doesn't use modifiers
function fmod(res::Ptr{PGresult}, column_number::Cint)
	return ccall((:PQfmod, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult}, Cint,), res, column_number);
end

#get the datatype PQOid corresponding to the column number
function ftype(res::Ptr{PGresult}, field_num::Cint)
	return ccall((:PQftype, PostgreSQL.lib.libpq), PQOid, (Ptr{PGresult}, Cint), res, field_number);
end

"""
	getvalue() gets the value of the element/field corresponding to the row and column number (column and row numbers start from 0) given as a Ptr{UInt8}.
	
	To change Ptr{UInt8} to Ptr{T}, use
		
		Ptr{T}(convert(UInt64, PQ.getvalue(res, rn, cn)));		#64-bit system

		or
		
		Ptr{T}(convert(UInt32, PQ.getvalue(res, rn, cn)));		#32-bit system

	The libpq documentation recommends that any data that needs be used later should be explicitly copied to another allocated memory space.

"""
function getvalue(res::Ptr{PGresult}, row_number::Cint, column_number::Cint)
	return ccall((:PQgetvalue, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult}, Cint, Cint,), res, row_number, column_number);
end

#check if specific element/field corresponding to the row and column number given is a null, returning 1 if it is a null and 0 otherwise
function getisnull(res::Ptr{PGresult}, row_number::Cint, column_number::Cint)
	return ccall((:PQgetisnull, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult}, Cint, Cint,), res, row_number, column_number);
end

#get the actual length (number of bytes) of a field/element value corresponding to the row and column number given
function getlength(res::Ptr{PGresult}, row_number::Cint, column_number::Cint)
	return ccall((:PQgetlength, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult}, Cint, Cint,), res, row_number, column_number);
end

#get the number of parameters in a prepared statement, returns 0 if not used on a PGresult returned by PQdescribePrepared()
function nparams(res::Ptr{PGresult})
	return ccall((:PQnparams, PostgreSQL.lib.libpq), Cint, (Ptr{PGresult},), res);
end

#get the datatype PQOid of the parameter corresponding to the parameter number (parameter numbers start at 0), returns 0 if not used on a PGresult returned by PQdescribePrepared()
function paramtype(res::Ptr{PGresult}, param_number::Cint)
	return ccall((:PQparamtype, PostgreSQL.lib.libpq), PQOid, (Ptr{PGresult}, Cint,), res, param_number);
end

#get string form of the command status tag from SQL command used to create the given PGresult
function cmdStatus(res::Ptr{PGresult})
	return unsafe_string(ccall((:PQcmdStatus, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult},), res));
end

#get string form of the number of rows affected by the SQL command used to create the given PGresult
function cmdTuples(res::Ptr{PGresult})
	return unsafe_string(ccall((:PQcmdTuples, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult},), res));
end

"""
	oidStatus() gets the string form of PQOid of the inserted row.
	
	PQoidStatus() is deprecated and not thread safe according to libpq documentation.

"""
function oidStatus(res::Ptr{PGresult})
	return unsafe_string(ccall((:PQoidStatus, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult},), res));
end

#get PQOid of the inserted row if the SQL command was INSERT a EXECUTE on a prepared INSERT SQL command that inserted only 1 row, returns InvalidOid otherwise
function oidValue(res::Ptr{PGresult})
	return ccall((:PQoidValue, PostgreSQL.lib.libpq), PQOid, (Ptr{PGresult},), res);
end

#=*
*	These functions check the server and libpq version as well as protocol version.
*=#

#get the protocol version from a libpq connection
function protocolVersion(conn::Ptr{PGconn})
	return ccall((:PQprotocolVersion, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#get the server version from a libpq connection as a Cint
function serverVersion(conn::Ptr{PGconn})
	return ccall((:PQserverVersion, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#get the libpq version currently in use as a Cint
function libVersion()
	return ccall((:PQlibVersion, PostgreSQL.lib.libpq), Cint, ());
end

#clean up given PGresult and free it
function clear(res::Ptr{PGresult})
	return ccall((:PQclear, PostgreSQL.lib.libpq), Void, (Ptr{PGresult},), res);
end

#=*
*	These functions interact with the SSL settings of the libpq connection.
*=#

#check if SSL is enabled on libpq connection
function sslInUse(conn::Ptr{PGconn})
	return ccall((:PQsslInUse, PostgreSQL.lib.libpq), Cint, (Ptr{PGconn},), conn);
end

#get SSL attribute of libpq connection
function sslAttribute(conn::Ptr{PGconn}, attribute_name::Ptr{UInt8})
	return unsafe_string(ccall((:PQsslAttribute, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn}, Ptr{UInt8},), conn, attribute_name));
end

function sslAttribute(conn::Ptr{PGconn}, attribute_name::String)
	return unsafe_string(ccall((:PQsslAttribute, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGconn}, Ptr{UInt8},), conn, Base.unsafe_convert(Ptr{UInt8}, attribute_name)));
end

#get an array of SSL attribute names available
function sslAttributeNames(conn::Ptr{PGconn})
	local ptr_ptr = ccall((:PQsslAttributeNames, PostgreSQL.lib.libpq), Ptr{Ptr{UInt8}}, (Ptr{PGconn},), conn);
	local index = 1;
	local jstr_array = Array{String, 1}();
	while (unsafe_load(ptr_ptr, index) != Ptr{UInt8}(C_NULL))		#keep converting pointers to julia strings until the pointer points at null
		jstr_array = vcat(jstr_array, unsafe_string(unsafe_load(ptr_ptr, index)));
		index = index + 1;
	end
	return jstr_array;
end

#=*
*	The following are miscellaneous functions found on https://www.postgresql.org/docs/9.5/static/libpq-misc.html
*=#

#=*
*
*	freemem() frees memory variables previously allocated by libpq.
*
*	The following converts pointers of type T to Ptr{Void} in consideration of the pointer difference between 32-bit and 64-bit systems.
*
*=#
if (Sys.WORD_SIZE == 32)
	function freemem{T}(ptr::Ptr{T})
		return ccall((:PQfreemem, PostgreSQL.lib.libpq), Void, (Ptr{Void},), Ptr{Void}(convert(UInt32, ptr)));
	end
elseif (Sys.WORD_SIZE == 64)
	function freemem{T}(ptr::Ptr{T})
		return ccall((:PQfreemem, PostgreSQL.lib.libpq), Void, (Ptr{Void},), Ptr{Void}(convert(UInt64, ptr)));
	end
end

#free the given PQconninfoOption object
function conninfoFree(connOptions::Ptr{PQconninfoOption})
	return ccall((:PQconninfoFree, PostgreSQL.lib.libpq), Void, (Ptr{PQconninfoOption},), connOptions);
end

"""
	encryptPassword() creates a encrypted form of the password based on the username and password given.

	The libpq documentation recommends that returned Ptr{UInt8} be freed by PQfreemem().

	PQencryptPassword() returns C_NULL if malloc failed to allocate enough memory.

"""
function encryptPassword(passwd::Ptr{UInt8}, user::Ptr{UInt8})
	return ccall((:PQencryptPassword, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{UInt8}, Ptr{UInt8},), passwd, user);
end
