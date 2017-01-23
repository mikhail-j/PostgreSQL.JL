#=*
* This file defines the pg_type object identifiers (OID) found in postgres/src/include/catalog/pg_type.h.
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

export Oid

typealias Oid Cuint;

# OIDS 000 - 099 #
const BOOLOID			= Oid(16);			#bool
const BYTEAOID			= Oid(17);			#bytea
const CHAROID			= Oid(18);			#char
const NAMEOID			= Oid(19);			#name
const INT8OID			= Oid(20);			#int8
const INT2OID			= Oid(21);			#int2
const INT2VECTOROID		= Oid(22);			#int2vector
const INT4OID			= Oid(23);			#int4
const REGPROCOID		= Oid(24);			#regproc
const TEXTOID			= Oid(25);			#text
const OIDOID			= Oid(26);			#oid
const TIDOID			= Oid(27);			#tid
const XIDOID			= Oid(28);			#xid
const CIDOID			= Oid(29);			#cid
const OIDVECTOROID		= Oid(30);			#oidvector
const PGDDLCOMMANDOID	= Oid(32);			#pg_ddl_command
const PGTYPEOID			= Oid(71);			#pg_type
const PGATTROID			= Oid(75);			#pg_attribute
const PGPROCOID			= Oid(81);			#pg_proc
const PGCLASSOID 		= Oid(83);			#pg_class

# OIDS 100 - 199 #
const JSONOID			= Oid(114);			#json
const XMLOID			= Oid(142);			#xml
const PGNODETREEOID		= Oid(194);			#pg_node_tree

# OIDS 600 - 699 #
const POINTOID			= Oid(600);			#point
const LSEGOID			= Oid(601);			#lseg
const PATHOID			= Oid(602);			#path
const BOXOID			= Oid(603);			#box
const POLYGONOID		= Oid(604);			#polygon
const LINEOID			= Oid(628);			#line

# OIDS 700 - 799 #
const FLOAT4OID		= Oid(700);				#Float32
const FLOAT8OID		= Oid(701);				#Float64
const ABSTIMEOID	= Oid(702);				#abstime
const RELTIMEOID	= Oid(703);				#reltime
const TINTERVALOID	= Oid(704);				#tinterval
const UNKNOWNOID	= Oid(705);
const CIRCLEOID		= Oid(718);				#circle
const CASHOID 		= Oid(790);				#money

# OIDS 800 - 899 #
const MACADDROID 		= Oid(829);			#macaddr
const INETOID			= Oid(869);			#inet
const CIDROID			= Oid(650);			#cidr

# OIDS 900 - 999 #

# OIDS 1000 - 1099 #
const INT2ARRAYOID		= Oid(1005);		#_int2
const INT4ARRAYOID		= Oid(1007);		#_int4
const TEXTARRAYOID		= Oid(1009);		#_text
const OIDARRAYOID		= Oid(1028);		#_oid
const FLOAT4ARRAYOID	= Oid(1021);		#_float4
const ACLITEMOID		= Oid(1033);		#aclitem
const CSTRINGARRAYOID	= Oid(1263);		#_cstring
const BPCHAROID			= Oid(1042);		#bpchar
const VARCHAROID		= Oid(1043);		#varchar
const DATEOID			= Oid(1082);		#date
const TIMEOID			= Oid(1083);		#time

# OIDS 1100 - 1199 #
const TIMESTAMPOID		= Oid(1114);		#timestamp
const TIMESTAMPTZOID	= Oid(1184);		#timestamptz
const INTERVALOID		= Oid(1186);		#interval

# OIDS 1200 - 1299 #
const TIMETZOID			= Oid(1266);		#timetz

# OIDS 1500 - 1599 #
const BITOID		= Oid(1560);			#bit
const VARBITOID		= Oid(1562);			#varbit

# OIDS 1600 - 1699 #

# OIDS 1700 - 1799 #
const NUMERICOID	= Oid(1700);			#numeric
const REFCURSOROID	= Oid(1790);			#regcursor

# OIDS 2200 - 2299 #
const REGPROCEDUREOID 	= Oid(2202);		#regprocedure
const REGOPEROID		= Oid(2203);		#regoper
const REGOPERATOROID	= Oid(2204);		#regoperator
const REGCLASSOID		= Oid(2205);		#regclass
const REGTYPEOID		= Oid(2206);		#regtype
const REGROLEOID		= Oid(4096);		#regrole
const REGNAMESPACEOID 	= Oid(4089);		#regnamespace
const REGTYPEARRAYOID 	= Oid(2211);		#_regtype

# uuid #
const UUIDOID			= Oid(2950);		#uuid

# pg_lsn #
const LSNOID			= Oid(3220);		#pg_lsn

# text search #
const TSVECTOROID		= Oid(3614);		#tsvector
const GTSVECTOROID		= Oid(3642);		#gtsvector
const TSQUERYOID		= Oid(3615);		#tsquery
const REGCONFIGOID		= Oid(3734);		#regconfig
const REGDICTIONARYOID	= Oid(3769);		#regdictionary

# jsonb #
const JSONBOID			= Oid(3802);		#jsonb

# range types #
const INT4RANGEOID		= Oid(3904);		#int4range

# pseudo-types #
const RECORDOID				= Oid(2249);		#record
const RECORDARRAYOID		= Oid(2287);		#_record
const CSTRINGOID			= Oid(2275);		#cstring
const ANYOID				= Oid(2276);		#any
const ANYARRAYOID			= Oid(2277);		#anyarray
const VOIDOID				= Oid(2278);		#void
const TRIGGEROID			= Oid(2279);		#trigger
const EVTTRIGGEROID			= Oid(3838);		#event_trigger
const LANGUAGE_HANDLEROID 	= Oid(2280);		#language_handler
const INTERNALOID			= Oid(2281);		#internal
const OPAQUEOID				= Oid(2282);		#opaque
const ANYELEMENTOID			= Oid(2283);		#anyelement
const ANYNONARRAYOID		= Oid(2776);		#anynonarray
const ANYENUMOID			= Oid(3500);		#anyenum
const FDW_HANDLEROID		= Oid(3115);		#fdw_handler
const INDEX_AM_HANDLEROID 	= Oid(325);			#index_am_handler
const TSM_HANDLEROID		= Oid(3310);		#tsm_handler
const ANYRANGEOID			= Oid(3831);		#anyrange