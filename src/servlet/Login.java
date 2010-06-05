package servlet;
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import util.ConnectionManager;

/**
 * Servlet implementation class TestServlet
 */
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	Connection conn;
	
	protected void doGet( HttpServletRequest request, HttpServletResponse response ) {
		try {
			doPost(request, response);
		} catch (Exception e) {
		} 
	}
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletOutputStream out = response.getOutputStream();
		
		conn = ConnectionManager.getConnection();
		
		// leggo username e password dalla richiesta
		String usr = request.getParameter("username");
		String psw = request.getParameter("password");
		
		// se la richiesta non è completa redireziono alla pagina di login
		if( psw == null || usr == null ) {
			response.sendRedirect("login.html");
			return;
		}
		
		// inizio a preparare la pagina di risposta
		out.println( 
				"<html>" +
				"<head>" +
				"<title>Login</title>" +
				"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />" +
				"</head>" +
				"<body>" );
		
		try {
			// eseguo la query per cercare l'account con questo username
			PreparedStatement st = conn.prepareStatement( "SELECT * FROM account WHERE username = ?" );
			st.setString( 1, usr );
			ResultSet rs = st.executeQuery();
			
			/* se il resultset è vuoto, non c'è un account con questo username quindi avviso l'utente
			 */
			if( !rs.isBeforeFirst() ) {
				out.println( "<font size=4>" + usr + " non e' un utente registrato!</font><p>" +
						"<a href=\"login.html\"><button>Riprova</button></a>"  +
						"</body></html>" );
				return;
			}
			
			/* se c'è qualche account con questo username, controllo se la password coincide 
			 */
			String type = "";
			boolean check = false;
			while( rs.next() ) {
				if( rs.getString("password").equals( psw ) ) {
					type = rs.getString("tipologia");
					check = true;
				}
			}
			
			rs.close();
			st.close();
			
			/* se la password coincide..
			 */
			if( check == true ) {
				
				// creo o ottengo la sessione
				HttpSession sess = request.getSession(true);
				
				// inseriamo nella sessione un parametro che identifica il tipo di account
				// collegato in modo da evitare accessi a pagine non di propria competenza
				sess.setAttribute("type", type);
				sess.setAttribute("name", usr);
				
				if( type.equals("amministratore") ) {
					response.sendRedirect("amministratore/adminhome.jsp");
				} else if ( type.equals("addetto amministrativo") ) {
					response.sendRedirect("addetto/addettohome.jsp");
				} else if ( type.equals("dipendente") ) {
					response.sendRedirect("dipendente/diphome.jsp");
				} else {
					response.sendError(404, "chi sei?");
				}
			} else {
				/* altrimenti avviso di password errata
				 */
				out.println( "<font size=4>Password errata</font><p>" +
						"<a href=\"login.html\"><button>Riprova</button></a>" );
			} 
			
		} catch (SQLException e) {
			response.sendRedirect("login.html");
			return;
		}
		
		// completo la pagina
		out.println( 
				"</body>" +
				"</html>" );
	}

}
