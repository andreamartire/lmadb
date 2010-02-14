package jdbc;

import java.sql.*;
import javax.swing.*;

public class TestInstallazione {
	
	/** parametri di accesso al db... */
	static String username;
	static String pass;
	
	/** stringhe di connessione */
	static String postgresurl = "jdbc:postgresql://localhost/postgres";
	static String oracleurl = "jdbc:oracle:thin:@localhost:1521:xe";
	
	/** drivers */
	static String oracledriver = "oracle.jdbc.driver.OracleDriver";
	static String postgresdriver = "org.postgresql.Driver";
	
	public static void main(String[] args) {
		
		username = JOptionPane.showInputDialog("Username");
		pass = JOptionPane.showInputDialog("Password");
		
		try {
			Class.forName( oracledriver );
			JOptionPane.showMessageDialog(null, "I driver ci sono...vediamo se riesco a connettermi..", 
					"Driver OK", JOptionPane.PLAIN_MESSAGE );
		} catch (ClassNotFoundException e) {
			JOptionPane.showMessageDialog(null, "I driver non sono stati installati correttamente..." +
					"SEGUI LA GUIDA!", "NON HAI SEGUITO LA GUIDA!", JOptionPane.ERROR_MESSAGE );
			return;
		}
		
		Connection connection = null;
		try {
			connection = DriverManager.getConnection( oracleurl, username, pass );
			
			DatabaseMetaData data = connection.getMetaData();
			JOptionPane.showMessageDialog(null, "Si sono riuscito!\nDriver in suo: \"" + 
					data.getDriverName() + "\" versione: " + data.getDriverVersion(), "Connessione OK", JOptionPane.PLAIN_MESSAGE );
		
			connection.close();
		} catch (SQLException e) {
			JOptionPane.showMessageDialog(null, "Non riesco a connettermi! Sicuro che hai avviato il server e mi hai data dati corretti??", 
					"Connessione Fallita", JOptionPane.ERROR_MESSAGE );
		}
	}
}
