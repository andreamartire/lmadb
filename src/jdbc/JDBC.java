/**
 * Copyright (C) 2010 Salvatore Loria, Andrea Martire, Agosto Umberto
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 51
 * Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

package jdbc;

public class JDBC {
	/** stringa di connessione per postgresql */
	public static final String postgresUrl = "jdbc:postgresql://localhost/lmadb";
	/** stringa di connessione per oracle */
	public static final String oracleUrl = "jdbc:oracle:thin:@localhost:1521:xe";
	
	/** driver jdbc per oracle */
	public static final String oracleDriver = "oracle.jdbc.driver.OracleDriver";
	/** driver jdbc per postgreSQL */
	public static final String postgresDriver = "org.postgresql.Driver";
}
