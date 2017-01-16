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

#free PGconn variable
function finish(conn::Ptr{PGconn})
	ccall((:PQfinish, PostgreSQL.lib.libpq), Void, (Ptr{PGconn},), conn);
end

#reset blocking libpq connection
function reset(conn::Ptr{PGconn})
	ccall((:PQreset, PostgreSQL.lib.libpq), Void, (Ptr{PGconn},), conn);
end

#get status of libpq PGconn
function status(conn::Ptr{PGconn})
	return ccall((:PQstatus, PostgreSQL.lib.libpq), ConnStatusType, (Ptr{PGconn},), conn);
end