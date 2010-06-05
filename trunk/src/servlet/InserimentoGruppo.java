package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.ConnectionManager;

/**
 * Servlet implementation class InserimentoGruppo
 */
public class InserimentoGruppo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletOutputStream out = response.getOutputStream();
		
		out.println(
				"<html>" +
				"<head>" +
					"<title>Creazione gruppo di lavoro</title>" +
					"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />" +
				"</head>" +
				"<body>" + 
					"<center><i><font size=5>Profilo Amministratore</font></i></center><hr>");
		
		HttpSession sess = request.getSession(false);
		if( sess == null || !sess.getAttribute("type").equals("amministratore") ) {
			out.println(
					"<font>Errore di autenticazione.</font><br>" +
					"<a href=login.html><button>LogIn</button></a>" +
					"</body></html>"
			);
			return;
		}
		
		String codice, denominazione;
		try {
			codice = request.getParameter("codice");
			denominazione = request.getParameter("nome");
		} catch (Exception e) {
			response.sendRedirect( "amministratore/inserimentogruppo.html" );
			return;
		}
		Connection conn = ConnectionManager.getConnection();
		try {
			conn.setAutoCommit(false);
			PreparedStatement st = conn.prepareStatement( "INSERT INTO gruppodilavoro VALUES ( ?, ? )" );
			st.setString( 1, codice );
			st.setString( 2, denominazione );
			
			st.executeUpdate();
			conn.commit();
			conn.setAutoCommit(true);
			out.println("<p><font size=3 colour=\"RED\">Gruppo \"" + denominazione + "\" creato.</font></p>" +
					"<a href=amministratore/gestionegruppi.jsp><button>Indietro</button></a>");
			
		} catch (Exception e) {
			try {
				conn.rollback();
				conn.setAutoCommit(true);
			} catch (SQLException e1) {}
			out.println("<p><font size=3 colour=\"RED\">Impossibile creare il gruppo</font></p>" +
				"<a href=amministratore/inserimentogruppo.html><button>Indietro</button></a>");
		}
		
		out.println("</body></html>");
	}

}
