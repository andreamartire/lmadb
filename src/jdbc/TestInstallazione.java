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

import java.sql.*;
import javax.swing.*;

public class TestInstallazione {
	
	/** parametri di accesso al db... */
	static String username;
	static String pass;
	
	public static void main(String[] args) {
		
		username = JOptionPane.showInputDialog("Username");
		pass = JOptionPane.showInputDialog("Password");
		
		try {
			Class.forName( JDBC.postgresDriver );
			JOptionPane.showMessageDialog(null, "I driver ci sono...vediamo se riesco a connettermi..", 
					"Driver OK", JOptionPane.PLAIN_MESSAGE );
		} catch (ClassNotFoundException e) {
			JOptionPane.showMessageDialog(null, "I driver non sono stati installati correttamente..." +
					"SEGUI LA GUIDA!", "NON HAI SEGUITO LA GUIDA!", JOptionPane.ERROR_MESSAGE );
			return;
		}
		
		Connection connection = null;
		try {
			connection = DriverManager.getConnection( JDBC.postgresUrl, username, pass );
			
			DatabaseMetaData data = connection.getMetaData();
			JOptionPane.showMessageDialog(null, "Si sono riuscito!\nDriver in suo: \"" + 
					data.getDriverName() + "\" versione: " + data.getDriverVersion(), "Connessione OK", JOptionPane.PLAIN_MESSAGE );
		
			connection.close();
		} catch (SQLException e) {
			JOptionPane.showMessageDialog(null, "Non riesco a connettermi! Sicuro che hai avviato il server e mi hai data dati corretti??", 
					"Connessione Fallita", JOptionPane.ERROR_MESSAGE );
		}
		
		try {
			connection.close();
			System.out.println("Connessione chiusa");
		} catch (Exception e) {
			System.out.println("connessione non chiusa");
		}
	}
}
