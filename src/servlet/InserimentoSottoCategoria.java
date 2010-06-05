package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

import util.ConnectionManager;
import util.SequencerDB;


/**
 * Servlet implementation class InserimentoPersonale
 */
public class InserimentoSottoCategoria extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    Connection conn;

    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		conn = ConnectionManager.getConnection();
		try {
			conn.setAutoCommit(false);
			PreparedStatement pst = conn.prepareStatement(
					"INSERT INTO SottoCategoriaBene VALUES(?,?,?)");
			pst.setString(1, "st" + SequencerDB.nextval("sottoCategoriaBene"));
			pst.setString(2, request.getParameter("nome"));
			pst.setString(3, request.getParameter("nomeCategoriaBene"));
			pst.executeUpdate();
			conn.commit();
			conn.setAutoCommit(true);
			response.sendRedirect("common/gestioneSottoCategorie.jsp");
		}
		catch ( Exception e ) {
			try {
				conn.rollback();
				conn.setAutoCommit(true);
			} catch (SQLException e1) {}
			response.sendRedirect("common/sottoCategoriaBad.html");
		}
	}
}