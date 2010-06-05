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
