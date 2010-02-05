package testJDBC;

import java.sql.*;
import javax.swing.*;

public class TestInstallazione {
	
	/** parametri di accesso al db...ovviamente ognuno deve mettere i suoi! */
	static String username;
	static String pass;
	
	/** questo url è standard per oracle */
	static String url = "jdbc:oracle:thin:@localhost:1521:xe";
	
	public static void main(String[] args) {
		
		username = JOptionPane.showInputDialog("Username");
		pass = JOptionPane.showInputDialog("Password");
		
		try {
			Class.forName( "oracle.jdbc.driver.OracleDriver" );
			JOptionPane.showMessageDialog(null, "I driver ci sono...vediamo se riesco a connettermi..", 
					"Driver OK", JOptionPane.PLAIN_MESSAGE );
		} catch (ClassNotFoundException e) {
			JOptionPane.showMessageDialog(null, "I driver oracle non sono stati installati correttamente..." +
					"SEGUI LA GUIDA!", "NON HAI SEGUITO LA GUIDA!", JOptionPane.ERROR_MESSAGE );
			return;
		}
		
		Connection connection = null;
		try {
			connection = DriverManager.getConnection( url, username, pass );
			
			DatabaseMetaData data = connection.getMetaData();
			JOptionPane.showMessageDialog(null, "Si sono riuscito!\nDriver in suo: \"" + 
					data.getDriverName() + "\" versione: " + data.getDriverVersion(), "Connessione OK", JOptionPane.PLAIN_MESSAGE );
		} catch (SQLException e) {
			JOptionPane.showMessageDialog(null, "Non riesco a connettermi! Sicuro che hai avviato il server e mi hai data dati corretti??", 
					"Che cazzo fai?", JOptionPane.ERROR_MESSAGE );
		}
	}
}
