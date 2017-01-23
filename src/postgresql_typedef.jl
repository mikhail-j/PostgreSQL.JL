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

export PGconn, PGresult, PGcancel, pqbool, PQOid, PQprintOpt, PGnotify, PQnotify, PQconninfoOption, PQArgBlockInt, PQArgBlock, PGresAttDesc;

typealias PGconn Ptr{Void};
typealias PGresult Ptr{Void};
typealias PGcancel Ptr{Void};
typealias pqbool UInt8;
typealias PQOid Cuint;

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
elseif (Sys.WORD_SIZE == 64)	#c pointers on 64 bit systems are 8 bytes wide
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
	intptr::PQArgBlockInt
end

#attributes used by PQsetResultAttrs()
immutable PGresAttDesc
	name::Ptr{UInt8}
	tableid::PQOid
	columnid::Cint
	format::Cint
	typid::PQOid
	typlen::Cint
	atttypmod::Cint
end
