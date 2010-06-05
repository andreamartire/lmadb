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
 * Servlet implementation class ModificaDipendente
 */
public class ModificaDipendente extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = ConnectionManager.getConnection();
		
		String nome = "", cognome = "", cf = "";
		int matricola;
		try {
			matricola = Integer.parseInt( request.getParameter("matricola") );
			nome = request.getParameter("nome");
			cognome = request.getParameter("cognome");
			cf = request.getParameter("cf");
		} catch (Exception e) {
			response.sendRedirect("amministratore/gestionedipendente.jsp?matr=" + request.getParameter("matricola") + "&done=false");
			return;
		}
		
		try {
			PreparedStatement st = conn.prepareStatement("UPDATE personale SET nome = ?, cognome = ?, codice_fiscale = ? WHERE matricola = ?");
			st.setString( 1, nome );
			st.setString( 2, cognome );
			st.setString( 3, cf );
			st.setInt( 4, matricola );
			st.executeUpdate();
			conn.commit();
			response.sendRedirect("amministratore/gestionedipendente.jsp?matr=" + matricola + "&done=true");
		} catch (SQLException e) {
			response.sendRedirect("amministratore/gestionedipendente.jsp?matr=" + matricola + "&done=false");
		}
	}
}
