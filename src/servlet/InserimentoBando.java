package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.text.SimpleDateFormat;

import util.ConnectionManager;
import util.SequencerDB;


/**
 * Servlet implementation class InserimentoBando
 */
public class InserimentoBando extends HttpServlet {
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
					"INSERT INTO bando VALUES(?,?,?,?,?)");
			pst.setString(1, "bando" + SequencerDB.nextval("bando") );
			pst.setString(2, request.getParameter("legge"));
			pst.setString(3, request.getParameter("denominazione"));
			
			SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
			String dataString = request.getParameter("data");
			if ( dataString == null )
				dataString = "";
			Date data = new Date(formatter.parse(request.getParameter("data")).getTime());
			
			pst.setDate(4, data);
			pst.setString(5, request.getParameter("percentuale"));
			System.out.println(request.getParameter("legge")+" "+
					request.getParameter("denominazione")
					+" "+data.toString()+" "
					+request.getParameter("percentuale"));
			pst.executeUpdate();
			
			conn.commit();
			conn.setAutoCommit(true);
			
			response.sendRedirect("common/gestioneBandi.jsp");
		}
		catch ( Exception e ) {
			try {
				conn.rollback();
				conn.setAutoCommit(false);
			} catch (SQLException e1) {}
			response.sendRedirect("common/bandoBad.jsp");
		}
	}
}