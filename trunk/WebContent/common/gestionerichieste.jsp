<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Gestione Richieste</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
	<%! String type = ""; %>
	<%
	HttpSession sess = request.getSession(false);
	if( sess == null ) {
		%>
		<p><i><font size="4" color="#FF8000">Sessione scaduta. Rieffettuare il login</font></i></p>
		<p><a href="/lmadb"><button>Login</button></a></p>
		<%
		return;
	} else if( sess.getAttribute("type").equals("amministratore") ) {
		type = "amministratore";
	} else if( sess.getAttribute("type").equals("addetto amministrativo") ) {
		type = "addetto";
	} else {
		%>
		<p><i><font size="4" color="#FF8000">Autenticazione fallita</font></i></p>
		<p><a href="/lmadb"><button>Login</button></a></p>
		<%
		return;
	}

	
	if( type.equals("amministratore") ) {
		%>
		<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
		<p><i><font size=4>Gestione Richieste SA</font></i></p>
		
		<ul type="circle">
			<li><a href="richieste.jsp?cat=SA">Visualizzazione Richieste</a></li>
			<li><a href="assegnazionebeni.jsp?cat=SA">Assegnazione Beni</a><br></li>
		</ul>
		
		<p><a href="../amministratore/adminhome.jsp"><button>Home</button></a></p>
		<%
	} else {
		%>
		<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
		<p><i><font size=4>Gestione Richieste MB/MA</font></i></p>
		
		<ul type="circle">
			<li><a href="richieste.jsp?cat=MB/MA">Visualizzazione Richieste</a></li>
			<li><a href="assegnazionebeni.jsp?cat=MB/MA">Assegnazione Beni</a><br></li>
		</ul>
		
		<p><a href="../addetto/addettohome.jsp"><button>Home</button></a></p>
		<%
	}
	%>

</body>
</html>