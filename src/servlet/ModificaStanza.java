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

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.ConnectionManager;

/**
 * Servlet implementation class modificaStanza
 */
public class ModificaStanza extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ModificaStanza() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = ConnectionManager.getConnection();
		
		String codice = "", denominazione = "", posizione = "", note = "";
		try {
			codice = request.getParameter("codice");
			denominazione = request.getParameter("denominazione");
			posizione = request.getParameter("posizione");
			note = request.getParameter("note");
			System.out.println(codice+"-"+denominazione+"-"+posizione+"-"+note);
			
		} catch (Exception e) {
			response.sendRedirect("addetto/gestioneStanza.jsp?idStanza=" + codice + "&done=false");
			return;
		}
		System.out.println("codice stanza letto = "+codice);

		try {
			PreparedStatement st = conn.prepareStatement("UPDATE STANZA SET denominazione = ?, posizione = ?, note = ? WHERE codice = ?");
			st.setString( 1, denominazione );
			st.setString( 2, posizione );
			st.setString( 3, note );
			st.setString( 4, codice );
			st.executeUpdate();
			conn.commit();
			System.out.println("codice stanza = "+codice);
			response.sendRedirect("addetto/gestioneStanza.jsp?idStanza=" + codice + "&done=true");
		} catch (SQLException e) {
			response.sendRedirect("addetto/gestioneStanza.jsp?idStanza=" + codice + "&done=false");
		}
	}
}
