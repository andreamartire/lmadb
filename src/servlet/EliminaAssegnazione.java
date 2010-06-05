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
