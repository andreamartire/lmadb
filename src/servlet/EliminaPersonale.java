package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.ConnectionManager;

/**
 * Servlet implementation class Elimina
 */
public class EliminaPersonale extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = ConnectionManager.getConnection();
		
		String todel = request.getParameter("del");
		int matricola = Integer.parseInt( request.getParameter("matr") );
		
		try {
			if( todel.equals("account") ) {
				PreparedStatement st = conn.prepareStatement("DELETE FROM account WHERE personale = ?");
				st.setInt( 1, matricola );
				st.executeUpdate();
			} else if( todel.equals("dipendente") ) {
				conn.setAutoCommit(false);
				// eliminazione account relativo
				PreparedStatement st = conn.prepareStatement("DELETE FROM account WHERE personale = ?");
				st.setInt( 1, matricola );
				st.executeUpdate();
				// eliminazione record relativi in "dotazione"
				st = conn.prepareStatement("DELETE FROM dotazione WHERE personale = ?");
				st.setInt( 1, matricola );
				st.executeUpdate();
				// eliminazione record relativi in "postazione"
				st = conn.prepareStatement("DELETE FROM postazione WHERE personale = ?");
				st.setInt( 1, matricola );
				st.executeUpdate();
				// eliminazione record relativi in "richiesta"
				st = conn.prepareStatement("DELETE FROM richiesta WHERE personale = ?");
				st.setInt( 1, matricola );
				st.executeUpdate();
				// eliminazione record relativi in "allocazione"
				st = conn.prepareStatement("DELETE FROM allocazione WHERE personale = ?");
				st.setInt( 1, matricola );
				st.executeUpdate();
				// eliminazione dipendente
				st = conn.prepareStatement("DELETE FROM personale WHERE matricola = ?");
				st.setInt( 1, matricola );
				st.executeUpdate();
				
				// eliminazione completa, fine transazione
				conn.commit();
				conn.setAutoCommit(true);
			}
			
			response.sendRedirect("amministratore/gestionedipendenti.jsp");
		} catch (Exception e) {
			System.out.println("eliminazione fallita");
			response.sendRedirect("amministratore/gestionedipendente.jsp?matr=" + matricola + "&done=false");
		}
	}
}
