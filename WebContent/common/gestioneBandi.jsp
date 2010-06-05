<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Bandi</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
HttpSession sess;
Connection conn;

public ResultSet getResult( String orderby, String cod, String legge, String den, String data, String perc ) 
throws Exception {
	//query
	String query = "SELECT * FROM bando WHERE 1=1 ";
	if ( cod != null && !cod.equals("") )
		query = query + " AND upper( codice ) LIKE upper('%"+cod+"%') ";
	if ( legge != null && !legge.equals("") )
		query = query + " AND upper( legge ) LIKE upper('%"+legge+"%') ";
	if ( den != null && !den.equals("") )
		query = query + " AND upper( denominazione ) LIKE upper('%"+den+"%') ";
	if ( perc != null && !perc.equals("") )
		query = query + " AND upper( percentuale_finanziamento ) LIKE upper('%"+perc+"%') ";
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

<font size="4">Inserisci un Bando</font><a href="inserisciBando.jsp"><button>Inserisci</button></a><br>
<br>
		<form action="../Login" onclick="return true"><%
			if( request.getParameter("view") == null || request.getParameter("view").equals("tutti") ) {%>
				<input type="radio" name="esito" value="tutti" checked onclick="self.document.location.href='gestioneBandi.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" onclick="self.document.location.href='gestioneBandi.jsp?view=ricerca';">Ricerca<br><br><%
			}
			else {%>
				<input type="radio" name="esito" value="tutti" onclick="self.document.location.href='gestioneBandi.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" checked onclick="self.document.location.href='gestioneBandi.jsp?view=ricerca';">Ricerca<br><br><%
			}%>
		</form><%
	
	if( request.getParameter("view") != null && request.getParameter("view").equals("ricerca") ){%>
		<form action="gestioneBandi.jsp">
			<table><tr><th>Criteri di ricerca</th></tr>
				<tr><td>Codice</td>
				<td><input type="text" name="codice" ></input></td></tr>
				<tr><td>Legge</td>
				<td><input type="text" name="legge" ></input></td></tr>
				<tr><td>Denominazione</td>
				<td><input type="text" name="denominazione" ></input></td></tr>
				<tr><td>% Finanziamento</td>
				<td><input type="text" name="percentuale" ></input></td>
				<td><input type="hidden" name="view" value="ricerca"></input></td>
				<td><input type="submit" value="Cerca"></td></tr>
			</table>
		</form>
		<br>
		<%
	}%>
<font size="4">Elenco Bandi </font><br>
<br>
<%
	conn=ConnectionManager.getConnection();
	
	ResultSet rs = getResult(request.getParameter("orderby"),
			request.getParameter("codice"),
			request.getParameter("legge"),
			request.getParameter("denominazione"),
			request.getParameter("data"),
			request.getParameter("percentuale"));
	
	if(!rs.isBeforeFirst()){%>
		<font size="3"> Non ci sono bandi</font><br></br>
	<%}
	else{%>
		<table border="1" cellpadding="3" cellspacing="0">
		<tr><th><b><a href="gestioneBandi.jsp?orderby=codice">Codice</a></b></th>
		<th><b><a href="gestioneBandi.jsp?orderby=legge">Legge</a></b></th>
		<th><b><a href="gestioneBandi.jsp?orderby=denominazione">Denominazione</a></b></th>
		<th><b><a href="gestioneBandi.jsp?orderby=data_bando">Data</a></b></th>
		<th><b><a href="gestioneBandi.jsp?orderby=percentuale_finanziamento">% Finanziamento</a></b></th></tr>
		<%while(rs.next()){%>
			<tr><td><%=rs.getString("codice")%></td><td><%=rs.getString("legge") %></td>
			<td><%=rs.getString("denominazione")%></td><td><%=rs.getString("data_bando").split(" ")[0] %></td>
			<td><%=rs.getString("percentuale_finanziamento") %></td>
			<td><a href="gestioneBando.jsp?codice=<%=rs.getString("codice") %>"><button>Edit</button></a></td></tr>
		<%}%>
		</table>
	<%} %>
</body>
<br>
<a href="gestioneBeniCatForn.jsp"><button>Indietro</button></a><br><br>
</html>