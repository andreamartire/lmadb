<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Gestione Beni</title>

<link rel="stylesheet" type="text/css" href="../style.css" />

<%!
Connection conn;

%>

</head>


<body><%
	
	HttpSession sess = request.getSession(false);
	if( sess == null ) {
		%>
		<p><i><font size="4">Sessione scaduta. Rieffettuare il login</font></i></p>
		<p><a href="/lmadb"><button>Login</button></a></p>
		<%
		return;
	} 
	if( sess.getAttribute("type").equals("amministratore") ){%>
		<center><i><font size="5">Profilo Amministratore</font></i></center><hr><%
	}
	else if ( sess.getAttribute("type").equals("addetto amministrativo") ) {%>
		<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr><%
	}
	else {
		%>
		<p><i><font size="4">Autenticazione fallita</font></i></p>
		<p><a href="/lmadb"><button>Login</button></a></p>
		<%
		return;
	} 
		%>
		<font size=3>Visualizza Beni: </font>
		<form action="../GestioneBeni">
			<input type="hidden" name="cat" value="asd">
			<input type="radio" name="esito" value="tutti" checked>Tutti
			<input type="radio" name="esito" value="disponibili">Disponibili      
			<input type="submit" value="Visualizza">
		</form>
		
	<%if( sess.getAttribute("type").equals("amministratore") ){%>
		<p><a href="gestioneBeniCatForn.jsp"><button>Indietro</button></a></p><%
	}
	else if ( sess.getAttribute("type").equals("addetto amministrativo") ) {%>
		<p><a href="gestioneBeniCatForn.jsp"><button>Indietro</button></a></p><%
	}%>
</body>
</html>