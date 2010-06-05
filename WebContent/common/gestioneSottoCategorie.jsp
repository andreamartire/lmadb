<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione SottoCategorie</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
HttpSession sess;
Connection conn;

public ResultSet getResult( String orderby, String cod, String nome, String cat ) 
throws Exception {
	//query
	String query = "SELECT * FROM sottoCategoriaBene WHERE 1=1 ";

	if ( cod != null && !cod.equals("") )
		query = query + " AND upper( codice ) LIKE upper('%"+cod+"%') ";
	if ( nome != null && !nome.equals("") )
		query = query + " AND upper( nome ) LIKE upper('%"+nome+"%') ";
	if ( cat != null && !cat.equals("") )
		query = query + " AND upper( categoria_bene ) LIKE upper('%"+cat+"%') ";
	
	// applico ordinamenti
	if ( orderby != null )
		query = query + " ORDER BY " + orderby;
	
	PreparedStatement st = conn.prepareStatement(query);
	//System.out.println(query);
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

<font size="4">Inserisci una Sottocategoria        </font><a href="inserisciSottoCategoria.jsp"><button>Inserisci</button></a><br>
		<br>
		<form action="../Login" onclick="return true"><%
			if( request.getParameter("view") == null || request.getParameter("view").equals("tutti") ) {%>
				<input type="radio" name="esito" value="tutti" checked onclick="self.document.location.href='gestioneSottoCategorie.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" onclick="self.document.location.href='gestioneSottoCategorie.jsp?view=ricerca';">Ricerca<br><br><%
			}
			else {%>
				<input type="radio" name="esito" value="tutti" onclick="self.document.location.href='gestioneSottoCategorie.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" checked onclick="self.document.location.href='gestioneSottoCategorie.jsp?view=ricerca';">Ricerca<br><br><%
			}%>
		</form><%
	
	if( request.getParameter("view") != null && request.getParameter("view").equals("ricerca") ){%>
		<form action="gestioneSottoCategorie.jsp">
			<table><tr><th>Criteri di ricerca</th></tr>
				<tr><td>Codice</td>
				<td><input type="text" name="codice" ></input></td></tr>
				<tr><td>Nome</td>
				<td><input type="text" name="nome" ></input></td></tr>
				<tr><td>Categoria</td>
				<td><input type="text" name="categoria" ></input></td>
				<td><input type="hidden" name="view" value="ricerca"></input></td>
				<td><input type="submit" value="Cerca"></td></tr>
			</table>
		</form>
		<br>
		<%
	}%>

<font size="4">Elenco Sottocategoria</font><br>
<br>
<%
	conn=ConnectionManager.getConnection();
	
	ResultSet rs = getResult( request.getParameter("orderby"),
			request.getParameter("codice"),
			request.getParameter("nome"),
			request.getParameter("categoria"));

	if(!rs.isBeforeFirst()){%>
		<font size="3"> Non ci sono sottocategorie</font><br></br>
	<%}
	else{%>
		<table border="1" cellpadding="3" cellspacing="0">
		<tr><th><b><a href="gestioneSottoCategorie.jsp?orderby=codice">Codice</a></b></th>
		<th><b><a href="gestioneSottoCategorie.jsp?orderby=nome">Nome</a></b></th>
		<th><b><a href="gestioneSottoCategorie.jsp?orderby=categoria_bene">Categoria Bene</a></b></th>
		<th></th></tr>
		<%while(rs.next()){%>
			<tr><td><%=rs.getString("codice")%></td><td><%=rs.getString("nome") %></td><td><%=rs.getString("categoria_bene") %></td><td><a href="gestioneSottocategoria.jsp?codiceSottoCategoria=<%=rs.getString("codice") %>"><button>Edit</button></a></td></tr>
		<%}%>
		</table>
	<%} %>
</body>
<br>
<a href="gestioneBeniCatForn.jsp"><button>Indietro</button></a><br><br>
</html>