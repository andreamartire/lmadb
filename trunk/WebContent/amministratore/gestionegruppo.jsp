<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.text.SimpleDateFormat"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Gestione Gruppo</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
Connection conn; 

public ResultSet getDipendenti( String codice ) throws Exception {
	conn = ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT P.matricola, P.nome, P.cognome, A.codice, A.data_inizio, A.data_fine " +
			"FROM allocazione A JOIN personale P ON A.personale = P.matricola " +
			"WHERE A.gruppo_di_lavoro = ?" +
			 "AND A.data_inizio <= current_date AND A.data_fine >= current_date");
	st.setString( 1, codice );
	return st.executeQuery();
}

boolean delete( String codice ) throws Exception {
	try {
		conn = ConnectionManager.getConnection();
		PreparedStatement st = conn.prepareStatement(
				"DELETE FROM allocazione WHERE codice = ?");
		st.setString( 1, codice );
		st.executeUpdate();
		return true;
	} catch (Exception e) {
		return false;
	}
}

boolean alloca( int dip, String gruppo, String dtin, String dtfin ) throws Exception {
	try {
		conn = ConnectionManager.getConnection();
		conn.setAutoCommit(false);
		int cod = SequencerDB.nextval("allocazioni");
		PreparedStatement st = conn.prepareStatement(
				"INSERT INTO allocazione VALUES ( ?, ?, ?, ?, ? )");
		st.setInt( 1, cod );
		st.setInt( 2, dip );
		st.setString( 3, gruppo );
		
		SimpleDateFormat f = new SimpleDateFormat( "dd-MM-yyyy" );
		
		st.setDate( 4, new Date( f.parse(dtin).getTime() ) );
		st.setDate( 5, new Date( f.parse(dtfin).getTime() ) );
		
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
		<p><i><font size="4">Autenticazione fallita</font></i></p>
		<p><a href="/lmadb"><button>Indietro</button></a></p>
		<%
		return;
	}
	%>
	
	<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
	
	<p><i><font size=4>Gestione gruppo di lavoro</font></i></p>
	
	<%
	String codice = request.getParameter("codice");
	if( codice == null ) {
		%><p><i><font size=3>Nessun gruppo di lavoro definito</font></i></p><%
		return;
	}
	
	try {
		int dipendente = Integer.parseInt( request.getParameter("dipendente") );
		String datainizio = request.getParameter("datainizio");
		String datafine = request.getParameter("datafine");
		if( datafine != null && datainizio != null ) {
			if( alloca( dipendente, codice, datainizio, datafine ) ) {
				%><p><i><font size=3>Dipendente allocato</font></i></p><%
			} else {
				%><p><i><font size=3>Impossibile allocare il dipendente</font></i></p><%
			}
		} 
	} catch (Exception e) {
	}
	
	String codall = request.getParameter("allocazione");
	if( codall != null ) {
		if( delete( codall ) ) {
			%><p><i><font size=3>Dipendente deallocato</font></i></p><%
		} else {
			%><p><i><font size=3>Impossibile deallocare il dipendente</font></i></p><%
		}
	}
	%>
	
	<p>
		<font>Alloca un dipendente in questo gruppo di lavoro</font>
		<a href="allocadipendente.jsp?gruppo=<%=codice %>"><button>Alloca</button></a>
	</p>
	
	<font size=3>Elenco dipendenti allocati nel gruppo "<%=codice %>"</font>
	<%
	ResultSet rs = getDipendenti( codice );
	if( !rs.isBeforeFirst() ) {
		%><br><font size=2>Nessun dipendente allocato attualmente in questo gruppo"</font><%
	} else {
		%>
		<table border="1">
			<tr>
				<th>Dipendente</th>
				<th>Data inizio</th>
				<th>Data fine</th>
			</tr>
		<%
		while( rs.next() ) {
			%>
			<tr>
				<td><%=rs.getString("matricola")%> - <%=rs.getString("nome") %>  <%=rs.getString("cognome") %></td>
				<td><%=rs.getString("data_inizio") %></td>
				<td><%=rs.getString("data_fine") %></td>
				<td><a href="gestionegruppo.jsp?codice=<%=codice%>&allocazione=<%=rs.getString("codice")%>"><button>Dealloca</button></a></td>
			</tr>
			<%
		}
		%>
		</table><%
	}
	%>
	
	<p>
		<a href="gestionegruppi.jsp"><button>Indietro</button></a>
	</p>
</body>
</html>