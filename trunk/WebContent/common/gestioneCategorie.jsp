<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Categorie</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
HttpSession sess;
Connection conn;

public ResultSet getCategorie() throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st=conn.prepareStatement("SELECT * FROM CategoriaBene");
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

<font size="4">Inserisci una Categoria        </font><a href="inserisciCategoria.jsp"><button>Inserisci</button></a><br>

<br>
<font size="4">Elenco Categoria</font><br>
<br>
<%ResultSet rs=getCategorie(); 
	if(!rs.isBeforeFirst()){%>
		<font size="3"> Non ci sono categorie</font><br></br>
	<%}
	else{%>
		<table border="1" cellpadding="3" cellspacing="0">
		<tr><th>Sigla</th><th>Nome</th><th>Operazione</th></tr>
		<%while(rs.next()){%>
			<tr><td><%=rs.getString("sigla")%></td><td><%=rs.getString("nome") %></td><td><a href="gestioneCategoria.jsp?sigla=<%=rs.getString("sigla") %>"><button>Edit</button></a></td></tr>
		<%}%>
		</table>
	<%} %>
</body>
<br>
<a href="gestioneBeniCatForn.jsp"><button>Indietro</button></a><br><br>
</html>