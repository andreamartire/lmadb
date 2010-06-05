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

import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Logger;

import org.jdom.DocType;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

/**
 * Classe di utilità per importare ed esportare dati in/da un database
 * NB: dati in formato XML - DTD doctype.dtd
 * 
 * @see #exportData( String fileName )
 * @see #importData( String fileName )
 * 
 * @author Salvatore Loria
 */
public class ImportExport {
	/** documento xml */
	static Document document;
	
	/** radice del documento xml */
	static Element root;
	
	/** tabelle del database */
	static LinkedList<String> tables = new LinkedList<String>();
	static {
		tables.add("sequences");
		tables.add("personale");
		tables.add("account");
		tables.add("fornitore");
		tables.add("categoriabene");
		tables.add("sottocategoriabene");
		tables.add("bene");
		tables.add("bando");
		tables.add("finanziamento");
		tables.add("gruppodilavoro");
		tables.add("richiesta");
		tables.add("stanza");
		tables.add("dotazione");
		tables.add("assegnazione");
		tables.add("allocazione");
		tables.add("ubicazione");
		tables.add("postazione");
	}
	
	/** Esporta i dati del database nel file specificato
	 * <p><b>NB: il file XML è formattato secondo il DTD "doctype.dtd" </b>
	 * @param filename - (String) percorso del file in cui exportare i dati
	 */
	public static boolean exportData( String filename ) {
		// creazione documento xml
		root = new Element("db_import_export");
		document = new Document( root );
		
		// impostazione del DTD 
		DocType doctype = new DocType("root-element");
		doctype.setSystemID("doctype.dtd");
		document.setDocType(doctype);
		
		Connection conn = ConnectionManager.getConnection();
		Statement st;
		ResultSet rs;
		
		for( String tableName : tables ) {
			Element table = new Element("table");
			
			System.out.println(tableName);
			
			table.setAttribute( "name", tableName );
			
			try {
				st = conn.createStatement();
				rs = st.executeQuery("SELECT * FROM " + tableName);
				
				if( rs == null || !rs.isBeforeFirst() ) {
					System.out.println("no data");
				} else {
					while( rs.next() ) {
						Element values = new Element("row");
						table.addContent(values);
						
						System.out.print("\t");
						
						ResultSetMetaData rsmd = rs.getMetaData(); 
						int numColumns = rsmd.getColumnCount(); 
						for (int i=1; i<numColumns+1; i++) { 
							String columnName = rsmd.getColumnName(i); 
							String type = String.valueOf( rsmd.getColumnType(i) );
							String valueString = rs.getString(i);
							
							System.out.print( columnName + ": " + valueString + " - " );
							
							Element value = new Element("data");
							value.setAttribute( "name", columnName );
							value.setAttribute( "type", type );
							value.setText( valueString );
							values.addContent(value);
						}
						System.out.println();
					}
				}
				
				rs.close();
				st.close();
			} catch (SQLException e) {
				System.err.println("Query error");
				return false;
			}
			
			root.addContent( table );
		}
		
		XMLOutputter outputter = new XMLOutputter();
		outputter.setFormat( Format.getPrettyFormat() );
		
		try {
			outputter.output( document, new FileOutputStream( filename ) );
		} catch (Exception e) {
			Logger.getLogger(Logger.GLOBAL_LOGGER_NAME).severe("Error writing export file");
			return false;
		} 
		
		return true;
	}
	
	/** Importa nel database i dati contenuti nel file specificato
	 * <p><b>NB: il file XML deve essere formattato secondo il DTD "doctype.dtd" </b>
	 * @param fileName - (String) percorso del file da cui importare i dati
	 */
	@SuppressWarnings("unchecked")
	public static boolean importData( String fileName ) {
		SAXBuilder b = new SAXBuilder();
		try {
			document = b.build( new File( fileName ) );
			root = document.getRootElement();
			Connection conn = ConnectionManager.getConnection();
			
			List<Element> tables = root.getChildren();
			for( Element table : tables ) {
				 
				System.out.println(table.getAttributeValue("name"));
				
				List<Element> rows = table.getChildren();
				for( Element row : rows ) {
					String sql = "INSERT INTO " + table.getAttributeValue("name") + " VALUES ( ";
					System.out.print("\t");
					
					List<Element> values = row.getChildren();
					for( Element data : values ) {
						sql = sql + "?,";
						System.out.print( data.getAttributeValue("name") + ": " + data.getText() + " - " );
					}
					int last = sql.lastIndexOf(",");
					char[] sqlarray = sql.toCharArray();
					sqlarray[last] = ' ';
					sql = String.copyValueOf(sqlarray);
					sql = sql + ")";
					PreparedStatement st = conn.prepareStatement(sql);
					
					System.out.print(sql);
					
					int i = 1;
					for( Element data : values ) {
						String value = data.getText();
						if( !value.isEmpty() ) 
							st.setObject(i, value, Integer.parseInt( data.getAttributeValue("type") ) );
						else 
							st.setObject(i, null, Integer.parseInt( data.getAttributeValue("type") ) );
						i++;
					}
					
					System.out.println();
					
					try {
						st.executeUpdate();
						System.out.println("\t\tRiga inserita");
						st.close();
						
					} catch (Exception e) {
						System.err.println("\t\timpossibile inserire questa riga in " + 
								table.getAttributeValue("name") + ". Causa: " + e.getMessage() );
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public static void main(String[] args) {
//		exportData("export.xml");
		importData("export.xml");
	}
}
