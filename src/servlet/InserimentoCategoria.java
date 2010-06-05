package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

import util.ConnectionManager;

/**
 * Servlet implementation class InserimentoCategoria
 */
public class InserimentoCategoria extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    Connection conn;

    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		conn = ConnectionManager.getConnection();
		try {
			PreparedStatement pst = conn.prepareStatement(
					"INSERT INTO CategoriaBene VALUES(?,?)");
			pst.setString(1, request.getParameter("sigla"));
			pst.setString(2, request.getParameter("nome"));
			pst.executeUpdate();
			response.sendRedirect("common/gestioneCategorie.jsp");
		}
		catch ( Exception e ) {
			response.sendRedirect("common/CategoriaBad.jsp");
		}
	}
}