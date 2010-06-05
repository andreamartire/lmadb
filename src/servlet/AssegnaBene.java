package servlet;

import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.ConnectionManager;
import util.SequencerDB;

/**
 * Servlet implementation class AssegnaBene
 */
public class AssegnaBene extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cat = request.getParameter("cat");
		
		// controlli sulla categoria
		String cat1 = cat, cat2;
		if( cat1.equals("MB/MA") ) {
			cat2 = cat1.substring(3);
			cat1 = cat1.substring(0,2);
		} else {
			cat2 = cat1;
		}
		PreparedStatement check;
		
		Connection conn = ConnectionManager.getConnection();
		int bene;
		try {
			bene = Integer.parseInt( request.getParameter("bene") );
			
			check = conn.prepareStatement(
					"SELECT S.categoria_bene " + 
					"FROM bene B JOIN sottocategoriabene S ON B.sotto_categoria_bene = S.codice " + 
					"WHERE B.numero_inventario_generico = ?");
			check.setInt(1, bene);
			
		} catch (Exception e) {
			String referer = request.getHeader("referer");
			response.sendRedirect(referer + "&done=false");
			return;
		}
		String gruppo = request.getParameter("gruppo");
		Date datainizio;
		Date datafine;
		SimpleDateFormat f = new SimpleDateFormat("dd-MM-yyyy");
		try {
			datainizio = new Date( f.parse(request.getParameter("datainizio")).getTime() );
			datafine = new Date( f.parse(request.getParameter("datafine")).getTime() );
		} catch (ParseException e) {
			String referer = request.getHeader("referer");
			response.sendRedirect(referer + "&done=false");
			return;
		}
		
		String note = request.getParameter("note");
		
		if( gruppo != null ) {
			String sql =	
				"INSERT INTO assegnazione VALUES ( " +
					"?, ?, ?, ?, ?, ? )";
			try {
				
				ResultSet rs = check.executeQuery();
				rs.next();
				if( !rs.getString(1).equals(cat1) && !rs.getString(1).equals(cat2) ) {
					response.sendRedirect("common/assegnabene.jsp?cat=" + cat + "&assegnatari=gruppi&done=false");
					return;
				}
				
				rs.close();
				check.close();
				
				PreparedStatement st = conn.prepareStatement(sql);
				
				st.setString(1, "ass" + SequencerDB.nextval("assegnazioni"));
				st.setString( 2, gruppo );
				st.setInt( 3, bene );
				st.setDate( 4, datainizio );
				st.setDate( 5, datafine );
				st.setString( 6, note );
				
				st.executeUpdate();
				st.close();
				
				response.sendRedirect("common/assegnabene.jsp?cat=" + cat + "&assegnatari=gruppi&done=true");
			} catch (Exception e) {
				response.sendRedirect("common/assegnabene.jsp?cat=" + cat + "&assegnatari=gruppi&done=false");
				return;
			}
		} else {
			int dipendente;
			try {
				dipendente = Integer.parseInt( request.getParameter("dipendente") );
			} catch (Exception e) {
				return;
			}
			String sql =	
				"INSERT INTO dotazione VALUES ( " +
					"?, ?, ?, ?, ?, ? )";
			try {
				ResultSet rs = check.executeQuery();
				rs.next();
				if( !rs.getString(1).equals(cat1) && !rs.getString(1).equals(cat2) ) {
					response.sendRedirect("common/assegnabene.jsp?cat=" + cat + "&assegnatari=dipendenti&done=false");
					return;
				}
				rs.close();
				check.close();
				
				PreparedStatement st = conn.prepareStatement(sql);
				
				st.setString(1, "dt" + SequencerDB.nextval("dotazioni"));
				st.setInt( 2, dipendente );
				st.setInt( 3, bene );
				st.setDate( 4, datainizio );
				st.setDate( 5, datafine );
				st.setString( 6, note );
				
				st.executeUpdate();
				st.close();
				response.sendRedirect("common/assegnabene.jsp?cat=" + cat + "&assegnatari=dipendenti&done=true");
			} catch (Exception e) {
				response.sendRedirect("common/assegnabene.jsp?cat=" + cat + "&assegnatari=dipendenti&done=false");
				return;
			}
		}
	}

}
