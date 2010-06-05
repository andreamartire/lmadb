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
public class ModificaFornitore extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = ConnectionManager.getConnection();
		
		String piva, nome, tipologia, telefono, email, indirizzo;
		try {
			piva = request.getParameter("partita_iva");
			nome = request.getParameter("nome");
			tipologia = request.getParameter("tipologia");
			telefono = request.getParameter("telefono");
			email = request.getParameter("email");
			indirizzo = request.getParameter("indirizzo");
		} catch (Exception e) {
			response.sendRedirect("common/gestioneFornitore.jsp?partita_iva=" + request.getParameter("partita_iva") + "&done=false");
			return;
		}
		
		try {
			PreparedStatement st = conn.prepareStatement("UPDATE Fornitore SET nome_organizzazione = ?, tipologia = ?, telefono = ?, email = ?, indirizzo = ? WHERE partita_iva = ?");
			st.setString( 1, nome );
			st.setString( 2, tipologia );
			st.setString( 3, telefono );
			st.setString( 4, email );
			st.setString( 5, indirizzo );
			st.setString( 6, piva );
			st.executeUpdate();
			conn.commit();
			response.sendRedirect("common/gestioneFornitore.jsp?partita_iva=" + request.getParameter("partita_iva") + "&done=true");
		} catch (SQLException e) {
			response.sendRedirect("common/gestioneFornitore.jsp?partita_iva=" + request.getParameter("partita_iva") + "&done=false");
		}
	}
}
