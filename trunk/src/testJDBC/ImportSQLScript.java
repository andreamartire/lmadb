package testJDBC;

import java.io.*;
import java.sql.*;
import java.util.*;

public class ImportSQLScript {
	
	static String username = "database";
	static String pass = "asd";
	static String url = "jdbc:oracle:thin:@localhost:1521:xe";
	static Connection connection;
	static PreparedStatement pst;
	static Statement st;
	static String matr, cf, nome, cogn;
	static Scanner reader;
	
	public static void main(String[] args) {
		
		try {
			// inizializzazione 
			init();
			
			pst = connection.prepareStatement( "INSERT INTO PERSONALE VALUES ( ?, ?, ?, ? )" );
			
			// caricamento dei dati letti nel file
			while( readFromFile() ) {
				pst.setString( 1, matr );
				pst.setString( 2, cf );
				pst.setString( 3, nome );
				pst.setString( 4, cogn );
				
				try {
					pst.executeUpdate();
				} catch (Exception e) {
					// se i dati ci sono già non fare niente...
				}
			}
			
			// stampa della tabella modificata
			st = connection.createStatement();
			ResultSet rs = st.executeQuery( "SELECT * FROM PERSONALE" );
			
			while (rs.next()) {
				System.out.println( rs.getString(1) + " " + rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4) );
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	private static void init() throws Exception {
		Class.forName( "oracle.jdbc.driver.OracleDriver" );
		connection = DriverManager.getConnection( url, username, pass );
		
		reader = new Scanner( new File("src/testJDBC/prova") );
		reader.useDelimiter("\n");
	}
	
	private static boolean readFromFile() {
		if( reader.hasNext() ) {
			String[] texts = reader.next().split(" ");
			
			matr = texts[0];
			cf = texts[1];
			nome = texts[2];
			cogn = texts[3];
			
			return true;
		} else {
			return false;
		}
	}
	
}
