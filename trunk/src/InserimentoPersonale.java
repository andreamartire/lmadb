import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

import jdbc.JDBC;

/**
 * Servlet implementation class InserimentoPersonale
 */
public class InserimentoPersonale extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    Connection conn;
    
    public void init() {
    	try {
			Class.forName( JDBC.oracleDriver );
			
			conn = DriverManager.getConnection( JDBC.oracleUrl, "basididati", "basididati" );
			
		} catch (ClassNotFoundException e) {
			System.err.println("Driver Error");
		} catch (SQLException e) {
			System.err.println("Connection Error");
		}
    }

    public void destroy() {
    	try {
			conn.close();
		} catch (SQLException e) {
		}
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("http://localhost:8181/lmadb/inserimentopersonale.html");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletOutputStream out = response.getOutputStream();
		
		String nome, cognome, cf, mail, username, password, tipologia;
		int matricola;
		try {
			nome = request.getParameter("nome");
			cognome = request.getParameter("cogn");
			cf = request.getParameter("cf");
			mail = request.getParameter("mail");
			username = request.getParameter("usr");
			password = request.getParameter("pass");
			tipologia = request.getParameter("tipo");
			// TODO modificare il campo matricola della tabella personale in integer
			matricola = SequencerDB.nextval("matricole");
			
		} catch (Exception e) {
			response.sendRedirect( "http://localhost:8181/lmadb/inserimentopersonale.html" );
			return;
		}
		
		out.println(
				"<html>" +
				"<head>" +
					"<title>Inserisci Personale</title>" +
				"</head>" +
				"<body>");
		
		try {
			PreparedStatement st = conn.prepareStatement( "INSERT INTO personale VALUES ( ?, ?, ?, ? )" );
			st.setInt( 1, matricola );
			st.setString( 2, cf );
			st.setString( 3, nome );
			st.setString( 4, cognome );
			
			st.executeQuery();
			
			st = conn.prepareStatement( "INSERT INTO account VALUES ( ?, ?, ?, current_date, ?, ? )" );
			st.setString( 1, username );
			st.setString( 2, password );
			st.setString( 3, mail );
			st.setString( 4, tipologia );
			st.setInt( 5, matricola );
			
			st.executeQuery();
			
		} catch (SQLException e) {
			out.println("Errore query insert");
		}
		
		Statement st;
		try {
			st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM personale");
			out.println("<table border=\"1\" bordercolor=\"BLACK\">" + 
					"<tr><td>Matricola<td>Codice Fiscale<td>Nome<td>Cognome"
			);
			
			while( rs.next() ) {
				out.println("<tr>" +
						"<td>" + rs.getString(1) + "<td>" + rs.getString(2) + 
						"<td>" + rs.getString(3) + "<td>" + rs.getString(4)
				);
			}
			
			out.println("</table><p>" +
					"<a href=\"http://localhost:8181/lmadb/inserimentopersonale.html\">" +
					"<button>Create Other</button></a>");
			
			
		} catch (SQLException e) {
			out.println("Errore query select");
		}
		
		out.println("</body></html>");
	}

}
