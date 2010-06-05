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
public class InserimentoStanza extends HttpServlet {
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
					"INSERT INTO stanza VALUES(?,?,?,?)");
			pst.setString(1, "stanza" + SequencerDB.nextval("stanza"));
			pst.setString(2, request.getParameter("denominazione"));
			pst.setString(3, request.getParameter("posizione"));
			pst.setString(4, request.getParameter("note"));
			pst.executeUpdate();
			
			conn.commit();
			conn.setAutoCommit(true);
			response.sendRedirect("addetto/gestioneStanze.jsp");
		}
		catch ( Exception e ) {
			try {
				conn.rollback();
				conn.setAutoCommit(true);
			} catch (SQLException e1) {}
			response.sendRedirect(request.getHeader("referer"));
		}
	}
}