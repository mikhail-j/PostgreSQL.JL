#=*
* Load libpq definitions and load libpq (C library).
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

module PostgreSQL

export PQ;

#load PostgreSQL library (libpq)
include("load_lib.jl");

#define PostgreSQL libpq's datatypes
include("postgresql_typedef.jl");

#define PostgreSQL libpq's constants
include("postgresql_constants.jl");


module PQ;

#define PostgreSQL libpq's pg_type object identifiers
include("oid_def.jl");

#define PostgreSQL libpq's functions
include("postgresql_libpq_functions.jl");

end;	#end PQ module

end
