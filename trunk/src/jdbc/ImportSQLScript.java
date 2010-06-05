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

import java.io.*;
import java.sql.*;
import java.util.*;

/** Classe per popolare facilmente le tabelle del db a partire da un file scritto nel modo più intuitivo<p>
 *  Ovviamente ancora non sono gestite diverse eccezzioni come campi non presenti ecc
 * 
 * @author sal
 */
public class ImportSQLScript {
	
	/** parametri di accesso al db...ovviamente ognuno deve mettere i suoi! */
	static String username = "database";
	static String pass = "asd";
	
	/** questo url è standard per oracle */
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
