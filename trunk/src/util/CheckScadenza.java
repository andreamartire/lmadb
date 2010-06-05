package util;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import jdbc.JDBC;

public class CheckScadenza {
	
	public static void main(String[] args) {
		CheckScadenza cs = new CheckScadenza();
		cs.check();
	}
	
	public void check() {
		Connection conn;
		try {
			Class.forName( JDBC.postgresDriver );
			conn = DriverManager.getConnection( JDBC.postgresUrl, "basididati", "basididati" );
		} catch (Exception e) {
			System.err.println("Errore connessione");
			return;
		}	
		
		String query = 
			"SELECT * FROM bene B, sottoCategoriaBene S " +
			"WHERE S.categoria_bene = 'SA' AND B.sotto_categoria_bene = S.codice";
		
		try {
			Date today = new Date( new java.util.Date().getTime() );
			System.out.println("Data odierna: " + today);
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(query);
			while( rs.next() ){
				Date data_scadenza = rs.getDate("data_scadenza");
				if( data_scadenza != null ) {
					System.out.println("Data scadenza bene " + rs.getInt("numero_inventario_generico") + 
							": " + data_scadenza);
					
					long differenza = (data_scadenza.getTime() - today.getTime())/(1000*24*3600);
					
					System.out.println("Giorni alla scadenza - " + differenza);
					
					if( differenza == 30 || differenza == 15 || differenza == 1 ) {
						int bene = rs.getInt("numero_inventario_generico");
						String targhetta = rs.getString("targhetta");
						
						System.out.println("Scadenza del bene n. " + bene +
								" fra " + differenza + " giorni");
						
						rs = st.executeQuery("SELECT email FROM account WHERE tipologia = 'amministratore'");
						while( rs.next() ) {
							MailSender.sendMail( "alert@lmadb.it", rs.getString(1),
								"Scadenza licenza bene n. " + bene,
								"Attenzione! \n" +
								"La licenza del bene n. " + bene + " targhetta: '" + targhetta + 
								"' scade fra " + differenza + " giorni");
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
