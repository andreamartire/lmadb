<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Home Page Addetto Amministrativo Home</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
</head>

<body>
	<% 
	
	HttpSession sess = request.getSession(false);
	
	if( sess == null ) {
		response.sendRedirect("Login");
		return;
	}
	
	try {
		if( sess.getAttribute("type").equals("addetto amministrativo") ) {
			%> 	<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
				<p><font size="2">Bentornato <%=sess.getAttribute("name")%></font></p>
				
				<ul type="circle">
					<li><a href="../common/gestioneAccount.jsp">Gestione Profilo</a></li>
					<li><a href="gestioneStanze.jsp">Gestione Stanze</a></li>
					<li><a href="../common/gestioneBeniCatForn.jsp">Gestione Beni, Categorie, Fornitori</a></li>
					<li><a href="../common/gestionerichieste.jsp">Gestione Richieste</a></li>
					<li><a href="../common/statistiche.jsp">Statistiche</a></li>
				</ul>
				<p><a href="../Logout"><button>Logout</button></a></p>
			<%
		} else {
			%> <h2>Sei un impostore</h2><br>
			<a href="../Logout"><button>Logout</button></a>
			<%
		}
	} catch ( Exception e ) {
		response.sendRedirect("Login");
	}
	
	%>
</body>
</html>