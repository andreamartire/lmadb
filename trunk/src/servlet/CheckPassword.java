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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.ConnectionManager;

/**
 * Servlet implementation class CheckPassword
 */
public class CheckPassword extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession sess = request.getSession(false);
			
			if( sess == null ) {
				response.sendRedirect("Login");
				return;
			}
			
			Connection connection = ConnectionManager.getConnection();
			PreparedStatement st = connection.prepareStatement(
					"SELECT password FROM Account A where A.username=?");
			String user = (String) sess.getAttribute("name");
			String password = "";
			st.setString(1,user);
			ResultSet res = st.executeQuery();
			if( res.next() ) {
				password = res.getString(1);
			}
			
			String vecchiaPassword = (String) request.getParameter("vecchiaPassword");
			String nuovaPassword = (String) request.getParameter("nuovaPassword");
			
			if(vecchiaPassword.equals(password)){
				PreparedStatement changeSt = connection.prepareStatement(
				"UPDATE Account SET password=? where username=?");
				changeSt.setString(1,nuovaPassword);
				changeSt.setString(2,user);
				changeSt.executeUpdate();
				
				String referer = request.getHeader("referer");
				String redirect;
				if( referer.contains("?") ) {
					redirect = referer.substring(0, referer.lastIndexOf("?")) + "?changepass=true";
				}else
					redirect = referer + "?changepass=true";
				
				response.sendRedirect(redirect);
			}
			else{
				String referer = request.getHeader("referer");
				String redirect;
				if( referer.contains("?") ) {
					redirect = referer.substring(0, referer.lastIndexOf("?")) + "?changepass=false";
				}
				else
					redirect = referer + "?changepass=false";
				
				response.sendRedirect(redirect);
			}
		}
		catch ( Exception e ) {
			String referer = request.getHeader("referer");
			String redirect;
			if( referer.contains("?") ) {
				redirect = referer.substring(0, referer.lastIndexOf("?")) + "?changepass=false";
			}
			else
				redirect = referer + "?changepass=false";
			
			response.sendRedirect(redirect);
		}
	}

}
