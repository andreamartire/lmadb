<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Gestione Richieste</title>

<link rel="stylesheet" type="text/css" href="../style.css" />

<%!
Connection conn;

public ResultSet getRichieste( String esito, String orderby, String cat1 ) throws Exception {
	conn = ConnectionManager.getConnection();
	
	String query = 	"SELECT R.codice, R.personale, R.data, S.codice AS st, S.nome, R.esito " +
					"FROM richiesta R JOIN sottocategoriabene S ON S.codice = R.sotto_categoria_bene " +
					"WHERE esito = ? AND (S.categoria_bene = ? OR S.categoria_bene = ?) ";
	String cat2;
	if( cat1.equals("MB/MA") ) {
		cat2 = cat1.substring(3);
		cat1 = cat1.substring(0,2);
	} else {
		cat2 = cat1;
	}
	
	if( orderby.equals("dipendente") ) {
		query = query + "ORDER BY personale";
	} else if( orderby.equals("sottocategoria") ) {
		query = query + "ORDER BY sotto_categoria_bene";
	} else {
		query = query + "ORDER BY data";
	}
	
	PreparedStatement st = conn.prepareStatement( query );
	
	if( esito.equals("accettate") ) {
		st.setString(1, "S");
	} else if ( esito.equals("rifiutate") ) {
		st.setString(1, "N");
	} else {
		st.setString(1, "-");
	}
	st.setString(2, cat1);
	st.setString(3, cat2);
	return st.executeQuery();
}
%>

</head>


<body>
	<%! String cat = ""; %>
	<%
	
	cat = request.getParameter("cat");
	if( cat == null || ( !cat.equals("SA") && !cat.equals("MB/MA") ) ) {
		%>
		<p><i><font size="4">Errore</font></i></p>
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
		<p><i><font size=4>Richieste SA</font></i></p>
		<%
	} else {
		%>
		<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
		<p><i><font size=4>Richieste MB/MA</font></i></p>
		<%
	}

	String esito = request.getParameter("esito");
	if( esito == null ) 
		esito = "pendenti";
	%>
	<p><font size=3>Visualizza richieste: </font></p>
	
	<%
	if( esito.equals("pendenti") ) {%>
		<input type="radio" checked onclick="self.document.location.href='richieste.jsp?cat=<%=cat %>&esito=pendenti';">Pendenti
	<%} else { %>
		<input type="radio" onclick="self.document.location.href='richieste.jsp?cat=<%=cat %>&esito=pendenti';">Pendenti
	<%} 
	if( esito.equals("accettate") ) {%>
		<input type="radio" checked onclick="self.document.location.href='richieste.jsp?cat=<%=cat %>&esito=accettate';">Accettate
	<%} else {%>
		<input type="radio" onclick="self.document.location.href='richieste.jsp?cat=<%=cat %>&esito=accettate';">Accettate
	<%}
	if( esito.equals("rifiutate") ) {%>
		<input type="radio" checked onclick="self.document.location.href='richieste.jsp?cat=<%=cat %>&esito=rifiutate';">Rifiutate
	<%} else {%>
		<input type="radio" onclick="self.document.location.href='richieste.jsp?cat=<%=cat %>&esito=rifiutate';">Rifiutate
	<%}%>
	<p></p>
	<%
	String orderby = request.getParameter("orderby");
	ResultSet rs;
	if( orderby == null ) {
		rs = getRichieste( esito, "data", cat );
	} else {
		rs = getRichieste( esito, orderby, cat );
	}
	
	if( !rs.isBeforeFirst() ) {
		%><p><font size=2>Non ci sono richieste <%=esito %></font></p><%
	} else {
		%>
		<table border="1" cellpadding="3" cellspacing="0">
			<tr>
				<th><a href="richieste.jsp?cat=<%=cat %>&esito=<%=esito%>&orderby=dipendente">Dipendente</a></th>
				<th><a href="richieste.jsp?cat=<%=cat %>&esito=<%=esito%>&orderby=sottocategoria">Sotto categoria</a></th>
				<th><a href="richieste.jsp?cat=<%=cat %>&esito=<%=esito%>&orderby=data">Data</a></th>
				<th><a href="">Esito</a></th>
			</tr>
			<%
			while( rs.next() ) {
				%>
				<tr>
					<td><%=rs.getString("personale") %></td>
					<td><%=rs.getString("st")%> - <%=rs.getString("nome") %></td>
					<td><%=rs.getString("data") %></td>
					<td><%=rs.getString("esito") %></td>
					<td><a href="gestionerichiesta.jsp?cat=<%=cat %>&codice=<%=rs.getString("codice")%>"><button>Visualizza</button></a></td>
				</tr>
				<%
			}
		%>
		</table>
		<%
	}
	%>
	<p><a href="gestionerichieste.jsp?cat=<%=cat %>"><button>Indietro</button></a></p>

</body>
</html>