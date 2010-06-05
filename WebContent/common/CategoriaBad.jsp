<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Categoria Bad</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
</head>

<body>
	<%
	HttpSession sess = request.getSession(false);
	
	if( sess.getAttribute("type").equals("addetto amministrativo") ) {
		%><center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr> <%
	}
	else if ( sess.getAttribute("type").equals("amministratore") ){
		%><center><i><font size="5">Profilo Amministratore</font></i></center><hr> <%
	}
	
	if( sess == null ) {
		response.sendRedirect("Login");
		return;
	}
%>
	<center> 
		<h3>Errore nell'inserimento della categoria di beni</h3> <br>
		<a href="gestioneCategorie.jsp"><button>Ok</button></a>
	</center>
</body>

</html>