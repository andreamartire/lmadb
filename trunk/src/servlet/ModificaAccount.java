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
 * Servlet implementation class ModificaAccount
 */
public class ModificaAccount extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ModificaAccount() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = ConnectionManager.getConnection();
		
		String matricola = "", username = "", email = "", oldusr = "";
		
		try {
			matricola = request.getParameter("matricola");
			oldusr = request.getParameter("oldusername");
			username = request.getParameter("username");
			email = request.getParameter("email");
			
		} catch (Exception e) {
			response.sendRedirect("amministratore/gestionedipendente.jsp?matr=" + matricola + "&done=false");
			return;
		}
		
		try {
			PreparedStatement st = conn.prepareStatement("UPDATE account SET username = ?, email = ? WHERE username = ?");
			st.setString( 1, username );
			st.setString( 2, email );
			st.setString( 3, oldusr );
			st.executeUpdate();
			conn.commit();
			response.sendRedirect("amministratore/gestionedipendente.jsp?matr=" + matricola + "&done=true");
		} catch (SQLException e) {
			response.sendRedirect("amministratore/gestionedipendente.jsp?matr=" + matricola + "&done=false");
		}
	}

}
