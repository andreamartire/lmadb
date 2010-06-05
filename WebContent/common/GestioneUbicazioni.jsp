<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Ubicazioni</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
HttpSession sess;
Connection conn;

public ResultSet getResult( String orderby, String cod, String bene, String stanza ) 
throws Exception {
	//query
	String query = "SELECT * FROM ubicazione WHERE 1=1 ";
	if ( cod != null && !cod.equals("") )
		query = query + " AND upper( codice ) LIKE upper('%"+cod+"%') ";
	if ( bene != null && !bene.equals("") )
		query = query + " AND bene = "+bene;
	if ( stanza != null && !stanza.equals("") )
		query = query + " AND upper( stanza ) LIKE upper('%"+stanza+"%') ";
	// applico ordinamenti
	if ( orderby != null )
		query = query + " ORDER BY " + orderby;
	//System.out.println(query);
	PreparedStatement st = conn.prepareStatement(query);
	
	return st.executeQuery();
}
%>
</head>
<body>
<%

sess = request.getSession(false);

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

<font size="4">Definisci un'ubicazione        </font><a href="inserisciUbicazione.jsp"><button>Inserisci</button></a><br>
<br>
		<form action="../Login" onclick="return true"><%
			if( request.getParameter("view") == null || request.getParameter("view").equals("tutti") ) {%>
				<input type="radio" name="esito" value="tutti" checked onclick="self.document.location.href='GestioneUbicazioni.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" onclick="self.document.location.href='GestioneUbicazioni.jsp?view=ricerca';">Ricerca<br><br><%
			}
			else {%>
				<input type="radio" name="esito" value="tutti" onclick="self.document.location.href='GestioneUbicazioni.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" checked onclick="self.document.location.href='GestioneUbicazioni.jsp?view=ricerca';">Ricerca<br><br><%
			}%>
		</form><%
	
	if( request.getParameter("view") != null && request.getParameter("view").equals("ricerca") ){%>
		<form action="GestioneUbicazioni.jsp">
			<table><tr><th>Criteri di ricerca</th></tr>
				<tr><td>Codice</td>
				<td><input type="text" name="codice" ></input></td></tr>
				<tr><td>Bene</td>
				<td><input type="text" name="bene" ></input></td></tr>
				<tr><td>Stanza</td>
				<td><input type="text" name="stanza" ></input></td>
				<td><input type="hidden" name="view" value="ricerca"></input></td>
				<td><input type="submit" value="Cerca"></td></tr>
			</table>
		</form>
		<br>
		<%
	}%>
<font size="4">Elenco Ubicazioni</font><br>
<br>
<%
	conn=ConnectionManager.getConnection();

	ResultSet rs = getResult(request.getParameter("orderby"),
			request.getParameter("codice"),
			request.getParameter("bene"),
			request.getParameter("stanza"));
	if(!rs.isBeforeFirst()){%>
		<font size="3"> Non ci sono ubicazioni registrate</font><br></br>
	<%}
	else{%>
		<table border="1" cellpadding="3" cellspacing="0">
		<tr><th><b><a href="GestioneUbicazioni.jsp?orderby=codice">Codice</a></b></th>
		<th><b><a href="GestioneUbicazioni.jsp?orderby=bene">Bene</a></b></th>
		<th><b><a href="GestioneUbicazioni.jsp?orderby=stanza">Stanza</a></b></th>
		<th><b><a href="GestioneUbicazioni.jsp?orderby=data_inizio">Data Inizio</a></b></th>
		<th><b><a href="GestioneUbicazioni.jsp?orderby=data_fine">Data Fine</a></b></th></tr>
		<%while(rs.next()){
		%>
			<tr><td><%= rs.getString("Codice")%></td><td><%= rs.getString("bene")%></td><td><%= rs.getString("stanza")%></td><td><%= rs.getString("data_inizio")%></td><td><%= rs.getString("data_fine")%></td>
			<td><a href="gestioneUbicazione.jsp?codice=<%= rs.getString("Codice")%>"><button>Edit</button></a></td></tr>
		<%
		}%>
		</table>
	<%}%>
</body>
<br>
<a href="gestioneBeniCatForn.jsp"><button>Indietro</button></a><br><br>
</html>