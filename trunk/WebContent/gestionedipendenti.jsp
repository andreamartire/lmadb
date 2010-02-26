<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.lang.Thread.State"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Dipendenti</title>

<%! 
Connection conn; 

public void init() throws ServletException {
	try {
		Class.forName( JDBC.oracleDriver );
		conn = DriverManager.getConnection( JDBC.oracleUrl, "basididati", "basididati" );
		
	} catch (Exception e) {
	} 
}

public ResultSet getDipendenti() throws Exception {
	Statement st = conn.createStatement();
	return st.executeQuery("SELECT * FROM personale P JOIN account A ON A.personale=P.matricola WHERE A.tipologia='dipendente'");
}
%>
</head>
<body>
Inserisci un nuovo dipendente
<a href="inserimentopersonale.html"><button>Inserisci</button></a>

<table border="1">
<tr><td>Matricola</td><td>Nome</td><td>Cognome</td></tr>
<%
ResultSet rs = getDipendenti();
while( rs.next() ) {
	%>
	<tr><td><%=rs.getString("matricola") %></td><td><%=rs.getString("nome") %></td>
	<td><%=rs.getString("cognome") %></td><td><input type="button" onclick="gestionedipendente" value="Gestisci Dipendente"></td></tr>
	<%
}
%>
</table>


</body>
</html>