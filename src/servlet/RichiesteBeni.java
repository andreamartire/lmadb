package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.ConnectionManager;
import util.MailSender;
import util.SequencerDB;

/**
 * Servlet implementation class RichiesteBeni
 */
public class RichiesteBeni extends HttpServlet {
	private static final long serialVersionUID = 1L;
	Connection conn;
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("dipendente/gestionerichiestebene.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletOutputStream out = response.getOutputStream();

		conn=ConnectionManager.getConnection();

		out.println(
				"<html>" +
				"<head>" +
				"<title>Esito Richiesta</title>" +
				"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />" +
				"</head>" +
				"<body>" +
		"<center><i><font size=5> Profilo Dipendente<font></i></center><hr>");

		HttpSession sess = request.getSession(false);
		if( sess == null || !sess.getAttribute("type").equals("dipendente") ) {
			out.println(
					"<font size=4>Errore di autenticazione.</font><br>" +
					"<a href=login.html><button>Login</button></a>" +
					"</body></html>"
			);
			return;
		}
		//Leggo la sotto_categoria_bene, e la motivazione

		String nomesottocategoriabene = request.getParameter("nomeSottoCategoriaBene");
		String codicesottocategoriabene = null;

		String nomeDipendente=null;
		String cognomeDipendente=null;
		String email = null;
		String motivazione=request.getParameter("motivazione");
		String usr=(String) sess.getAttribute("name");


		try{
			//Mi prendo la matricola;
			PreparedStatement st=conn.prepareStatement("SELECT nome, cognome, personale, email FROM account, personale WHERE personale = matricola AND username=?");
			st.setString(1, usr);
			ResultSet rs=st.executeQuery();
			rs.next();
			int matricola=rs.getInt("personale");
			nomeDipendente=rs.getString("nome");
			cognomeDipendente=rs.getString("cognome");
			email = rs.getString("email");
			//Mi prendo il codice della sottocategoria
			st=conn.prepareStatement("SELECT codice FROM sottocategoriabene WHERE nome=?");
			st.setString(1,nomesottocategoriabene);
			rs=st.executeQuery();
			rs.next();
			codicesottocategoriabene=rs.getString("codice");
			int codiceRichiesta;

			st=conn.prepareStatement("SELECT categoria_bene FROM sottocategoriabene WHERE nome=?");
			st.setString(1,nomesottocategoriabene);
			rs=st.executeQuery();
			rs.next();
			String codiceCategoria=rs.getString("categoria_bene");

			st=conn.prepareStatement("INSERT INTO richiesta VALUES ( ?, ?, ?, current_date, ?, ?)");
			try {
				codiceRichiesta=SequencerDB.nextval("richieste");
				st.setInt( 1, codiceRichiesta );
			} catch (Exception e) {
				System.out.println("errore SequencerDB");
				return;
			}
			st.setInt(2, matricola);
			st.setString(3, codicesottocategoriabene);
			st.setString(4 ,motivazione);
			st.setString(5, "-");

			try{
				st.executeUpdate();
			} catch(Exception e){
				System.err.println("Errore executeUpdate");
				return;
			}

			String subj="Richiesta Sottocategoria "+codicesottocategoriabene+" Dipendente "+matricola;

			String body="Mime-Version: 1.0;\nContent-Type: text/html;\n" +
			"Richiesta: "+codiceRichiesta+" \n" +
			"Dipendente: "+matricola+" - "+" "+cognomeDipendente+" "+nomeDipendente+"\n" +
			"Sotto Categoria: "+codicesottocategoriabene+" - "+nomesottocategoriabene+"\n" +
			"Motivazione: "+motivazione;

			if(codiceCategoria.equals("SA")){
				st=conn.prepareStatement("SELECT email FROM account WHERE tipologia = ?");
				st.setString(1, "amministratore");
			}
			else{
				st=conn.prepareStatement("SELECT A.email FROM Account A WHERE A.tipologia = ?");
				st.setString(1, "addetto amministrativo");
			}

			rs = st.executeQuery();
			if(rs.isBeforeFirst()) {
				while(rs.next()){
					MailSender.sendMail(email, rs.getString("email"), subj, body);
				}
			}
		}catch (SQLException e) {
			e.printStackTrace();
			System.err.println("error");
			return;
		}

		out.println("<center><font size=4>Richiesta Inserita, Sarei rindirizzato fra pochi secondi alla Pagina Gestione Richieste Bene</font></center><br>" +
				"<meta http-equiv=\"refresh\" content=5; url=dipendente/gestionerichiestebene.jsp></body>"+
		"<center><a href=dipendente/gestionerichiestebene.jsp><button>Clicca qui se non vuoi aspettare oltre</button></a></center></html>");
	}
}


