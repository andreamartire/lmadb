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