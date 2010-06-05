<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Home Page Dipendente</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
<% 

HttpSession sess = request.getSession(false);

if( sess == null ) {
	response.sendRedirect("../Login");
	return;
}

try {
	if( sess.getAttribute("type").equals("dipendente") ) {
		%>	<center><i><font size="5">Profilo Dipendente</font></i></center><hr>
			<p><font size="2" color="#DF7401">Bentornato <%=sess.getAttribute("name")%></font></p>
			<ul type="circle">
				<li><a href="../common/gestioneAccount.jsp">Gestione Proprio Account</a><br></br></li>
				<li><a href="gestionepostazionegruppo.jsp">Gestione Propria Postazione e Gruppo di Lavoro</a><br></br></li>
				<li><a href="gestioneBeni.jsp">Gestione Beni in Dotazione</a><br></br></li>
				<li><a href="gestionerichiestebene.jsp">Gestione Richieste Beni</a></li>
			</ul>			
			
			
 			<p><a href="../Logout"><button>LogOut</button></a></p>
		<% 
	} else {
		%> <h2>Sei un impostore</h2><br>
		<a href="../Logout"><button>LogOut</button></a>
		<%
	}
} catch ( Exception e ) {
	response.sendRedirect("../Login");
}


%>
</body>
</html>