<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.*"%>
<%@ page import="util.ConnectionManager" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inserimento Bando</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<script type="text/javascript">
/** 
 * Funzione di controllo della correttezza dei dati inseriti
 */
function check( form ) {
	if ( form.legge.value == "" ) {
		window.alert("Inserisci la Legge");
		return false;
	}
	if ( form.denominazione.value == "" ) {
		window.alert("Inserisci la Denominazione");
		return false;
	}
	if ( form.data.value == "" ) {
		window.alert("Inserisci la data");
		return false;
	}
	var dataRegExp = /^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-(19|20)\d\d$/;
	if ( !form.data.value.match( dataRegExp ) ) {
		window.alert("Inserisci la data nel formato dd-MM-yyyy. es: 03-01-2010");
		return false;
	}
	if ( form.percentuale.value == "" || parseInt( form.percentuale.value ) > 100 || parseInt( form.percentuale.value ) < 0 ) {
		window.alert("Inserisci la percentuale corretta");
		return false;
	}
	return true;
}
</script>

</head>
<body>
	<%! Connection conn; %>
	<%
	HttpSession sess = request.getSession(false);
	
	if( sess == null ) {
		response.sendRedirect("Login");
		return;
	}
	
	try {
		if( sess.getAttribute("type").equals("addetto amministrativo") ||
				sess.getAttribute("type").equals("amministratore") ) {
		} else {
			%> <h2>Sei un impostore</h2><br>
			<a href="Logout"><button>Logout</button></a>
			<%
		}
	} catch ( Exception e ) {
		response.sendRedirect("Login");
	}
	
	conn = ConnectionManager.getConnection();
	%>
	<%if(sess.getAttribute("type").equals("amministratore")){ 
	%> <center><i><font size="5">Profilo Amministratore</font></i></center><hr><%} 
	else { 
	%> <center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr><%} %>
	<p><i><font size="4">Inserimento Nuovo Bando</font></i></p>

<!-- Form di inserimento dati personale -->
<form name="form1" action="../InserimentoBando" method="get" onsubmit="return check(this)">
	<table cellspacing="5">
	<tr><td align="right">Legge*:</td> 	<td><input type="text" name="legge" size="50"/></td></tr>
	<tr><td align="right">Denominazione*:</td> 	<td><input type="text" name="denominazione" size="50"/></td></tr>
	<tr><td align="right">Data*:</td> 	<td><input type="text" name="data" size="50"/></td></tr>
	<tr><td align="right">% Finanziamento*:</td> 	<td><input type="text" name="percentuale" size="50"/></td>
	<td><input type=submit value="Inserisci"></td></tr>
	</table>
</form>
<p><a href="gestioneBandi.jsp"><button>Indietro</button></a></p>
</body>
</html>