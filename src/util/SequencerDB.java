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

import java.sql.*;

/** Class <code>Sequencer</code>
 * <p>Classe di utilità per gestire sequenze di un database.<br>
 * Le sequenze vengono mantenute sul database, nella tabella "sequences".
 * </p>
 * <p>Per ottenere il prossimo valore di una sequenza invocare il metodo statico <code>nextval(nome_sequenza)</code><br>
 * Se la sequenza richiesta non esiste viene creata e viene ritornato il primo valore.</p>
 * @author sal
 */
public class SequencerDB {
	private static Connection conn;
	
	/** Funzione <code>nextval( String sequenceName )</code><br>
	 * Ritorna il prossimo valore della sequenza specificata; se la sequenza specificata non esiste 
	 * viene creata e inizializzata.</br>
	 * <p>NB: metodo sincronizzato che prevede la lettura e la successiva scrittura del sequencer su
	 * disco per rendere permanenti le modifiche</p>
	 * 
	 * @param sequenceName - <b>String</b> - Il nome della sequenza
	 * @return <b>int</b> - il prossimo valore della sequenza specificata
	 * 
	 * @throws Exception nel caso in cui ci siano errori di connessione al db
	 */
	public static synchronized int nextval( String sequenceName ) throws Exception {
		// creazione connessione se non già effettuata
		conn = ConnectionManager.getConnection();
		
		// controllo dell'esistenza della tabella sequences nel db, in caso negativo viene creata
		checkSequencesTable();
		
		// creazione sequenza se non esistente
		if( searchSequence( sequenceName ) == false ) {
			if( createSequence( sequenceName ) == false )
				throw new Exception("unable to create the sequence: '" + sequenceName + "'\n");
		}
		
		// ritorno del valore della sequenza richiesta
		return goNext( sequenceName );
	}
	
	/** Funzione <code>checkSequencesTable</code>
	 * <p>Controlla se la tabella "sequences" è presente nel database; in caso negativo la crea.</p>
	 * Tabella "sequences":
	 * <table border=1>
	 * 		<tr><th>NomeCampo</b><th>DataType</b><th>Vincoli</b></tr>
	 * 		<tr><td>name<td>VARCHAR(20)<td>PRIMARY KEY</tr>
	 * 		<tr><td>startval<td>INTEGER<td>NOT NULL</tr>
	 * 		<tr><td>incr<td>INTEGER<td>none</tr>
	 * 		<tr><td>minval<td>INTEGER<td>none</tr>
	 * 		<tr><td>maxval<td>INTEGER<td>none</tr>
	 * 		<tr><td>currval<td>INTEGER<td>none</tr>
	 * 		<tr><td>cycle<td>CHAR(1)<td>CHECK (cycle IN ('T,'F'))</tr>
	 * </table>
	 * 
	 * <br><b>NB</b>: la creazione della tabella viene commitata.
	 */
	private static void checkSequencesTable() {
		try {
			boolean autoCommit = conn.getAutoCommit();
			conn.setAutoCommit(true);
			Statement st = conn.createStatement();
			try {
				st.executeQuery("SELECT * FROM sequences");
			} catch (Exception e) {
				st.execute(
						"CREATE TABLE sequences (" +
							"name VARCHAR(20) PRIMARY KEY," +
							"startval INTEGER NOT NULL," +
							"incr INTEGER," +
							"minval INTEGER," +
							"maxval INTEGER," +
							"currval INTEGER, " +
							"cycle CHAR(1) CHECK (cycle IN ('T', 'F')) " +
						")"
				);
			}
			conn.setAutoCommit(autoCommit);
		} catch (Exception e) {
			System.err.println("unable to create the table");
		}
	}

