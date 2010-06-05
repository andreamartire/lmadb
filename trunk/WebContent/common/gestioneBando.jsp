<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<%! String codice, legge, denominazione, data, percentuale; %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Bando</title>
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
	
	<p><i><font size="4">Gestione Bando</font></i></p>

<%
	String sigla = request.getParameter("codice");
	String done = request.getParameter("done");

	if( done != null ) {
		if( done.equals("true") ) {
		%><p><i><font size="2" color="BLUE">Modifica andata a buon fine</font></i></p><%
		} else {
		%><p><i><font size="2" color="RED">Modifica fallita</font></i></p><%
		}
	}

	PreparedStatement st = conn.prepareStatement("SELECT * FROM bando WHERE codice = ?");
	st.setString( 1, (String)request.getParameter("codice"));
	ResultSet rs = st.executeQuery();
	
	if( rs.next() ) {
		codice = rs.getString("codice");
		legge = rs.getString("legge");
		denominazione = rs.getString("denominazione");
		data = rs.getString("data_bando").split(" ")[0];
		percentuale = rs.getString("percentuale_finanziamento");
	} else {
		System.out.println("Errore: nessuna tupla presente");
	}
	%>
	
	<p><font size="3">Informazione Bando:</font></p>
	<form action="../ModificaBando" method="get">
		<table>
			<tr>
				<td align="right"><i>Codice:</i></td>
				<td><input type="text" name="codice" readonly="readonly" value="<%=codice %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Legge:</i></td>
				<td><input type="text" name="legge" value="<%=legge %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Denominazione:</i></td>
				<td><input type="text" name="denominazione" value="<%=denominazione %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Data:</i></td>
				<td><input type="text" name="data" value="<%=data %>"></td>
			</tr>
			<tr>
				<td align="right"><i>% Finanziamento:</i></td>
				<td><input type="text" name="percentuale" value="<%=percentuale %>"></td>
			</tr>
			<tr>
				<td><center><input type=submit value="Salva"></center></td>
				<td><center><a href=../EliminaBando?codice=<%=codice %>><button>Elimina Bando</button></a></center></td>
			</tr>
		</table>
	</form>
	
	<p>
		<a href="gestioneBandi.jsp"><button>Indietro</button></a>
	</p>
</body>
</html>