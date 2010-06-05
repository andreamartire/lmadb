<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Assegnazione Beni</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
	<%! String cat = ""; %>
	<%
	
	cat = request.getParameter("cat");
	if( cat == null || ( !cat.equals("SA") && !cat.equals("MB/MA") ) ) {
		%>
		<p><i><font size="4">Errore - Categoria trovata</font></i></p>
		<p><a href="gestionerichieste.jsp"><button>Indietro</button></a></p>
		<%
		return;
	}
	
	HttpSession sess = request.getSession(false);
	if( sess == null ) {
		%>
		<p><i><font size="4">Sessione scaduta. Rieffettuare il login</font></i></p>
		<p><a href="/lmadb"><button>Login</button></a></p>
		<%
		return;
	} 
	if( (sess.getAttribute("type").equals("amministratore") && cat.equals("MB/MA")) ||
		(sess.getAttribute("type").equals("addetto amministrativo") && cat.equals("SA")) ||
		(sess.getAttribute("type").equals("dipendente")) ) {
		%>
		<p><i><font size="4">Autenticazione fallita</font></i></p>
		<p><a href="/lmadb"><button>Login</button></a></p>
		<%
		return;
	} 
	
	if( cat.equals("SA") ) {
		%>
		<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
		<p><i><font size=4>Assegnazione Beni di categoria SA</font></i></p>
		<%
	} else {
		%>
		<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
		<p><i><font size=4>Assegnazione Beni di categoria MB/MA</font></i></p>
		<%
	}
	
		%>
		<ul type="circle">
			<li>
				<a href="assegnabene.jsp?cat=<%=cat %>">Assegna un bene</a>
			</li>
			<li>
				<a href="visualizzaassegnazioni.jsp?cat=<%=cat %>">Visualizza le assegnazioni</a>
			</li>
		</ul>
		
		<p><a href="gestionerichieste.jsp"><button>Indietro</button></a></p>
		<%
	%>
</body>
</html>