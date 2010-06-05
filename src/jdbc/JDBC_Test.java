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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class JDBC_Test {

	public static void main(String[] args) {
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (ClassNotFoundException e) {
			System.out.println("Errore caricamento driver");
			e.printStackTrace();
		}
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		Connection con = null;
		try {
			con = DriverManager.getConnection(url,"basididati","basididati");
		} catch (SQLException e) {
			System.out.println("Impossibile accedere al Database");
			e.printStackTrace();
		}
		Statement st = null;
		try {
			st = con.createStatement();
		} catch (SQLException e) {
			System.out.println("Impossibile creare Statement");
			e.printStackTrace();
		}
		
		ArrayList<String> nomi = new ArrayList<String>();
		nomi.add("andrea");
		nomi.add("salvatore");
		nomi.add("umberto");
		ArrayList<String> cognomi = new ArrayList<String>();
		cognomi.add("martire");
		cognomi.add("loria");
		cognomi.add("agosto");
		
		ResultSet res = null;
		
		//Creazione tabella e inserimento dati
		try {
//			st.executeUpdate("DROP TABLE EsempioJDBC");
			st.executeUpdate("CREATE TABLE EsempioJDBC ( nome VARCHAR(20), cognome VARCHAR(20), PRIMARY KEY (nome) )");
			PreparedStatement pst = con.prepareStatement("INSERT INTO EsempioJDBC Values ( ?, ? )");
			
			for(int i=0; i<nomi.size(); i++){
				pst.setString(1, nomi.get(i));
				pst.setString(2, cognomi.get(i));
				pst.executeUpdate();
			}
			res = st.executeQuery("SELECT * FROM EsempioJDBC");
		} catch (SQLException e) {
			System.out.println("Errore esecuzione Query");
			e.printStackTrace();
		}
		
		
		try {
			while (res.next())
				System.out.println(res.getString(1)+", "+res.getString(2));
		} catch (SQLException e) {
			System.out.println("Errore nel Ciclo");
			e.printStackTrace();
		}
		System.out.println("Fine");
	}

}
