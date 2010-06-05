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
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.ConnectionManager;

/**
 * Servlet implementation class ModificaSottocategoria
 */
public class ModificaSottocategoria extends HttpServlet {
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
		
		String codice = "", nome = "", categoriaBene="";
		
		try {
			codice = request.getParameter("codice");
			nome = request.getParameter("nome");
			categoriaBene = request.getParameter("nomeCategoriaBene");		
		} catch (Exception e) {
			response.sendRedirect("common/gestioneSottocategoria.jsp?codiceSott=" + codice + "&done=false");
			return;
		}
		
		try {
			PreparedStatement pst = conn.prepareStatement("SELECT * FROM CategoriaBene WHERE nome = ?");
			pst.setString(1, categoriaBene );
			ResultSet res = pst.executeQuery();
			if(res.next()){
				categoriaBene = res.getString("sigla");
			}
			
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		try {
			PreparedStatement st = conn.prepareStatement("UPDATE SottoCategoriaBene SET nome = ?, categoria_bene = ? WHERE codice = ?");
			st.setString( 1, nome );
			st.setString( 2, categoriaBene );
			st.setString( 3, codice );
			st.executeUpdate();
			conn.commit();
			response.sendRedirect("common/gestioneSottocategoria.jsp?codiceSottoCategoria=" + codice + "&done=true");
		} catch (SQLException e) {
			response.sendRedirect("common/gestioneSottocategoria.jsp?codiceSottoCategoria=" + codice + "&done=false");
		}
	}

}