	/** Funzione <code>goNext</code>
	 * <p>Incrementa il valore corrente della sequenza specificata e lo ritorna.<br>
	 * NB: l'incremento del valore segue le specifiche della sequenza</p>
	 * 
	 * @param sequenceName - (String) nome della sequenza
	 * @return il prossimo valore della sequenza specificata
	 * @throws Exception il metodo lancia una exception nel caso in cui la sequenza sia completa
	 * e il parametro cycle sia false oppure nel caso in cui non si riescano a leggere i parametri della sequenza dal db
	 */
	private static int goNext( String sequenceName ) throws Exception {
		try {
			int currval, maxval, minval, incr;
			boolean cycle;
			
			// lettura dei parametri della sequenza
			PreparedStatement st = conn.prepareStatement( "SELECT * FROM sequences WHERE name = ?" );
			st.setString( 1, sequenceName );
			ResultSet rs = st.executeQuery();
			
			if( rs.next() ) {
				currval = rs.getInt("currval");
				minval = rs.getInt("minval");
				maxval = rs.getInt("maxval");
				incr = rs.getInt("incr");
				if( rs.getString("cycle").equals("T") ) {
					cycle = true;
				} else {
					cycle = false;
				}
			} else {
				throw new Exception("unable to read the sequence parameters");
			}
			
			// controlli per passare al prossimo valore
			currval = currval + incr;
			if( currval > maxval ) {
				if( cycle ) {
					currval = minval;
				} else {
					throw new Exception("sequenza completa");
				}
			}
			
			// aggiornamento database
			st = conn.prepareStatement("UPDATE sequences SET currval = ? WHERE name = ?" );
			st.setInt( 1, currval );
			st.setString( 2, sequenceName ); 
			st.executeUpdate();
			
			// ritorno del valore
			return currval;
			
		} catch (Exception e) {
			System.err.println("goNext error");
			throw new Exception("goNext error");
		}
	}

	/** Funzione <code>createSequence</code>
	 * <p>Crea una sequenza con questo nome, assegnando i valori default:<br>
	 * <table border="1">
	 *   <tr><th>startval</th> <td>0</td></tr>
	 *   <tr><th>increment</th> <td>1</td></tr>
	 *   <tr><th>minval</th> <td>Integer.MIN_VALUE</td></tr>
	 *   <tr><th>maxval</th> <td>Integer.MAX_VALUE</td></tr>
	 *   <tr><th>currval</th> <td>0</td></tr>
	 *   <tr><th>cycle</td> <th>false</td></tr>
	 * </table>
	 * @param sequenceName - (String) nome della sequenza da creare
	 * @return <b>true</b> se l'operazione di creazione è andata a buon fine, <b>false</b> altrimenti
	 */
	private static boolean createSequence( String sequenceName ) {
		try {
			PreparedStatement st = conn.prepareStatement("INSERT INTO sequences VALUES( ?, ?, ?, ?, ?, ?, ? )" );
			st.setString( 1, sequenceName ); 
			st.setInt( 2, 0 );
			st.setInt( 3, 1 );
			st.setInt( 4, Integer.MIN_VALUE );
			st.setInt( 5, Integer.MAX_VALUE );
			st.setInt( 6, 0 );
			st.setString( 7, "F" );
			
			st.executeUpdate();
			
			return true;
			
		} catch (Exception e) {
			System.err.println("create sequence error");
			return false;
		}
	}

	/** Funzione <code>searchSequence</code>
	 * <p>Ritorna <b>true</b> se la sequenza specificata esiste, <b>false</b> altrimenti<p>
	 * @param sequenceName - (String) il nome della sequenza da cercare
	 * @return <b>true</b> se la sequenza specificata esiste, <b>false</b> altrimenti
	 */
	private static boolean searchSequence( String sequenceName ) {
		try {
			PreparedStatement st = conn.prepareStatement("SELECT * FROM sequences WHERE name = ?" );
			st.setString( 1, sequenceName ); 
			ResultSet rs = st.executeQuery();
			
			if( rs.next() ) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			System.err.println("search sequence error");
			return false;
		}
	}
}

