/*
* This header file defines the pg_type object identifiers (OID) found in postgres/src/include/catalog/pg_type.h.
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
*/

#define BOOLOID			16			//bool
#define BYTEAOID		17			//bytea
#define CHAROID			18			//char
#define NAMEOID			19			//name
#define INT8OID			20			//int8
#define INT2OID			21			//int2
#define INT2VECTOROID	22			//int2vector
#define INT4OID			23			//int4
#define REGPROCOID		24			//regproc
#define TEXTOID			25			//text
#define OIDOID			26			//oid
#define TIDOID			27			//tid
#define XIDOID 			28			//xid
#define CIDOID 			29			//cid
#define OIDVECTOROID	30			//oidvector
#define PGTYPEOID		71			//pg_type
#define PGATTROID		75			//pg_attribute
#define PGPROCOID		81			//pg_proc
#define PGCLASSOID		83			//pg_class

/* OIDS 100 - 199 */
#define JSONOID 114					//json
#define XMLOID 142					//xml
#define PGNODETREEOID	194			//pg_node_tree

#define PGDDLCOMMANDOID 32			//pg_ddl_command

/* OIDS 600 - 699 */
#define POINTOID		600			//point
#define LSEGOID			601			//lseg
#define PATHOID			602			//path
#define BOXOID			603			//box
#define POLYGONOID		604			//polygon
#define LINEOID			628			//line

/* OIDS 700 - 799 */
#define FLOAT4OID		700			//Float32
#define FLOAT8OID		701			//Float64
#define ABSTIMEOID		702			//abstime
#define RELTIMEOID		703			//reltime
#define TINTERVALOID	704			//tinterval
#define UNKNOWNOID		705
#define CIRCLEOID		718			//circle
#define CASHOID 		790			//money

/* OIDS 800 - 899 */
#define MACADDROID 		829			//macaddr
#define INETOID 869					//inet
#define CIDROID 650					//cidr

/* OIDS 900 - 999 */

/* OIDS 1000 - 1099 */
#define INT2ARRAYOID		1005	//_int2
#define INT4ARRAYOID		1007	//_int4
#define TEXTARRAYOID		1009	//_text
#define OIDARRAYOID			1028	//_oid
#define FLOAT4ARRAYOID 1021			//_float4
#define ACLITEMOID		1033		//aclitem
#define CSTRINGARRAYOID		1263	//_cstring
#define BPCHAROID		1042		//bpchar
#define VARCHAROID		1043		//varchar
#define DATEOID			1082		//date
#define TIMEOID			1083		//time

/* OIDS 1100 - 1199 */
#define TIMESTAMPOID	1114		//timestamp
#define TIMESTAMPTZOID	1184		//timestamptz
#define INTERVALOID		1186		//interval

/* OIDS 1200 - 1299 */
#define TIMETZOID		1266		//timetz

/* OIDS 1500 - 1599 */
#define BITOID	 1560				//bit
#define VARBITOID	  1562			//varbit

/* OIDS 1600 - 1699 */

/* OIDS 1700 - 1799 */
#define NUMERICOID		1700		//numeric
#define REFCURSOROID	1790		//regcursor

/* OIDS 2200 - 2299 */
#define REGPROCEDUREOID 2202		//regprocedure
#define REGOPEROID		2203		//regoper
#define REGOPERATOROID	2204		//regoperator
#define REGCLASSOID		2205		//regclass
#define REGTYPEOID		2206		//regtype
#define REGROLEOID		4096		//regrole
#define REGNAMESPACEOID 4089		//regnamespace
#define REGTYPEARRAYOID 2211		//_regtype

/* uuid */
#define UUIDOID 2950				//uuid

/* pg_lsn */
#define LSNOID			3220		//pg_lsn

/* text search */
#define TSVECTOROID		3614		//tsvector
#define GTSVECTOROID	3642		//gtsvector
#define TSQUERYOID		3615		//tsquery
#define REGCONFIGOID	3734		//regconfig
#define REGDICTIONARYOID	3769	//regdictionary

/* jsonb */
#define JSONBOID 3802				//jsonb

/* range types */
#define INT4RANGEOID 3904			//int4range

/* pseudo-types */
#define RECORDOID		2249		//record
#define RECORDARRAYOID	2287		//_record
#define CSTRINGOID		2275		//cstring
#define ANYOID			2276		//any
#define ANYARRAYOID		2277		//anyarray
#define VOIDOID			2278		//void
#define TRIGGEROID		2279		//trigger
#define EVTTRIGGEROID 3838			//event_trigger
#define LANGUAGE_HANDLEROID 2280	//language_handler
#define INTERNALOID		2281		//internal
#define OPAQUEOID		2282		//opaque
#define ANYELEMENTOID	2283		//anyelement
#define ANYNONARRAYOID	2776		//anynonarray
#define ANYENUMOID		3500		//anyenum
#define FDW_HANDLEROID	3115		//fdw_handler
#define INDEX_AM_HANDLEROID 325		//index_am_handler
#define TSM_HANDLEROID	3310		//tsm_handler
#define ANYRANGEOID		3831		//anyrange