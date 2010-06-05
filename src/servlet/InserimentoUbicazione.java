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