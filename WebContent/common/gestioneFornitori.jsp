<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Fornitori</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
HttpSession sess;
Connection conn;

public ResultSet getResult( String orderby, String piva, String nome, String tip, String tel, String email, String ind ) 
throws Exception {
	//query
	String query = "SELECT * FROM fornitore WHERE 1=1 ";
	if ( piva != null && !piva.equals("") )
		query = query + " AND upper( partita_iva ) LIKE upper('%"+piva+"%') ";
	if ( nome != null && !nome.equals("") )
		query = query + " AND upper( nome_organizzazione ) LIKE upper('%"+nome+"%') ";
	if ( tip != null && !tip.equals("") )
		query = query + " AND upper( tipologia ) LIKE upper('%"+tip+"%') ";
	if ( tel != null && !tel.equals("") )
		query = query + " AND upper( telefono ) LIKE upper('%"+tel+"%') ";
	if ( email != null && !email.equals("") )
		query = query + " AND upper( email ) LIKE upper('%"+email+"%') ";
	if ( ind != null && !ind.equals("") )
		query = query + " AND upper( indirizzo ) LIKE upper('%"+ind+"%') ";
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

}%>
	
<% 

if( sess == null ) {
	response.sendRedirect("Login");
	return;
}
%>

<font size="4">Inserisci un Fornitore        </font><a href="inserisciFornitore.jsp"><button>Inserisci</button></a><br>
<br>
		<form action="../Login" onclick="return true"><%
			if( request.getParameter("view") == null || request.getParameter("view").equals("tutti") ) {%>
				<input type="radio" name="esito" value="tutti" checked onclick="self.document.location.href='gestioneFornitori.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" onclick="self.document.location.href='gestioneFornitori.jsp?view=ricerca';">Ricerca<br><br><%
			}
			else {%>
				<input type="radio" name="esito" value="tutti" onclick="self.document.location.href='gestioneFornitori.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" checked onclick="self.document.location.href='gestioneFornitori.jsp?view=ricerca';">Ricerca<br><br><%
			}%>
		</form><%
	
	if( request.getParameter("view") != null && request.getParameter("view").equals("ricerca") ){%>
		<form action="gestioneFornitori.jsp">
			<table><tr><th>Criteri di ricerca</th></tr>
				<tr><td>Partita IVA</td>
				<td><input type="text" name="piva" ></input></td></tr>
				<tr><td>Nome</td>
				<td><input type="text" name="nome" ></input></td></tr>
				<tr><td>Tipologia</td>
				<td><input type="text" name="tipologia" ></input></td></tr>
				<tr><td>Telefono</td>
				<td><input type="text" name="telefono" ></input></td></tr>
				<tr><td>Email</td>
				<td><input type="text" name="email" ></input></td></tr>
				<tr><td>Indirizzo</td>
				<td><input type="text" name="indirizzo" ></input></td>
				<td><input type="hidden" name="view" value="ricerca"></input></td>
				<td><input type="submit" value="Cerca"></td></tr>
			</table>
		</form>
		<br>
		<%
	}%>
<font size="4">Elenco Fornitori</font><br>
<br>
<%	
	conn=ConnectionManager.getConnection();
	ResultSet rs = getResult( request.getParameter("orderby"),
			request.getParameter("piva"),
			request.getParameter("nome"),
			request.getParameter("tipologia"),
			request.getParameter("telefono"),
			request.getParameter("email"),
			request.getParameter("indirizzo"));
	
	if(!rs.isBeforeFirst() ){%>
		<font size="3"> Non ci sono fornitori</font><br></br>
	<%}
	else{%>
		<table border="1" cellpadding="3" cellspacing="0">
		<tr><th><b><a href="gestioneFornitori.jsp?orderby=partita_iva">P.IVA</a></b></th>
		<th><b><a href="gestioneFornitori.jsp?orderby=nome_organizzazione">Nome</a></b></th>
		<th><b><a href="gestioneFornitori.jsp?orderby=tipologia">Tipologia</a></b></th>
		<th><b><a href="gestioneFornitori.jsp?orderby=telefono">Telefono</a></b></th>
		<th><b><a href="gestioneFornitori.jsp?orderby=email">eMail</a></b></th>
		<th><b><a href="gestioneFornitori.jsp?orderby=indirizzo">Indirizzo</a></b></th></tr>
		<%while(rs.next()){%>
			<tr><td><%=rs.getString("partita_iva")%></td><td><%=rs.getString("nome_organizzazione") %></td>
			<td><%=rs.getString("tipologia") %></td><td><%=rs.getString("telefono") %></td>
			<td><%=rs.getString("email") %></td><td><%=rs.getString("indirizzo") %></td><td><a href="gestioneFornitore.jsp?partita_iva=<%=rs.getString("partita_iva") %>"><button>Edit</button></a></td></tr>
		<%}%>
		</table>
	<%} %>
</body>
<br>
<a href="gestioneBeniCatForn.jsp"><button>Indietro</button></a><br><br>
</html>