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
