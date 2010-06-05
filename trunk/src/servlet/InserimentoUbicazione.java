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
 * Servlet implementation class InserimentoUbicazione
 */
public class InserimentoUbicazione extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    Connection conn;

    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		conn = ConnectionManager.getConnection();
		try {
			PreparedStatement pst = conn.prepareStatement(
					"INSERT INTO ubicazione VALUES(?,?,?,?,?)");
			pst.setInt(1, SequencerDB.nextval("ubicazione"));
			pst.setInt(2, Integer.parseInt(request.getParameter("bene")));
			pst.setString(3, request.getParameter("stanza"));
			
			SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
			Date data = new Date(formatter.parse(request.getParameter("dt_in")).getTime());
			pst.setDate( 4, data );
			data = new Date(formatter.parse(request.getParameter("dt_fn")).getTime());
			pst.setDate( 5, data );
			pst.executeUpdate();
			response.sendRedirect("common/GestioneUbicazioni.jsp");
		}
		catch ( Exception e ) {
			e.printStackTrace();
			response.sendRedirect("common/ubicazioneBad.jsp");
		}
	}
}