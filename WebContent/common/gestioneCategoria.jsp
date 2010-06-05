<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Categoria</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
	<%! Connection conn; %>
	<%
	HttpSession sess = request.getSession(false);
	
	if( sess == null ) {
		response.sendRedirect("Login");
		return;
	}
	
	try {
		if( sess.getAttribute("type").equals("addetto amministrativo") ||
				sess.getAttribute("type").equals("amministratore") ) {
		} else {
			%> <h2>Sei un impostore</h2><br>
			<a href="Logout"><button>Logout</button></a>
			<%
		}
	} catch ( Exception e ) {
		response.sendRedirect("Login");
	}
	
	conn = ConnectionManager.getConnection();
	%>
	<%if(sess.getAttribute("type").equals("amministratore")){ 
	%> <center><i><font size="5">Profilo Amministratore</font></i></center><hr><%} 
	else { 
	%> <center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr><%} %>
	
	<p><i><font size="4">Gestione Categoria</font></i></p>

<%
	String sigla = request.getParameter("sigla");
	String done = request.getParameter("done");

	if( done != null ) {
		if( done.equals("true") ) {
		%><p><i><font size="2" color="BLUE">Modifica andata a buon fine</font></i></p><%
		} else {
		%><p><i><font size="2" color="RED">Modifica fallita</font></i></p><%
		}
	}

	String nome = "";
	PreparedStatement st = conn.prepareStatement("SELECT * FROM CategoriaBene WHERE sigla = ?");
	st.setString( 1, (String)request.getParameter("sigla"));
	ResultSet rs = st.executeQuery();
	
	if( rs.next() ) {
		sigla = rs.getString("sigla");
		nome = rs.getString("nome");
	} else {
		System.out.println("Errore: nessuna tupla presente");
	}
	%>
	
	<p><font size="3">Informazione Categoria:</font></p>
	<form action="../ModificaCategoria" method="get">
		<table>
			<tr>
				<td align="right"><i>Sigla Categoria:</i></td>
				<td><input type="text" name="sigla" readonly="readonly" value="<%=sigla %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Nome Categoria:</i></td>
				<td><input type="text" name="nome" value="<%=nome %>"></td>
			</tr>
			<tr>
				<td><center><input type=submit value="Salva"></center></td>
				<td><center><a href=../EliminaCategoria?sigla=<%=sigla %>><button>Elimina Categoria</button></a></center></td>
			</tr>
		</table>
	</form>
	
	<p>
		<a href="gestioneCategorie.jsp"><button>Indietro</button></a>
	</p>
</body>
</html>