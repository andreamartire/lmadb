<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.*"%>
<%@ page import="util.ConnectionManager" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inserimento Fornitore</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<script type="text/javascript">
/** 
 * Funzione di controllo della correttezza dei dati inseriti
 */
function check( form ) {
	if( form.nome.value == "" || form.tipologia.value == "" || form.partita_iva.value == ""){
		window.alert("Inserisci correttamente i valori");
		return false;
	}
	if ( !form.partita_iva.value.match( /^\d{11}$/i )) {
		window.alert("Inserisci correttamente la partita iva");
		return false;
	}
	if ( form.tipologia.value == "-" ) {
		window.alert("Scegli la tipologia");
		return false;
	}
	if ( form.email.value != "" && !form.email.value.match( /^[\d\w]+\@[\d\w]+\.[\d\w]+$/i )) {
		window.alert("Inserisci correttamente l'email");
		return false;
	}
	return true;
}
</script>

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
	<p><i><font size="4">Inserimento Nuovo Fornitore</font></i></p>

<!-- Form di inserimento dati fornitore -->
<form name="form1" action="../InserimentoFornitore" method="get" onsubmit="return check(this)">
	<table cellspacing="5">
	<tr><td align="right">Partita Iva*:</td> 	<td><input type="text" name="partita_iva" size="50"/></td></tr>
	<tr><td align="right">Organizzazione*:</td> 	<td><input type="text" name="nome" size="50"/></td></tr>
	<tr><td align="right">Tipologia*:</td> 	
		<td>
			<select name='tipologia'>
				<option value="banca">banca</option>
				<option value="azienda">azienda</option>
				<option value="ente pubblico">ente pubblico</option>
				<option value="persona fisica">persona fisica</option>
				<option value="-" selected>-</option>
			</select>
		</td>
	</tr>
	<tr><td align="right">Telefono:</td> 	<td><input type="text" name="telefono" size="50"/></td></tr>
	<tr><td align="right">Email:</td> 	<td><input type="text" name="email" size="50"/></td></tr>
	<tr><td align="right">Indirizzo:</td> 	<td><input type="text" name="indirizzo" size="50"/></td>
	<td><input type=submit value="Inserisci"></td></tr>
	</table>
</form>
<p><a href="gestioneFornitori.jsp"><button>Indietro</button></a></p>
</body>
</html>