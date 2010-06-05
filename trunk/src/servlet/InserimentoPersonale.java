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

package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

import util.ConnectionManager;
import util.SequencerDB;


/**
 * Servlet implementation class InserimentoPersonale
 */
public class InserimentoPersonale extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    Connection conn;

    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("amministratore/inserimentopersonale.html");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletOutputStream out = response.getOutputStream();
		
		out.println(
				"<html>" +
				"<head>" +
					"<title>Inserisci Personale</title>" +
					"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />" +
				"</head>" +
				"<body>");
		
		HttpSession sess = request.getSession(false);
		if( sess == null || !sess.getAttribute("type").equals("amministratore") ) {
			out.println(
					"<font size=4>Errore di autenticazione.</font><br>" +
					"<a href=login.html><button>Login</button></a>" +
					"</body></html>"
			);
			return;
		}
		
		String nome, cognome, cf, mail, username, password, tipologia;
		int matricola;
		try {
			nome = request.getParameter("nome");
			cognome = request.getParameter("cogn");
			cf = request.getParameter("cf");
			mail = request.getParameter("mail");
			username = request.getParameter("usr");
			password = request.getParameter("pass");
			tipologia = request.getParameter("tipo");
			
		} catch (Exception e) {
			response.sendRedirect( "amministratore/inserimentopersonale.html" );
			return;
		}
		
		PreparedStatement st = null;
		try {
			// transazione
			conn = ConnectionManager.getConnection();
			conn.setAutoCommit(false);
			
			st = conn.prepareStatement( "INSERT INTO personale VALUES ( ?, ?, ?, ? )" );
			matricola = SequencerDB.nextval("matricole");
			st.setInt( 1, matricola );
			st.setString( 2, cf );
			st.setString( 3, nome );
			st.setString( 4, cognome );
			
			st.executeUpdate();
	
			st = conn.prepareStatement( "INSERT INTO account VALUES ( ?, ?, ?, current_date, ?, ? )" );
			st.setString( 1, username );
			st.setString( 2, password );
			st.setString( 3, mail );
			st.setString( 4, tipologia );
			st.setInt( 5, matricola );
			
			st.executeUpdate();
			
		} catch (Exception e) {
			out.println("<p><font size=3>Impossibile inserire l'account</font></p></body></html>");
			
			System.out.println("errore inserimento personale");
			try {
				conn.rollback();
			} catch (SQLException e1) {
				System.err.println("errore rollback");
				return;
			}
		}
		
		try {
			conn.commit();
			conn.setAutoCommit(true);
			
			response.sendRedirect("amministratore/gestionedipendenti.jsp");
		} catch (Exception e) {
			System.out.println("commit error");
			return;
		}
	}

}
