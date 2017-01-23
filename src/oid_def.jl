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

# OIDS 000 - 099 #
const BOOLOID			= PQOid(16);			#bool
const BYTEAOID			= PQOid(17);			#bytea
const CHAROID			= PQOid(18);			#char
const NAMEOID			= PQOid(19);			#name
const INT8OID			= PQOid(20);			#int8
const INT2OID			= PQOid(21);			#int2
const INT2VECTOROID		= PQOid(22);			#int2vector
const INT4OID			= PQOid(23);			#int4
const REGPROCOID		= PQOid(24);			#regproc
const TEXTOID			= PQOid(25);			#text
const OIDOID			= PQOid(26);			#oid
const TIDOID			= PQOid(27);			#tid
const XIDOID			= PQOid(28);			#xid
const CIDOID			= PQOid(29);			#cid
const OIDVECTOROID		= PQOid(30);			#oidvector
const PGDDLCOMMANDOID	= PQOid(32);			#pg_ddl_command
const PGTYPEOID			= PQOid(71);			#pg_type
const PGATTROID			= PQOid(75);			#pg_attribute
const PGPROCOID			= PQOid(81);			#pg_proc
const PGCLASSOID 		= PQOid(83);			#pg_class

# OIDS 100 - 199 #
const JSONOID			= PQOid(114);			#json
const XMLOID			= PQOid(142);			#xml
const PGNODETREEOID		= PQOid(194);			#pg_node_tree

# OIDS 600 - 699 #
const POINTOID			= PQOid(600);			#point
const LSEGOID			= PQOid(601);			#lseg
const PATHOID			= PQOid(602);			#path
const BOXOID			= PQOid(603);			#box
const POLYGONOID		= PQOid(604);			#polygon
const LINEOID			= PQOid(628);			#line

# OIDS 700 - 799 #
const FLOAT4OID		= PQOid(700);				#Float32
const FLOAT8OID		= PQOid(701);				#Float64
const ABSTIMEOID	= PQOid(702);				#abstime
const RELTIMEOID	= PQOid(703);				#reltime
const TINTERVALOID	= PQOid(704);				#tinterval
const UNKNOWNOID	= PQOid(705);
const CIRCLEOID		= PQOid(718);				#circle
const CASHOID 		= PQOid(790);				#money

# OIDS 800 - 899 #
const MACADDROID 		= PQOid(829);			#macaddr
const INETOID			= PQOid(869);			#inet
const CIDROID			= PQOid(650);			#cidr

# OIDS 900 - 999 #

# OIDS 1000 - 1099 #
const INT2ARRAYOID		= PQOid(1005);		#_int2
const INT4ARRAYOID		= PQOid(1007);		#_int4
const TEXTARRAYOID		= PQOid(1009);		#_text
const OIDARRAYOID		= PQOid(1028);		#_oid
const FLOAT4ARRAYOID	= PQOid(1021);		#_float4
const ACLITEMOID		= PQOid(1033);		#aclitem
const CSTRINGARRAYOID	= PQOid(1263);		#_cstring
const BPCHAROID			= PQOid(1042);		#bpchar
const VARCHAROID		= PQOid(1043);		#varchar
const DATEOID			= PQOid(1082);		#date
const TIMEOID			= PQOid(1083);		#time

# OIDS 1100 - 1199 #
const TIMESTAMPOID		= PQOid(1114);		#timestamp
const TIMESTAMPTZOID	= PQOid(1184);		#timestamptz
const INTERVALOID		= PQOid(1186);		#interval

# OIDS 1200 - 1299 #
const TIMETZOID			= PQOid(1266);		#timetz

# OIDS 1500 - 1599 #
const BITOID		= PQOid(1560);			#bit
const VARBITOID		= PQOid(1562);			#varbit

# OIDS 1600 - 1699 #

# OIDS 1700 - 1799 #
const NUMERICOID	= PQOid(1700);			#numeric
const REFCURSOROID	= PQOid(1790);			#regcursor

# OIDS 2200 - 2299 #
const REGPROCEDUREOID 	= PQOid(2202);		#regprocedure
const REGOPEROID		= PQOid(2203);		#regoper
const REGOPERATOROID	= PQOid(2204);		#regoperator
const REGCLASSOID		= PQOid(2205);		#regclass
const REGTYPEOID		= PQOid(2206);		#regtype
const REGROLEOID		= PQOid(4096);		#regrole
const REGNAMESPACEOID 	= PQOid(4089);		#regnamespace
const REGTYPEARRAYOID 	= PQOid(2211);		#_regtype

# uuid #
const UUIDOID			= PQOid(2950);		#uuid

# pg_lsn #
const LSNOID			= PQOid(3220);		#pg_lsn

# text search #
const TSVECTOROID		= PQOid(3614);		#tsvector
const GTSVECTOROID		= PQOid(3642);		#gtsvector
const TSQUERYOID		= PQOid(3615);		#tsquery
const REGCONFIGOID		= PQOid(3734);		#regconfig
const REGDICTIONARYOID	= PQOid(3769);		#regdictionary

# jsonb #
const JSONBOID			= PQOid(3802);		#jsonb

# range types #
const INT4RANGEOID		= PQOid(3904);		#int4range

# pseudo-types #
const RECORDOID				= PQOid(2249);		#record
const RECORDARRAYOID		= PQOid(2287);		#_record
const CSTRINGOID			= PQOid(2275);		#cstring
const ANYOID				= PQOid(2276);		#any
const ANYARRAYOID			= PQOid(2277);		#anyarray
const VOIDOID				= PQOid(2278);		#void
const TRIGGEROID			= PQOid(2279);		#trigger
const EVTTRIGGEROID			= PQOid(3838);		#event_trigger
const LANGUAGE_HANDLEROID 	= PQOid(2280);		#language_handler
const INTERNALOID			= PQOid(2281);		#internal
const OPAQUEOID				= PQOid(2282);		#opaque
const ANYELEMENTOID			= PQOid(2283);		#anyelement
const ANYNONARRAYOID		= PQOid(2776);		#anynonarray
const ANYENUMOID			= PQOid(3500);		#anyenum
const FDW_HANDLEROID		= PQOid(3115);		#fdw_handler
const INDEX_AM_HANDLEROID 	= PQOid(325);			#index_am_handler
const TSM_HANDLEROID		= PQOid(3310);		#tsm_handler
const ANYRANGEOID			= PQOid(3831);		#anyrange