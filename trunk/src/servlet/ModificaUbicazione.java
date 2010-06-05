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
import java.sql.Date;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.ConnectionManager;

/**
 * Servlet implementation class ModificaSottocategoria
 */
public class ModificaUbicazione extends HttpServlet {
	private static final long serialVersionUID = 1L;

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
		Connection conn = ConnectionManager.getConnection();
		
		String codice = "", bene, stanza, dt_in, dt_fn;
		
		try {
			codice = request.getParameter("codice");
			bene = request.getParameter("bene");
			stanza = request.getParameter("stanza");
			dt_in = request.getParameter("dt_in");
			dt_fn = request.getParameter("dt_fn");		
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("common/gestioneUbicazione.jsp?codice=" + codice + "&done=false");
			return;
		}
		
		try {
			PreparedStatement st = conn.prepareStatement(
					"UPDATE ubicazione SET codice = ?, bene = ?, stanza = ?, data_inizio = ?, data_fine = ? WHERE codice = ?");
			st.setString( 1, codice );
			st.setInt( 2, Integer.parseInt(bene) );
			st.setString( 3, stanza );
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			Date data = new Date(formatter.parse(dt_in).getTime());
			st.setDate( 4, data );
			data = new Date(formatter.parse(dt_fn).getTime());
			st.setDate( 5, data );
			st.setString( 6, codice );
			st.executeUpdate();
			conn.commit();
			response.sendRedirect("common/gestioneUbicazione.jsp?codice=" + codice + "&done=true");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("common/gestioneUbicazione.jsp?codice=" + codice + "&done=false");
		}
	}

}
