<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="jdbc.JDBC;"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Gestione Gruppi</title>

<link rel="stylesheet" type="text/css" href="../style.css" />

<%! 
Connection conn; 

public ResultSet getGruppi( String orderby, String nome ) throws Exception {
	conn = ConnectionManager.getConnection();
	String sql ="SELECT * FROM gruppodilavoro " +
				"WHERE upper(denominazione) LIKE upper(?) " +
				"ORDER BY " + orderby;
	PreparedStatement st = conn.prepareStatement(sql);
	st.setString(1, "%" + nome + "%");
	return st.executeQuery();
}

boolean elimina( String codice ) {
	conn = ConnectionManager.getConnection();
	try {
		conn.setAutoCommit(false);
		String deleteAssegnazione = "DELETE FROM assegnazione WHERE gruppo_di_lavoro = ?";
		String deleteAllocazione = "DELETE FROM allocazione WHERE gruppo_di_lavoro = ?";
		String deleteGruppo = "DELETE FROM gruppodilavoro WHERE codice = ?";
		
		PreparedStatement st = conn.prepareStatement(deleteAssegnazione);
		st.setString( 1, codice );
		st.executeUpdate();
		
		st = conn.prepareStatement(deleteAllocazione);
		st.setString( 1, codice );
		st.executeUpdate();
		
		st = conn.prepareStatement(deleteGruppo);
		st.setString( 1, codice );
		st.executeUpdate();
		
		conn.commit();
		conn.setAutoCommit(true);
		return true;
	} catch (Exception e) {
		return false;
	}
}
%>
</head>


<body>
	<%
	HttpSession sess = request.getSession(false);
	if( sess == null || !sess.getAttribute("type").equals("amministratore") ) {
		%>
		<p><i><font size="4" color="#FF8000">Autenticazione fallita</font></i></p>
		<p><a href="/lmadb"><button>Indietro</button></a></p>
		<%
		return;
	}
	String cod = request.getParameter("elimina");
	if( cod != null ) {
		if( elimina( cod ) ) {
			%><p><i><font size=3>Gruppo eliminato</font></i></p><%
		} else {
			%><p><i><font size=3>Impossibile eliminare il gruppo</font></i></p><%
		}
	}
	%>
	<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
	
	<p><i><font size=4>Gestione Gruppi</font></i></p>
	
	<p>
		<font size=3>Inserisci un nuovo gruppo di lavoro</font>
		<a href="inserimentogruppo.html"><button>Inserisci</button></a>
	</p>
	
	<p><font size=3>Elenco gruppi di lavoro</font></p>
	<%
	String orderby = request.getParameter("orderby");
	String nome = request.getParameter("nome");
	if( nome == null ) {
		nome = "";
	}
	%>
	<font size=2>Filtra risultati</font>
	<form action="gestionegruppi.jsp">
		<input type="hidden" name="orderby" value="<%=orderby %>" />
		Denominazione: <input type="text" name="nome" />
		<input type="submit" value="Filtra" />
	</form>
	<p></p>
	<%
	ResultSet rs;
	if( orderby == null ) {
		rs = getGruppi("codice", nome);
	} else {
		rs = getGruppi(orderby, nome);
	}
	if( !rs.isBeforeFirst() ) {
		%><br><font size=2>Nessun gruppo di lavoro presente</font><%
	} else {
		%>
		<table border="1" cellpadding="3" cellspacing="0">
			<tr>
				<th><a href="gestionegruppi.jsp?orderby=codice">Codice</a></th>
				<th><a href="gestionegruppi.jsp?orderby=denominazione">Denominazione</a></th>
				<th></th>
				<th></th>
			</tr>
			<%
			while( rs.next() ) {
				%>
				<tr>
					<td><%=rs.getString("codice") %></td>
					<td><%=rs.getString("denominazione") %></td>
					<td><a href=gestionegruppo.jsp?codice=<%=rs.getString("codice")%>><button>Dipendenti</button></a></td>
					<td><a href="gestionegruppi.jsp?elimina=<%=rs.getString("codice")%>"><button>Elimina</button></a></td>
				</tr>
				<%
			}
		%>
		</table>
		<%
	}
	%>
	
	<p><a href="adminhome.jsp"><button>Home</button></a></p>

</body>
</html>