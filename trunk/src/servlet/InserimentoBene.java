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
import java.text.SimpleDateFormat;

import util.ConnectionManager;
import util.SequencerDB;


/**
 * Servlet implementation class InserimentoBene
 */
public class InserimentoBene extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    Connection conn;

    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletOutputStream out = response.getOutputStream();
		
		out.println(
				"<html>" +
				"<head>" +
					"<title>Inserisci Bene</title>" +
					"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />" +
				"</head>" +
				"<body>");
		
		HttpSession sess = request.getSession(false);
		if( sess == null || (!sess.getAttribute("type").equals("amministratore") 
				&& !sess.getAttribute("type").equals("addetto amministrativo"))) {
			out.println(
					"<font size=4>Errore di autenticazione.</font><br>" +
					"<a href=login.html><button>Login</button></a>" +
					"</body></html>"
			);
			return;
		}
		
		conn = ConnectionManager.getConnection();
		String categ, sottoCateg, importo, dt_aq, garanzia, 
			dt_at, dt_sc, targ, desc, obso, conf, forn;
		try {
			categ = request.getParameter("categ");
			try {
				PreparedStatement st = conn.prepareStatement(
						"SELECT sigla FROM categoriabene WHERE nome = ?");
				st.setString(1, categ);
				ResultSet rs = st.executeQuery();
				rs.next();
				categ = rs.getString(1);
				System.out.println(categ);
			} catch (Exception e) {
				System.err.println("Fuck");
				return;
			}
			sottoCateg = request.getParameter("sottoCateg");
			importo = request.getParameter("importo");
			dt_aq = request.getParameter("dt_aq");
			garanzia = request.getParameter("garanzia");
			dt_at = request.getParameter("dt_at");
			dt_sc = request.getParameter("dt_sc");
			targ = request.getParameter("targ");
			desc = request.getParameter("desc");
			obso = request.getParameter("obsoleto");
			conf = request.getParameter("conforme");
			forn = request.getParameter("fornitore");
		} catch (Exception e) {
			response.sendRedirect( "common/visualizzaBeni.jsp" );
			return;
		}
		PreparedStatement st = null;
		try {
			// transazione
			conn = ConnectionManager.getConnection();
			conn.setAutoCommit(false);
			
			st = conn.prepareStatement( 
					"INSERT INTO bene VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )" );
			int num_inv_gen = SequencerDB.nextval("bene");
			String num_inv_ser = String.valueOf(SequencerDB.nextval(categ)+"/"+categ);
			st.setInt( 1, num_inv_gen );
			st.setString( 2, num_inv_ser);
			st.setInt( 3, Integer.parseInt(importo) );
			SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
			Date data = new Date(formatter.parse(dt_aq).getTime());
			st.setDate( 4, data );
			st.setString( 5, garanzia );
			if( !dt_at.isEmpty() ) {
				data = new Date(formatter.parse(dt_at).getTime());
				st.setDate( 6, data );
			} else {
				st.setDate( 6, null );
			}
			if( !dt_sc.isEmpty() ) {
				data = new Date(formatter.parse(dt_sc).getTime());
				st.setDate( 7, data );
			} else {
				st.setDate( 7, null );
			}
			st.setString( 8, targ );
			st.setString( 9, desc );
			st.setString( 10, conf );
			st.setString( 11, obso );
			st.setString( 12, sottoCateg );
			st.setString( 13, forn );
			
			st.executeUpdate();
			
		} catch (Exception e) {
			out.println("<p><font size=3>Impossibile inserire il bene</font></p></body></html>");
			e.printStackTrace();
			System.err.println("errore inserimento bene");
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
			
			response.sendRedirect("common/visualizzaBeni.jsp");
		} catch (Exception e) {
			System.out.println("commit error");
			return;
		}
	}

}
