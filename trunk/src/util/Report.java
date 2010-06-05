package util;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.GregorianCalendar;

import jdbc.JDBC;

public class Report {
	
	Date d_inizio = null, d_fine = null;

	public static void main(String[] args) {
		Report rp = new Report();
		rp.eseguiReport();
	}
	
	void eseguiReport(){
		// calcola la data inziale e finale del mese precedente
		mesePrecedente();
		ResultSet rs;
		Connection conn;
		try {
			Class.forName( JDBC.postgresDriver );
			conn = DriverManager.getConnection( JDBC.postgresUrl, "basididati", "basididati" );
		} catch (Exception e) {
			return;
		}	
		PreparedStatement st = null;
		try {
			st = conn.prepareStatement(
					"SELECT * FROM bene " +
					"WHERE data_acquisto >= ? AND data_acquisto <= ? " +
					"ORDER BY numero_inventario_generico");
			st.setDate(1, d_inizio);
			st.setDate(2, d_fine);
			rs = st.executeQuery();
		} catch (SQLException e) {
			System.err.println("Errore nell'esecuzione della query");
			return;
		}

		String titoloreport = "Report mensile beni inventariati";
		String TestoReport = "";

		try {
			if(!rs.isBeforeFirst()){
				st=conn.prepareStatement("SELECT A.email FROM Account A WHERE A.tipologia = ?");
				st.setString(1, "addetto amministrativo");
				rs=st.executeQuery();
				
				if(rs.isBeforeFirst())
					while(rs.next()){
						MailSender.sendMail( "report@lmadb.it", rs.getString("email"), titoloreport, 
								"Non è stato inventariato nessun bene dal " + d_inizio + " al " + d_fine);
				 }
					
				st=conn.prepareStatement("SELECT A.email FROM Account A WHERE A.tipologia = ?");
				st.setString(1, "amministratore");
				rs=st.executeQuery();
				
				if(rs.isBeforeFirst())
					while(rs.next())
						MailSender.sendMail( "report@lmadb.it", rs.getString("email"), titoloreport,
								"Non è stato inventariato nessun bene dal " + d_inizio + " al " + d_fine);
				
				return;
			}
			else {
				TestoReport = 
					"Mime-Version: 1.0;\n" +
					"Content-Type: text/html;\n" +
					"<html>" +
						"<body>" +
							"<p><b>Report beni inventariati dal " + d_inizio + " al " + d_fine + "</b></p>" +
							"<table cellspacing=5 cellpadding=0>" +
								"<tr>" +
									"<th>N° inv. gen.</th>" +
									"<th>N° ser. gen.</th>" +
									"<th>Targhetta</th>" +
									"<th>Descrizione</th>" +
									"<th>Importo</th>" +
									"<th>Data acquisto</th>" +
									"<th>Garanzia</th>" +
									"<th>Data scadenza</th>" +
									"<th>Data attivazione</th>" +
									"<th>Conforme</th>" +
									"<th>Obsoleto</th>" +
									"<th>Sottocategoria</th>" +
									"<th>Fornitore<th>" +
								"</tr>";
				while(rs.next()) {
					TestoReport = TestoReport + 
								"<tr>" +
									"<td align=center>" + rs.getString("numero_inventario_generico") + "</td>" +
									"<td align=center>" + rs.getString("numero_inventario_seriale") + "</td>" +
									"<td align=center>" + rs.getString("targhetta") + "</td>" +
									"<td align=center>" + rs.getString("descrizione") + "</td>" +
									"<td align=center>" + rs.getString("importo") + "</td>" +
									"<td align=center>" + rs.getString("data_acquisto") + "</td>" +
									"<td align=center>" + rs.getString("garanzia") + "</td>" +
									"<td align=center>" + rs.getString("data_scadenza") + "</td>" +
									"<td align=center>" + rs.getString("data_attivazione") + "</td>" +
									"<td align=center>" + rs.getString("conforme") + "</td>" +
									"<td align=center>" + rs.getString("obsoleto") + "</td>" +
									"<td align=center>" + rs.getString("sotto_categoria_bene") + "</td>" +
									"<td align=center>" + rs.getString("fornitore") + "</td>" +
								"</tr>";
				}
				TestoReport = TestoReport + 
							"</table>" +
						"</body>" +
					"</html>";
				
				st=conn.prepareStatement("SELECT A.email FROM Account A WHERE A.tipologia = ?");
				st.setString(1, "addetto amministrativo");
				rs=st.executeQuery();
				
				if(rs.isBeforeFirst())
					while(rs.next())
						MailSender.sendMail( "report@lmadb.it",rs.getString("email"),titoloreport,TestoReport);
					
				st=conn.prepareStatement("SELECT A.email FROM Account A WHERE A.tipologia = ?");
				st.setString(1, "amministratore");
				rs=st.executeQuery();
				
				if(rs.isBeforeFirst())
					while(rs.next())
						MailSender.sendMail( "report@lmadb.it",rs.getString("email"),titoloreport,TestoReport);
				
				rs.close();
				st.close();
				return;
			}
		} catch (SQLException e) {System.err.println("Errore nella lettura del ResulSet");}
	}
	
	private void mesePrecedente() {
		GregorianCalendar c = new GregorianCalendar();

		// andiamo al mese precedente...
		c.add(Calendar.MONTH, -1);
		
		// calcola la data iniziale del mese precendente
		c.set(Calendar.DAY_OF_MONTH, 1);
		
		// ecco la data iniziale (java.sql.Date)
		d_inizio = new Date( c.getTime().getTime() );
		
		// calcola la data finale del mese precedente
		int month = c.get(Calendar.MONTH) + 1; // metto in month il mese precedente, in formato classico
		
		// 30 giorni a novembre, con aprile giugno e settembre...
		if( month == 11 || month == 4 || month == 6 || month == 9 ) {
			c.set(Calendar.DATE, 30);
		} else if( month == 2 ) { // di 28 ce n'è uno...
			if( bisestile( c.get(Calendar.YEAR) ) ) { // ammeno che non sia un anno bisestile!
				c.set(Calendar.DATE, 29);
			} else {
				c.set(Calendar.DATE, 28);
			}
		} else { // tutti gli altri ne han 31
			c.set(Calendar.DATE, 31);
		}
		
		// ecco la data finale (java.sql.Date)
		d_fine = new Date( c.getTime().getTime() );
	}

	private boolean bisestile( int year ) {
		if( (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 ) {
			return true;
		} else {
			return false;
		}
	}
}
