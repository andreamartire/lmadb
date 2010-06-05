<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Propria Postazione e Gruppo di Lavoro</title>
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
<p><font size="3">Gestione Propria Postazione e Gruppo di Lavoro</font></p>
			<ul type="circle">
				<li><a href="gestioneGruppoLavoro.jsp">Gestione Gruppo Di Lavoro</a><br></br></li>
				<li><a href="gestionePropriaPostazione.jsp">Gestione Propria Postazione</a><br></br></li>
			</ul>		
<hr></hr>
</body>

<p><a href="diphome.jsp"><button>Home</button></a></p>

</html>