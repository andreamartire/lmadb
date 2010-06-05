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
 * Servlet implementation class modificaStanza
 */
public class ModificaStanza extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ModificaStanza() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = ConnectionManager.getConnection();
		
		String codice = "", denominazione = "", posizione = "", note = "";
		try {
			codice = request.getParameter("codice");
			denominazione = request.getParameter("denominazione");
			posizione = request.getParameter("posizione");
			note = request.getParameter("note");
			System.out.println(codice+"-"+denominazione+"-"+posizione+"-"+note);
			
		} catch (Exception e) {
			response.sendRedirect("addetto/gestioneStanza.jsp?idStanza=" + codice + "&done=false");
			return;
		}
		System.out.println("codice stanza letto = "+codice);

		try {
			PreparedStatement st = conn.prepareStatement("UPDATE STANZA SET denominazione = ?, posizione = ?, note = ? WHERE codice = ?");
			st.setString( 1, denominazione );
			st.setString( 2, posizione );
			st.setString( 3, note );
			st.setString( 4, codice );
			st.executeUpdate();
			conn.commit();
			System.out.println("codice stanza = "+codice);
			response.sendRedirect("addetto/gestioneStanza.jsp?idStanza=" + codice + "&done=true");
		} catch (SQLException e) {
			response.sendRedirect("addetto/gestioneStanza.jsp?idStanza=" + codice + "&done=false");
		}
	}
}
