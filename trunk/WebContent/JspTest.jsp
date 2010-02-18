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
Connection conn; %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test jsp</title>
</head>
<body>
<table>
<% 
Class.forName( JDBC.oracleDriver );
%>
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
conn = null;
String usr = request.getParameter("username");
String psw = request.getParameter("password");
try {
	conn = DriverManager.getConnection( JDBC.oracleUrl, usr, psw );
} catch (Exception e) {
	%>
	<font color="red" size="2">Invalid username or password, try again.</font>
<%}

if( conn != null ) {
	Statement st = conn.createStatement();
	out.println( "Hi " + usr + "!" );
	ResultSet rs = st.executeQuery("SELECT * FROM account");
	while( rs.next() ) { %>
		<tr>
		<% for( int i = 1; i <= 3; i++ ) { %>
			<td>
			<% out.println( rs.getString(i) );
		}
	}
}%>
</table>
</body>
</html>