package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.ConnectionManager;

/**
 * Servlet implementation class modificaStanza
 */
public class modificaBene extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public modificaBene() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = ConnectionManager.getConnection();
		
		int nig = 0, importo; String dt_ac, dt_at, dt_sc, garanzia, conforme, obsoleto, targhetta;
		try {
			nig = Integer.parseInt(request.getParameter("nig"));
//			nis = Integer.parseInt(request.getParameter("nis"));
			importo = Integer.parseInt(request.getParameter("importo"));
			dt_ac = request.getParameter("dt_ac");
			dt_at = request.getParameter("dt_at");
			dt_sc = request.getParameter("dt_sc");
			garanzia = request.getParameter("garanzia");
			conforme = request.getParameter("conforme");
			obsoleto = request.getParameter("obsoleto");
			targhetta = request.getParameter("targ");
			
		} catch (Exception e) {
			response.sendRedirect("common/gestioneBene.jsp?idBene=" + nig + "&done=false");
			return;
		}

		try {
			PreparedStatement st = conn.prepareStatement("UPDATE BENE SET " +
					"importo = ? " +
					", garanzia = ? " +
					", conforme = ? " +
					", obsoleto = ?, data_acquisto = ?, data_attivazione = ?, data_scadenza = ? " +
					", targhetta=? WHERE numero_inventario_generico = ? ");
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			st.setInt( 1, importo );
			st.setString( 2, garanzia );
			st.setString( 3, conforme );
			st.setString( 4, obsoleto );
			try {
				if( !dt_at.equals("") && !dt_at.equals("null") ) {
					Date datt = new Date(formatter.parse(dt_at).getTime());
					st.setDate( 6, datt );
				} else {
					st.setDate( 6, null );
				}
				if( !dt_ac.equals("") && !dt_ac.equals("null") ) {
					Date dacq = new Date(formatter.parse(dt_ac).getTime());
					st.setDate( 5, dacq );
				} else {
					st.setDate( 5, null );
				}
				if( !dt_sc.equals("") && !dt_sc.equals("null") ) {
					Date dscd = new Date(formatter.parse(dt_sc).getTime());
					st.setDate( 7, dscd );
				} else {
					st.setDate( 7, null );
				}
			} catch (ParseException e) {
				System.err.println("errore date");
				return;
			}
			st.setString(8, targhetta);
			st.setInt( 9, nig );
			st.executeUpdate();
			conn.commit();
			response.sendRedirect("common/gestioneBene.jsp?idBene=" + nig + "&done=true");
		} catch (SQLException e) {
			response.sendRedirect("common/gestioneBene.jsp?idBene=" + nig + "&done=false");
			return;
		}
	}
}
