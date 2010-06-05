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
 * Servlet implementation class EliminaSottoCategoria
 */
public class EliminaCategoria extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletOutputStream out = response.getOutputStream();
		Connection conn=ConnectionManager.getConnection();
		out.println(
				"<html>" +
				"<head>" +
					"<title>Esito Modifica</title>" +
					"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />" +
				"</head>" +
				"<body>");
		
		HttpSession sess = request.getSession(false);
		if( sess == null || (!sess.getAttribute("type").equals("amministratore") && !sess.getAttribute("type").equals("addetto amministrativo"))) {
			out.println("<p><i><font size=4 color=#FF8000>Autenticazione fallita</font></i></p>"+
			"<p><a href=/lmadb><button>Indietro</button></a></p></body></html>");
			return;
		}
		if(sess.getAttribute("type").equals("amministratore"))
			out.println("<center><i><font size=5> Profilo Ammnistratore<font></i></center><hr>");
		else
			out.println("<center><i><font size=5> Profilo Addetto Amministrativo<font></i></center><hr>");
		
		String codiceCategoria=request.getParameter("sigla");
		try{
			conn.setAutoCommit(false);
			//modifico tutte le sottocategorie
			PreparedStatement st_sot=conn.prepareStatement("UPDATE sottocategoriabene SET categoria_bene=NULL WHERE categoria_bene=?");
			st_sot.setString(1, codiceCategoria);
			st_sot.executeUpdate();
			
			//elimino categoria
			PreparedStatement st=conn.prepareStatement("DELETE FROM categoriabene WHERE sigla=?");
			st.setString(1, codiceCategoria);
			st.executeUpdate();
			conn.commit();
			conn.setAutoCommit(true);
			
			out.println("<center><font size=4>Eliminazione categoria effettuata con successo</font></center><br>" +
			"</body><center><a href=common/gestioneCategorie.jsp><button>Ok</button></a></center></html>");

		}catch(SQLException s){
			s.printStackTrace();
			out.println("<center><font size=4>Errore eliminazione categoria</font></center><br>" +
			"</body><center><a href=common/gestioneCategorie.jsp><button>Ok</button></a></center></html>");
		}
	}

}
