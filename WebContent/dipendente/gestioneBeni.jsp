<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Beni in Dotazione</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!

HttpSession sess;
%>
</head>
<body>


<%
sess=request.getSession(false);
if( sess == null || !sess.getAttribute("type").equals("dipendente") ) {
	%><p><i><font size="4">Autenticazione fallita</font></i></p>
	<p>
	<a href="../login.html"><button>Indietro</button></a>
	</p><%
	return;
}
%>

<center><i><font size="5">Profilo Dipendente</font></i></center><hr>
<p><font size="3">Gestione Beni in dotazione</font></p>
			<ul type="circle">
				<li><a href="gestioneBeniCorrDot.jsp">Gestione Beni correntemente in dotazione</a><br></br></li>
				<li><a href="gestioneBeniPrecDot.jsp">Gestione Beni avuti in passato in dotazione</a><br></br></li>
				<li><a href="gestioneBeniGruppo.jsp">Gestione Beni assegnati al proprio gruppo di lavoro</a><br></br></li>
				<li><a href="gestioneBeniStanza.jsp">Gestione Beni Ubicati nella propria Stanza</a></li>
			</ul>		
<hr></hr>
</body>

<p><a href="diphome.jsp"><button>Home</button></a></p>

</html>