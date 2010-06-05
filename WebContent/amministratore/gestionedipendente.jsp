<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="util.ConnectionManager"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Gestione Dipendente</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
</head>


<body>
	<%! Connection conn; %>
	<%
	HttpSession sess = request.getSession(false);
	if( sess == null || !sess.getAttribute("type").equals("amministratore") ) {
		%><p><i><font size="4" color="#FF8000">Autenticazione fallita</font></i></p>
		<p>
		<a href="/lmadb"><button>Indietro</button></a>
		</p><%
		return;
	}
	
	conn = ConnectionManager.getConnection();
	%>
	
	<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
	
	<p><i><font size="4">Gestione dipendente</font></i></p><%
	
	int matricola = Integer.valueOf( request.getParameter("matr") );
	String done =  request.getParameter("done");
	
	if( done != null ) {
		if( done.equals("true") ) {
			%><p><i><font size="2" color="BLUE">Modifica andata a buon fine</font></i></p><%
		} else {
			%><p><i><font size="2" color="RED">Modifica fallita</font></i></p><%
		}
	}
	
	String nome = "", cognome = "", cf = "", email = "", username = "";
	
	PreparedStatement st = conn.prepareStatement("SELECT * FROM personale WHERE matricola = ?");
	st.setInt( 1, matricola );
	ResultSet rs = st.executeQuery();
	
	if( rs.next() ) {
		nome = rs.getString("nome");
		cognome = rs.getString("cognome");
		cf = rs.getString("codice_fiscale");
	} else {
		// TODO
	}
	
	st = conn.prepareStatement("SELECT * FROM account WHERE personale = ?");
	st.setInt( 1, matricola );
	rs = st.executeQuery();
	
	if( rs.next() ) {
		username = rs.getString("username");
		email = rs.getString("email");
	} else {
		// TODO
	}
	%>
	
	<p><font size="3">Informazioni dipendente:</font></p>
	<form action="../ModificaDipendente" method="get">
		<table>
			<tr>
				<td align="right"><i>Matricola:</i></td>
				<td><input type="text" name="matricola" readonly="readonly" value="<%=matricola %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Nome:</i></td>
				<td><input type="text" name="nome" value="<%=nome %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Cognome:</i></td>
				<td><input type="text" name="cognome" value="<%=cognome %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Codice fiscale:</i></td>
				<td><input type="text" name="cf" value="<%=cf %>"></td>
			</tr>
			<tr>
				<td><center><input type=submit value="Salva"></center></td>
				<td><center><a href=../Elimina?del=dipendente&matr=<%=matricola %>><button>Elimina Dipendente</button></a></center></td>
			</tr>
		</table>
	</form>
	
	<p><font size="3">Informazioni account:</font></p>
	<form action="../ModificaAccount" method="get">
		<table>
			<tr>
				<td><input type="hidden" name="matricola" value=<%=matricola %>></input></td>
			</tr>
			<tr>
				<td><input type="hidden" name="oldusername" value=<%=username %>></input></td>
			</tr>
			<tr>
				<td align="right"><i>Username:</i></td>
				<td><input type="text" name="username" value="<%=username %>"></td>
			</tr>
			<tr>
				<td align="right"><i>E-mail:</i></td>
				<td><input type="text" name="email" value="<%=email %>"></td>
			</tr>
			<tr>
				<td><center><input type=submit value="Salva"></center></td>
				<td><center><a href=../Elimina?del=account&matr=<%=matricola %>><button>Elimina Account</button></a></center></td>
			</tr>
		</table>
	</form>
	
	<p>
		<a href="gestionedipendenti.jsp"><button>Indietro</button></a>
	</p>
</body>
</html>