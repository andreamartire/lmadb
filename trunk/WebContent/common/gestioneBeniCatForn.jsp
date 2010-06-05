<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Beni, Categorie, Sottocategorie e Fornitori</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>

<%

HttpSession sess = request.getSession(false);

if( sess.getAttribute("type").equals("addetto amministrativo") ){%>
	<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
	<%
}
else if( sess.getAttribute("type").equals("amministratore") ){%>
	<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
	<%
}%>

<% 

if( sess == null ) {
	response.sendRedirect("Login");
	return;
}

try {
	if( sess.getAttribute("type").equals("addetto amministrativo") ||
			sess.getAttribute("type").equals("amministratore") ) {
		%> 
		<ul type="circle">
			<li><a href="gestioneBeni.jsp">Gestione Beni</a></li>
			<li><a href="gestioneCategorie.jsp">Gestione Categorie</a></li>
			<li><a href="gestioneSottoCategorie.jsp">Gestione SottoCategorie</a></li>
			<li><a href="gestioneFornitori.jsp">Gestione Fornitori</a></li>
			<li><a href="gestioneBandi.jsp">Gestione Bandi</a></li>
			<li><a href="GestioneUbicazioni.jsp">Gestione Ubicazioni</a></li>
		</ul>
		<%
	} else {
		%> <h2>Sei un impostore</h2><br>
		<a href="Logout"><button>Logout</button></a>
		<%
	}
} catch ( Exception e ) {
	response.sendRedirect("Login");
}
%>
<%if( sess.getAttribute("type").equals("addetto amministrativo") ){%>
		<a href="../addetto/addettohome.jsp"><button>Indietro</button></a><%
	}
	else if ( sess.getAttribute("type").equals("amministratore") ) {%>
		<a href="../amministratore/adminhome.jsp"><button>Indietro</button></a><%
	}%>
</body>
</html>