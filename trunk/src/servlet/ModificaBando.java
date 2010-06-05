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
public class ModificaBando extends HttpServlet {
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
		
		String codice = "", legge, denominazione, data, percentuale;
		
		try {
			codice = request.getParameter("codice");
			System.out.println("codice letto "+codice);
			legge = request.getParameter("legge");
			data = request.getParameter("data").split(" ")[0];
			denominazione = request.getParameter("denominazione");
			percentuale  = request.getParameter("percentuale");
		} catch (Exception e) {
			response.sendRedirect("common/gestioneBando.jsp?codice=" + codice + "&done=false");
			return;
		}
		
		try {
			PreparedStatement st = conn.prepareStatement("UPDATE bando SET legge = ?, denominazione = ?, data_bando = ?, percentuale_finanziamento = ? WHERE codice = ?");
			st.setString( 1, legge );
			st.setString( 2, denominazione );
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			Date dataConv = new Date(formatter.parse(data).getTime());
			st.setDate( 3, dataConv );
			st.setString( 4, percentuale );
			st.setString( 5, codice );
			st.executeUpdate();
			conn.commit();
			response.sendRedirect("common/gestioneBando.jsp?codice=" + codice + "&done=true");
		} catch (Exception e) {
			response.sendRedirect("common/gestioneBando.jsp?codice=" + codice + "&done=false");
		}
	}

}
