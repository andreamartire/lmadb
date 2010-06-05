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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.ConnectionManager;

import java.sql.*;

/**
 * Servlet implementation class EliminaAssegnazione
 */
public class EliminaAssegnazione extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String assegnatari = request.getParameter("assegnatari");
		String codice = request.getParameter("codice");
		
		Connection conn = ConnectionManager.getConnection();
		String sql;
		if( assegnatari.equals("gruppi") ) {
			sql = "DELETE FROM assegnazione WHERE codice = ?";
		} else {
			sql = "DELETE FROM dotazione WHERE codice = ?";
		}
		
		try {
			PreparedStatement st = conn.prepareStatement(sql);
			st.setString(1, codice);
			st.executeUpdate();
			
			String from = request.getHeader("referer");
			response.sendRedirect(from + "&deleted=true");
		} catch (Exception e) {
			String from = request.getHeader("referer");
			response.sendRedirect(from + "&deleted=false");
		}
	}

}
