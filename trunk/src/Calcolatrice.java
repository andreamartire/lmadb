

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class InvertiStringa
 */
public class Calcolatrice extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Calcolatrice() {
        super();
        // TODO Auto-generated constructor stub
    }

	/** 
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		try{
			int num1 = Integer.valueOf(request.getParameter("numero1"));
			int num2 = Integer.valueOf(request.getParameter("numero2"));
			char operation = request.getParameter("operazione").charAt(0);
			float res = 0;;
			
			switch( operation ){
				case '+':res = num1 + num2;break;
				case '-':res = num1 - num2;break;
				case '*':res = num1 * num2;break;
				case '/':
					if ( num2 == 0 )
						throw new Exception();
					else
						res = num1 / num2;break;
			}
			
			out.println("<html> <title> Titolo </title> " +
					"<body> <h1> Operazione: "+num1+" "+operation+" "+num2+" = "+res+" </h1>" +
							"<center> <form action=http://localhost:8181/lmadb/calcolatrice.html>" +
							"<input name='riprova' type='submit' value='Riprova'></input>" +
							"</form> </center></body> </html>");
		}
		catch(Exception e){
			out.println("<html> <title> Titolo </title> " +
					"<body> <h1> Errore nella scrittura dei parametri </h1>" +
					"<center> <form action=http://localhost:8181/lmadb/calcolatrice.html>" +
					"<input name='riprova' type='submit' value='Riprova'></input>" +
					"</form> </center></body> </html>");
		}
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}