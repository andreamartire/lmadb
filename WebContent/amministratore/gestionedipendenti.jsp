<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC"%>
<%@ page import="java.lang.Thread.State"%>
<%@ page import="util.ConnectionManager"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Gestione Dipendenti</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
<%! 
	Connection conn; 
	
	public ResultSet getDipendenti( String orderby, String nome, String cognome ) throws Exception {
		conn = ConnectionManager.getConnection();
		if( orderby.equals("null") ) {
			orderby = "matricola";
		}
		String sql = 
			"SELECT * " +
			"FROM personale P JOIN account A ON A.personale = P.matricola " +
			"WHERE A.tipologia='dipendente' AND upper(nome) LIKE upper(?) AND upper(cognome) LIKE upper(?)" +
			"ORDER BY " + orderby;
		
		PreparedStatement st = conn.prepareStatement(sql);
		st.setString(1, "%" + nome + "%");
		st.setString(2, "%" + cognome + "%");
		return st.executeQuery();
	}
%>
</head>

<body>
	<%
	HttpSession sess = request.getSession(false);
	if( sess == null || !sess.getAttribute("type").equals("amministratore") ) {
		%><p><i><font size="4">Autenticazione fallita</font></i></p>
		<p>
		<a href="../Login"><button>Indietro</button></a>
		</p><%
		return;
	}
	
	String orderby = request.getParameter("orderby");
	String nome = request.getParameter("nome");
	String cognome = request.getParameter("cognome");
	if( nome == null )
		nome = "";
	if( cognome == null )
		cognome = "";
	%>
	<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
	
	<p><i><font size=4>Gestione Dipendenti</font></i></p>
	
	<p>
		<font size=3>Inserisci un nuovo dipendente</font>
		<a href="inserimentopersonale.html"><button>Inserisci</button></a>
	</p>
	
	<p><font size=3>Elenco dipendenti</font></p>
	
	<font size=2>Filtra risultati</font>
	<form action="gestionedipendenti.jsp">
		<input type="hidden" name="orderby" value="<%=orderby %>" />
		Nome: <input type="text" name="nome" />
		Cognome: <input type="text" name="cognome" />
		<input type="submit" value="Filtra" />
	</form>
	<p></p>
	<%ResultSet rs;
	if( orderby == null ) {
		rs = getDipendenti("matricola", nome, cognome);
	} else {
		rs = getDipendenti(orderby, nome, cognome);
	} 
	if( !rs.isBeforeFirst() ) {
		%><font size=2>Non ci sono dipendente corrispondenti ai dati inseriti</font><%
	} else {
	%>
		<table border="1" cellpadding="3" cellspacing="0">
			<tr>
				<th><a href="gestionedipendenti.jsp?nome=<%=nome %>&cognome=<%=cognome %>&orderby=matricola">Matricola</a></th>
				<th><a href="gestionedipendenti.jsp?nome=<%=nome %>&cognome=<%=cognome %>&orderby=nome">Nome</a></th>
				<th><a href="gestionedipendenti.jsp?nome=<%=nome %>&cognome=<%=cognome %>&orderby=cognome">Cognome</a></th>
				<th><a href="gestionedipendenti.jsp?nome=<%=nome %>&cognome=<%=cognome %>&orderby=codice_fiscale">Codice Fiscale</a></th>
				<th><a href="gestionedipendenti.jsp?nome=<%=nome %>&cognome=<%=cognome %>&orderby=username">Username</a></th>
				<th><a href="gestionedipendenti.jsp?nome=<%=nome %>&cognome=<%=cognome %>&orderby=email">e-Mail</a></th>
				<th>Azione</th>
			</tr>
		<%
		while( rs.next() ) {
			%>
			<tr>
				<td><%=rs.getString("matricola") %></td>
				<td><%=rs.getString("nome") %></td>
				<td><%=rs.getString("cognome") %></td>
				<td><%=rs.getString("codice_fiscale") %></td>
				<td><%=rs.getString("username") %></td>
				<td><%=rs.getString("email") %></td>
				<td><a href=gestionedipendente.jsp?matr=<%= rs.getInt("matricola") %>><button>Modifica</button></a></td>
			</tr>
			<%
		}
		%></table><%
	}
	%>

	<p>
		<a href="adminhome.jsp"><button>Home</button></a>
	</p>

</body>
</html>