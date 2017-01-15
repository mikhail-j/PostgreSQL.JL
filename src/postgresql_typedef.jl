#=*
* This file defines the postgresql datatypes found in postgres/src/interfaces/libpq/libpq-fe.h.
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

typealias PGconn Ptr{Void};
typealias PGresult Ptr{Void};
typealias PGcancel Ptr{Void};

#flags used by PQcopyResult()
const PG_COPYRES_ATTRS				= UInt8(0x01);
const PG_COPYRES_TUPLES				= UInt8(0x02);
const PG_COPYRES_EVENTS				= UInt8(0x04);
const PG_COPYRES_NOTICEHOOKS		= UInt8(0x08);

#statuses used by PQstatus()
typealias ConnStatusType Cuint;
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

#statuses used by PQconnectPoll()
typealias PostgresPollingStatusType Cuint;
const PGRES_POLLING_FAILED		= PostgresPollingStatusType(0);
const PGRES_POLLING_READING		= PostgresPollingStatusType(1);
const PGRES_POLLING_WRITING		= PostgresPollingStatusType(2);
const PGRES_POLLING_OK			= PostgresPollingStatusType(3);
const PGRES_POLLING_ACTIVE		= PostgresPollingStatusType(4);

#statuses used by PQresultStatus()
typealias ExecStatusType Cuint;
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
typealias PGTransactionStatusType Cuint;
const PQTRANS_IDLE		= PGTransactionStatusType(0);
const PQTRANS_ACTIVE	= PGTransactionStatusType(1);
const PQTRANS_INTRANS	= PGTransactionStatusType(2);
const PQTRANS_INERROR	= PGTransactionStatusType(3);
const PQTRANS_UNKNOWN	= PGTransactionStatusType(4);

#options used by PQsetErrorVerbosity()
typealias PGVerbosity Cuint;
const PQERRORS_TERSE	= PGVerbosity(0);
const PQERRORS_DEFAULT	= PGVerbosity(1);
const PQERRORS_VERBOSE	= PGVerbosity(2);

#options used by PQsetErrorContextVisibility()
typealias PGContextVisibility Cuint;
const PQSHOW_CONTEXT_NEVER	= PGContextVisibility(0);
const PQSHOW_CONTEXT_ERRORS	= PGContextVisibility(1);
const PQSHOW_CONTEXT_ALWAYS	= PGContextVisibility(2);

#statuses used by PQping() and PQpingParams()
typealias PGPing Cuint;
const PQPING_OK				= PGPing(0);
const PQPING_REJECT			= PGPing(1);
const PQPING_NO_RESPONSE	= PGPing(2);
const PQPING_NO_ATTEMPT		= PGPing(3);

typealias pqbool UInt8;

#options for PQprint()
immutable PQprintOpt
	header::pqbool
	align::pqbool
	standard::pqbool
	html3::pqbool
	expanded::pqbool
	pager::pqbool
	fieldSep::Ptr{UInt8}
	tableOpt::Ptr{UInt8}
	caption::Ptr{UInt8}
	fieldName::Ptr{Ptr{UInt8}}
end

immutable PGnotify
	relname::Ptr{UInt8}
	be_pid::Cint
	extra::Ptr{UInt8}
	next::Ptr{PGnotify}
end

#used by PQconndefaults(), PQconninfoParse(), and PQconninfo()
immutable PQconninfoOption
	keyword::Ptr{UInt8}
	envvar::Ptr{UInt8}
	compiled::Ptr{UInt8}
	val::Ptr{UInt8}
	label::Ptr{UInt8}
	dispchar::Ptr{UInt8}
	dispsize::Cint
end

#=*
*
* C struct used by PQfn() for fast-path interface
*
* As noted on http://docs.julialang.org/en/stable/manual/calling-c-and-fortran-code/
* C union declarations are "not supported" in Julia
*
* The following pads the larger variable in consideration of C integer pointer differences between 32 bit and 64 bit systems.
*
*=#

if (Sys.WORD_SIZE == 32)		#c pointers on 32 bit systems are 4 bytes wide 
	immutable PQArgBlockInt 
		block::Int32
	end
	
	function getPQArgBlockPtr(pqabi::PQArgBlockInt)	#PQArgBlock->u.ptr
		return Ptr{Void}(pqabi.block);
	end
	
	function getPQArgBlockInt(pqabi::PQArgBlockInt)	#PQArgBlock->u.integer
		return pqabi.block;
	end
end
else if (Sys.WORD_SIZE == 64)	#c pointers on 64 bit systems are 8 bytes wide
	immutable PQArgBlockInt 
		block0::Int32
		block1::Int32		#should pad for 8 byte long pointer on 64 
	end
	
	function getPQArgBlockPtr(pqabi::PQArgBlockInt)	#PQArgBlock->u.ptr
		return Ptr{Void}((Int64(pqabi.block0) << 32) + Int64(pqabi.block1));
	end
	
	function getPQArgBlockInt(pqabi::PQArgBlockInt)	#PQArgBlock->u.integer
		return pqabi.block0;
	end
end

immutable PQArgBlock
	len::Cint
	isint::Cint
	
end

#attributes used by PQsetResultAttrs()
immutable PGresAttDesc
	name::Ptr{UInt8}
	tableid::Oid
	columnid::Cint
	format::Cint
	typid::Oid
	typlen::Cint
	atttypmod::Cint
end
