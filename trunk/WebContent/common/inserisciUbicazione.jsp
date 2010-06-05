<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.*"%>
<%@ page import="util.ConnectionManager" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inserimento Ubicazione</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<script type="text/javascript">
/** 
 * Funzione di controllo della correttezza dei dati inseriti
 */
function check( form ) {
	if ( form.bene.value == "-" ) {
		window.alert("Scegli un bene");
		return false;
	}
	if ( form.stanza.value == "-" ) {
		window.alert("Scegli una stanza");
		return false;
	}
	var dataRegExp = /^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-(19|20)\d\d$/;
	if ( !form.dt_in.value.match( dataRegExp ) ) {
		window.alert("Inserisci la data nel formato dd-MM-yyyy. es: 03-01-2010");
		return false;
	}
	if ( !form.dt_fn.value.match( dataRegExp ) ) {
		window.alert("Inserisci la data nel formato dd-MM-yyyy. es: 03-01-2010");
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

<%!
public ResultSet getBeniNonUbicati() throws Exception{
	Connection conn=ConnectionManager.getConnection();
	Statement st1=conn.createStatement();
	return st1.executeQuery(
			"SELECT B.numero_inventario_generico FROM bene B "+
			"WHERE B.numero_inventario_generico NOT IN (SELECT U.bene FROM ubicazione U)");
}

public ResultSet getStanze() throws Exception{
	Connection conn=ConnectionManager.getConnection();
	Statement st1=conn.createStatement();
	return st1.executeQuery(
			"SELECT * FROM stanza");
}
%>
	<p><i><font size="4">Inserimento Nuova Ubicazione</font></i></p>

<!-- Form di inserimento dati fornitore -->
<form name="form1" action="../InserimentoUbicazione" method="get" onsubmit="return check(this)">
	<table cellspacing="5">
	<tr><td align="right">Bene:</td><td>
		<select name="bene">
			<option value="-" selected>-</option>
		<%
			ResultSet rs = getBeniNonUbicati();
			while( rs.next() ) {%>
				<option value="<%=rs.getString("numero_inventario_generico")%>"><%=rs.getString("numero_inventario_generico")%></option><%
			}
		%>
		</select></td>
	</tr>
	<tr><td align="right">Stanza:</td> 	<td>
	<select name="stanza">
		<option value="-" selected>-</option>
		<%
			ResultSet res = getStanze();
			while( res.next() ) {%>
				<option value="<%=res.getString("codice")%>"><%=res.getString("codice")%></option><%
			}
		%>
		</select></td>
	</tr>
	<tr><td align="right">Data Inizio:</td> 	<td><input type="text" name="dt_in" size="50"/></td></tr>
	<tr><td align="right">Data Fine:</td> 	<td><input type="text" name="dt_fn" size="50"/></td>
	<td><input type=submit value="Inserisci"></td></tr>
	</table>
</form>
<p><a href="GestioneUbicazioni.jsp"><button>Indietro</button></a></p>
</body>
</html>