<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 

HttpSession sess = request.getSession(false);

if( sess == null ) {
	response.sendRedirect("http://localhost:8181/lmadb/Login");
	return;
}

try {
	if( sess.getAttribute("type").equals("amministratore") ) {
		%> <font size="3">Ciao <%=sess.getAttribute("name")%></font><p>
			<a href="http://localhost:8181/lmadb/gestioneaccount.jsp">Gestione Account</a><br></br>
			<a href="http://localhost:8181/lmadb/gestionedipendenti.jsp">Gestione Dipendenti</a><br></br>
			<a href="http://localhost:8181/lmadb/gestionegruppo.jsp">Gestione Gruppi di Lavoro</a><br></br>
			<a href="http://localhost:8181/lmadb/gestionebeni.jsp">Gestione Beni</a><br></br>
			<a href="http://localhost:8181/lmadb/gestionerichieste.jsp">Gestione Richieste</a></p>
			
 			<a href="http://localhost:8181/lmadb/Logout"><button>LogOut</button></a> 		
		<% 
	} else {
		%> <h2>Sei un impostore</h2><br>
		<a href="http://localhost:8181/lmadb/Logout"><button>LogOut</button></a>
		<%
	}
} catch ( Exception e ) {
	response.sendRedirect("http://localhost:8181/lmadb/Login");
}


%>
</body>
</html>