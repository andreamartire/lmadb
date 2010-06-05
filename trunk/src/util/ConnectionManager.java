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

package util;

import javax.servlet.http.*;
import java.sql.*;

import jdbc.JDBC;

/**
 * ConnectionManager
 */
public class ConnectionManager extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	static Connection conn = null;
	
	public static Connection getConnection() {
		try {
			if( conn == null || conn.isClosed() ) {
				try {
					Class.forName( JDBC.postgresDriver );
					conn = DriverManager.getConnection( JDBC.postgresUrl, "basididati", "basididati" );
					System.out.println("new connection");
					
				} catch (Exception e) {
					System.err.println("Connection not established");
				}
			}
		} catch (SQLException e) {
		}
		
		return conn;
	}
    
	public void destroy() {
		System.out.println("Destroy Connection");
		try {
			conn.close();
			System.out.println("Connection closed");
		} catch (Exception e) {
			System.err.println("Connection not closed");
		}
	}
}
