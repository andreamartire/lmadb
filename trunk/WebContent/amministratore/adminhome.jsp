<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Home Page Amministratore</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
</head>

<body>
	<% 
	
	HttpSession sess = request.getSession(false);
	
	if( sess == null ) {
		response.sendRedirect("/lmadb");
		return;
	}
	
	try {
		if( sess.getAttribute("type").equals("amministratore") ) {
			%> 	<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
				<p><font size="2">Bentornato <%=sess.getAttribute("name")%></font></p>
				
				<ul type="circle">
					<li><a href="../common/gestioneAccount.jsp">Gestione Proprio Account</a></li>
					<li><a href="gestionedipendenti.jsp">Gestione Dipendenti</a><br></li>
					<li><a href="gestionegruppi.jsp">Gestione Gruppi di Lavoro</a></li>
					<li><a href="../common/gestioneBeniCatForn.jsp">Gestione Beni</a></li>
					<li><a href="../common/gestionerichieste.jsp">Gestione Richieste</a></li>
					<li><a href="../common/statistiche.jsp">Statistiche</a></li>
					<!-- <li><a href="importexport.jsp">Data Import/Export</a></li> -->
				</ul>
	 			<p><a href="../Logout"><button>LogOut</button></a></p>
			<% 
		} else {
			%> <h2>Sei un impostore</h2><br>
			<a href="../Logout"><button>LogOut</button></a>
			<%
		}
	} catch ( Exception e ) {
		response.sendRedirect("/lmadb");
	}
	
	
	%>
</body>
</html>