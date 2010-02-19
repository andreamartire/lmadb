

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class StringRevert
 */
public class StringReverse extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		try {
			String string = request.getParameter("stringa");
			String reverse = "";
			
			char[] tmp = string.toCharArray();
			
			for( int i = tmp.length - 1; i >= 0; i-- ) {
				reverse = reverse + tmp[i];
			}
			
			out.println(
					"<html>" +
					"<head>" +
					"<title>String Revert</title>" +
					"</head>" +
					"<body>" +
					"<font size=4>Entered string: \"" + string + "\" - reverse: \"" + reverse + "\"</font>" +
					"</body>" +
					"</html>"
			);
		} catch (Exception e) {
			response.sendRedirect( "http://localhost:8080/stringa.html" );
		}
	}

}
