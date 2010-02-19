

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Prima
 */
public class Prima extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public Prima() {
        // TODO Auto-generated constructor stub
    }
    
    Connection con;

    public void init () {
    	
    	try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (ClassNotFoundException e) {
			System.out.println("Errore caricamento driver");
			e.printStackTrace();
		}
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		try {
			con = DriverManager.getConnection(url,"basididati","basididati");
		} catch (SQLException e) {
			System.out.println("Impossibile accedere al Database");
			e.printStackTrace();
		}
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		out.println("<html>");
		out.println("<head>");
		out.println("<title>Titolo della pagina </title>");
		out.println("</head>");
		out.println("<body bgcolor=\"white\">");
		out.println("<center> <h1>Intestazione di prova</h1>");
		
		Statement st = null;
		try {
			st = con.createStatement();
		} catch (SQLException e) {
			System.out.println("Impossibile creare Statement");
			e.printStackTrace();
		}
		
		ResultSet res = null;
		
		
		try {
			res = st.executeQuery("SELECT * FROM EsempioJDBC");
		} catch (SQLException e1) {
			System.out.println("Errore Query");
			e1.printStackTrace();
		}
		
		
		
		try {
			while (res.next())
				out.println("<center> <h1>"+res.getString(1)+
						", "+res.getString(2)+"</h1> <center> <br>");
		} catch (SQLException e) {
			System.out.println("Errore nel Ciclo");
			e.printStackTrace();
		}
		System.out.println("Fine");
		out.println("</body>");
		out.println("</html>");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}