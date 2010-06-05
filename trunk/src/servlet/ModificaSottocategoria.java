package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.ConnectionManager;

/**
 * Servlet implementation class ModificaSottocategoria
 */
public class ModificaSottocategoria extends HttpServlet {
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
		Connection conn = ConnectionManager.getConnection();
		
		String codice = "", nome = "", categoriaBene="";
		
		try {
			codice = request.getParameter("codice");
			nome = request.getParameter("nome");
			categoriaBene = request.getParameter("nomeCategoriaBene");		
		} catch (Exception e) {
			response.sendRedirect("common/gestioneSottocategoria.jsp?codiceSott=" + codice + "&done=false");
			return;
		}
		
		try {
			PreparedStatement pst = conn.prepareStatement("SELECT * FROM CategoriaBene WHERE nome = ?");
			pst.setString(1, categoriaBene );
			ResultSet res = pst.executeQuery();
			if(res.next()){
				categoriaBene = res.getString("sigla");
			}
			
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		try {
			PreparedStatement st = conn.prepareStatement("UPDATE SottoCategoriaBene SET nome = ?, categoria_bene = ? WHERE codice = ?");
			st.setString( 1, nome );
			st.setString( 2, categoriaBene );
			st.setString( 3, codice );
			st.executeUpdate();
			conn.commit();
			response.sendRedirect("common/gestioneSottocategoria.jsp?codiceSottoCategoria=" + codice + "&done=true");
		} catch (SQLException e) {
			response.sendRedirect("common/gestioneSottocategoria.jsp?codiceSottoCategoria=" + codice + "&done=false");
		}
	}

}
