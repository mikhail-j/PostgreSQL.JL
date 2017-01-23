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

#get status of libpq PGconn
function status(conn::Ptr{PGconn})
	return ccall((:PQstatus, PostgreSQL.lib.libpq), ConnStatusType, (Ptr{PGconn},), conn);
end

#free PGconn variable
function finish(conn::Ptr{PGconn})
	ccall((:PQfinish, PostgreSQL.lib.libpq), Void, (Ptr{PGconn},), conn);
end

#reset blocking libpq connection
function reset(conn::Ptr{PGconn})
	ccall((:PQreset, PostgreSQL.lib.libpq), Void, (Ptr{PGconn},), conn);
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

#get PQresult status
function resultStatus(res::Ptr{PGresult})
	return ccall((:PQresultStatus, PostgreSQL.lib.libpq), ExecStatusType, (Ptr{PGresult},), res);
end

#get string form of PQresult status
function resStatus(status::ExecStatusType)
	return unsafe_string(ccall((:PQresStatus, PostgreSQL.lib.libpq), Ptr{UInt8}, (ExecStatusType,), status));
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

#get string form of PQresult error message
function resultErrorMessage(res::Ptr{PGresult})
	return unsafe_string(ccall((:PQresultErrorMessage, PostgreSQL.lib.libpq), Ptr{UInt8}, (Ptr{PGresult},), res));
end

#clean up given PGresult and free it
function clear(res::Ptr{PGresult})
	return ccall((:PQclear, PostgreSQL.lib.libpq), Void, (Ptr{PGresult},), res);
end

