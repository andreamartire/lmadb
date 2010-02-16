<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="jdbc.TestInstallazione"%>
<%@page import="java.sql.DriverManager"%><html>
<%! 
Connection conn; %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test jsp</title>
</head>
<body>
<table>
<% 
Class.forName( TestInstallazione.oracledriver );
conn = DriverManager.getConnection( TestInstallazione.oracleurl, "sal", "asd" );

Statement st = conn.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM account");
while( rs.next() ) { %>
	<tr>
	<% for( int i = 1; i <= 2; i++ ) { %>
		<td>
		<% out.println( rs.getString(i) ); %>
<% }
}%>
</table>
</body>
</html>