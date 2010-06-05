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
 * Servlet implementation class ModificaSottocategoria
 */
public class ModificaCategoria extends HttpServlet {
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
		
		String sigla = "", nome = "";
		
		try {
			sigla = request.getParameter("sigla");
			nome = request.getParameter("nome");		
		} catch (Exception e) {
			response.sendRedirect("common/gestioneCategoria.jsp?sigla=" + sigla + "&done=false");
			return;
		}
		
		try {
			PreparedStatement st = conn.prepareStatement("UPDATE CategoriaBene SET nome = ? WHERE sigla = ?");
			st.setString( 1, nome );
			st.setString( 2, sigla );
			st.executeUpdate();
			conn.commit();
			response.sendRedirect("common/gestioneCategoria.jsp?sigla=" + sigla + "&done=true");
		} catch (SQLException e) {
			response.sendRedirect("common/gestioneCategoria.jsp?sigla=" + sigla + "&done=false");
		}
	}

}
