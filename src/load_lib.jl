#=*
* Check for libpq library and load library if possible.
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

module lib

paths = []

if (is_windows())
	paths = vcat("C:\\Program Files\\PostgreSQL\\9.5\\bin", paths);
end

const libpq = Libdl.find_library(["libpq", "pq"], paths);

if (isempty(libpq)) 
	error("PostgreSQL libpq driver could not be found!");
end

end
