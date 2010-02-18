<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="jdbc.JDBC"%><html>
<%! 
Connection conn;

public void init() {
	try {
		Class.forName( JDBC.oracleDriver );
		conn = DriverManager.getConnection( JDBC.oracleUrl, "basididati", "basididati" );
		
	} catch (Exception e) {
	}
}
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test jsp</title>
</head>
<body>
<form action="http://localhost:14998/lmadb/JspTest.jsp" method="post" name="form" onsubmit="return check(this)">
	Username: <input type="text" name="username"></input><br></br>
	Password: <input type="password" name="password"></input><p></p>
	<input type="submit" name="submit" value="LogIn"></input>
</form>
<script type="text/javascript">
function check( form ) {
	if( form.username.value == "" || form.password.value == "" ) {
		window.alert("Insert username and password!");
		return false;
	}
	return true;
}
</script>

<%
String usr = request.getParameter("username");
String psw = request.getParameter("password");

if( conn != null ) {
	if( usr != null && psw != null ) {
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery("SELECT * FROM account");
		boolean found = false;
		while( rs.next() ) {
			if( rs.getString(1).equals(usr) &&
				rs.getString(2).equals(psw) ) {
				found = true;
			}
		}
		if( found == true ) {
			%> <font size="2" color="RED">Hi <% out.println(usr); %> !</font> <%
		} else {
			%> <font size="2" color="RED"><% out.println(usr); %> is not a registered account!</font> <%
		}
	} else {
		%> <font size="2" color="BLUE">Insert username and password</font> <%
	}
} else {
	out.println("Connection ERROR");
}%>
</body>
</html>