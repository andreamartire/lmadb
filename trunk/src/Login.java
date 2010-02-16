import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import jdbc.TestInstallazione;

/**
 * Servlet implementation class TestServlet
 */
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	Connection conn;
	
	public void init() {
		
		try {
			Class.forName( TestInstallazione.oracledriver );
		} catch (ClassNotFoundException e) {
			System.err.println("Driver error");
			e.printStackTrace();
		}
		
		try {
			conn = DriverManager.getConnection( TestInstallazione.oracleurl, "sal", "asd" );
		} catch (SQLException e) {
			System.err.println("Connection error");
			e.printStackTrace();
		}
		
		/* Metodo alternativo */
//		try {
//			// creo la connessione al dbms
//			// NB: va aggiunta una risorsa nel file context.xml di tomcat per il dbms utilizzato
//			InitialContext cx = new InitialContext();
//			DataSource ds = (DataSource) cx.lookup( "java:comp/env/jdbc/oraclexe" );
//			conn = ds.getConnection();
//			
//		} catch (NamingException e) {
//			System.err.println("C'è qualche errore nel creare il context");
//		} catch (SQLException e) {
//			System.err.println("Non riesco a connettermi! segui la guida per la configurazione!");
//		}
	}
	
	public void destroy() {
		try {
			// chiudo la connessione quando la servlet viene distrutta
			conn.close();
		} catch (SQLException e) {
			// se non si vuole chiudere si frega
		}
	}
	
	protected void doGet( HttpServletRequest request, HttpServletResponse response ) {
		try {
			// se la pagina viene richiesta con una get si viene rediretti alla pagina di login
			response.sendRedirect("http://localhost:8181/lmadb/login.html");
		} catch (Exception e) {
			// se non funziona la redirezione si frega ancora..
		}
	}
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletOutputStream out = response.getOutputStream();
		
		// leggo username e password dalla richiesta
		String usr = request.getParameter("username");
		String psw = request.getParameter("password");
		
		// se la richiesta non è completa redireziono alla pagina di login
		if( psw == null || usr == null ) {
			response.sendRedirect("http://localhost:8181/lmadb/login.html");
			return;
		}
		
		// inizio a preparare la pagina di risposta
		out.println( 
				"<html>" +
				"<head>" +
				"<title>Login</title>" +
				"</head>" +
				"<body>" );
		
		try {
			// eseguo la query per cercare l'account con questo username
			PreparedStatement st = conn.prepareStatement( "SELECT * FROM account WHERE username = ?" );
			st.setString( 1, usr );
			ResultSet rs = st.executeQuery();
			
			/* se il resultset è vuoto, non c'è un account con questo username e glilo dico...
			 * potrebbe essere carino a questo punto tornare alla pagina di login e visualizzare il
			 * messaggio direttamente li...per questo la pagina di login dev'essere una jsp
			 */
			if( !rs.isBeforeFirst() ) {
				out.println( "<h2>" + usr + " non e' un utente registrato!</h2>" +
						"<a href=\"http://localhost:8181/lmadb/login.html\"><button>Riprova</button></a>"  +
						"</body></html>" );
				return;
			}
			
			/* se c'è qualche account con questo username, controllo se la password coincide 
			 * NB: a questo livello considero che username non sia univoco anche se lo è e quindi
			 * sicuramente il resultset avrà una sola riga 
			 */
			boolean check = false;
			while( rs.next() ) {
				if( rs.getString("password").equals( psw ) ) {
					check = true;
				}
			}
			
			/* se la password coincide saluto l'utente...magari potrei redirezionarlo ad una pagina
			 * in base alla sua tipologia
			 */
			if( check == true ) {
				out.println( "<h2>Ciao " + usr + "!</h2><br>" +
						"<a href=\"http://localhost:8181/lmadb/login.html\"><button>LogOut</button></a>" );
				// bla bla
			} else {
				/* altrimenti gli dico che la password è sbagliata..anche qui sarebbe carino redirezionarlo
				 * alla pagina di login e visualizzare il messaggio direttamente li...
				 */
				out.println( "<h2>Non e' questa la password!</h2><br>" +
						"<a href=\"http://localhost:8181/lmadb/login.html\"><button>Riprova</button></a>" );
			} 
			
		} catch (SQLException e) {
			System.err.println("sta query non funziona...che cavolo scrivi?");
			e.printStackTrace();
		}
		
		// completo la pagina
		out.println( 
				"</body>" +
				"</html>" );
	}

}
