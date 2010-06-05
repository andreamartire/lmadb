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

/**
 * Servlet implementation class InserimentoCategoria
 */
public class InserimentoFornitore extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    Connection conn;

    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		conn = ConnectionManager.getConnection();
		try {
			PreparedStatement pst = conn.prepareStatement(
					"INSERT INTO Fornitore VALUES(?,?,?,?,?,?)");
			pst.setString(1, request.getParameter("partita_iva"));
			pst.setString(2, request.getParameter("nome"));
			pst.setString(3, request.getParameter("tipologia"));
			pst.setString(4, request.getParameter("telefono"));
			pst.setString(5, request.getParameter("email"));
			pst.setString(6, request.getParameter("indirizzo"));
			pst.executeUpdate();
			response.sendRedirect("common/gestioneFornitori.jsp");
		}
		catch ( Exception e ) {
			response.sendRedirect("common/FornitoreBad.jsp");
		}
	}
}