<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="util.ConnectionManager"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Profilo</title>
<link rel="stylesheet" type="text/css" href="../style.css" />

<script language="Javascript">
	function check( form ) {
		if( form.nuovaPassword.value != form.checkNuovaPassword.value ){
			window.alert("La Nuova Password non e' stata inserita correttamente");
			return false;
		}
		return true;
	}
</script>

</head>
<body>
	<%  
	HttpSession sess = request.getSession(false);
	if( sess == null ) {
		%><p><i><font size="4">Sessione scaduta. Effettua il login</font></i></p>
		<p>
		<a href="login.html"><button>Login</button></a>
		</p><%
		return;
	}
	String type = (String) sess.getAttribute("type");
	
	if( type.equals("addetto amministrativo") ) {
		%><center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr><%
	} else if( type.equals("amministratore") ) {
		%><center><i><font size="5">Profilo Amministratore</font></i></center><hr><%
	} else if( type.equals("dipendente") ) {
		%><center><i><font size="5">Profilo Dipendente</font></i></center><hr><%
	}
	
	String passChanged = request.getParameter("changepass");
	if( passChanged != null ) {
		if( passChanged.equals("true") ) {
			%><p><font size="2">Password cambiata</font></p><%
		} else {
			%><p><font size="2">La password inserita non è corretta</font></p><%	
		}
	}
	
	try {
		Connection connection = ConnectionManager.getConnection();
		PreparedStatement st = connection.prepareStatement(
				"SELECT * FROM Account A, Personale P "+ 
				"WHERE A.username = ? AND A.personale = P.matricola");
		// ottengo username utente
		String user = (String) sess.getAttribute("name");
		// carico dati nella query
		st.setString(1,user);
		// eseguo query
		ResultSet res = st.executeQuery();
		if( res.next() ) {
			%>
			<font size=3>Dati Utente</font>
			<table>
				<tr><td align="right"><b>Nome:</b></td>					<td>&nbsp;&nbsp;&nbsp;<%=res.getString("nome") %></td></tr>
				<tr><td align="right"><b>Cognome:</b></td>				<td>&nbsp;&nbsp;&nbsp;<%=res.getString("cognome") %></td></tr>
				<tr><td align="right"><b>Username:</b></td>				<td>&nbsp;&nbsp;&nbsp;<%=res.getString("username") %></td></tr>
				<tr><td align="right"><b>Email:</b></td>				<td>&nbsp;&nbsp;&nbsp;<%=res.getString("email") %></td></tr>
				<tr><td align="right"><b>Data Registrazione:</b></td>	<td>&nbsp;&nbsp;&nbsp;<%=res.getString("data_registrazione") %></td></tr>
				<tr><td align="right"><b>Tipologia Utente:</b></td>		<td>&nbsp;&nbsp;&nbsp;<%=res.getString("tipologia") %></td></tr>
				<tr><td align="right"><b>Codice Fiscale:</b></td>		<td>&nbsp;&nbsp;&nbsp;<%=res.getString("codice_fiscale") %></td></tr>
			</table>
			<%
		}
	}
	catch ( Exception e ) {
		response.sendError(404, "Database error");
		return;
	}
	%>
	
	<br/><font size=3>Cambio password</font>
	<form name="form_change_pass" method="post" action="../CheckPassword" onsubmit="return check(this)" >
			<table>
				<tr><td align="right"><i>Vecchia Password:</i></td>			<td><input type="password" name="vecchiaPassword"></input></td></tr>
				<tr><td align="right"><i>Nuova Password:</i></td>			<td><input type="password" name="nuovaPassword"></input></td></tr>
				<tr><td align="right"><i>Conferma Nuova Password:</i></td>	<td><input type="password" name="checkNuovaPassword"></input></td></tr>
				<tr><td><center><input type="submit" name="submit" value="Cambia Password" ></input></center></td></tr>
			</table>
	</form>
	<%
	if( type.equals("addetto amministrativo") ) {
		%><p><a href="../addetto/addettohome.jsp"><button>Indietro</button></a></p><%
	} else if( type.equals("amministratore") ) {
		%><p><a href="../amministratore/adminhome.jsp"><button>Indietro</button></a></p><%
	} else if( type.equals("dipendente") ) {
		%><p><a href="../dipendente/diphome.jsp"><button>Indietro</button></a></p><%
	}
	%>
	
</body>

</html>