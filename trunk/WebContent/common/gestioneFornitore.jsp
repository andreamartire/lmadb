<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<%! String nome, tipologia, telefono, email, indirizzo; %>
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
	
	<p><i><font size="4">Gestione Fornitore</font></i></p>

<%
	String partita_iva = request.getParameter("partita_iva");
	String done = request.getParameter("done");

	if( done != null ) {
		if( done.equals("true") ) {
		%><p><i><font size="2" color="BLUE">Modifica andata a buon fine</font></i></p><%
		} else {
		%><p><i><font size="2" color="RED">Modifica fallita</font></i></p><%
		}
	}

	PreparedStatement st = conn.prepareStatement("SELECT * FROM Fornitore WHERE partita_iva = ?");
	st.setString( 1, partita_iva);
	ResultSet rs = st.executeQuery();
	
	if( rs.next() ) {
		partita_iva = rs.getString("partita_iva");
		nome = rs.getString("nome_organizzazione");
		tipologia = rs.getString("tipologia");
		telefono = rs.getString("telefono");
		email = rs.getString("email");
		indirizzo = rs.getString("indirizzo");
	} else {
		System.out.println("Errore: nessuna tupla presente");
	}
	%>
	
	<p><font size="3">Informazione Fornitore:</font></p>
	<form action="../ModificaFornitore" method="get">
		<table>
			<tr>
				<td align="right"><i>P.IVA:</i></td>
				<td><input type="text" name="partita_iva" readonly="readonly" value="<%=partita_iva %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Organizzazione:</i></td>
				<td><input type="text" name="nome" value="<%=nome %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Tipologia:</i></td>
				<td><input type="text" name="tipologia" value="<%=tipologia %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Telefono:</i></td>
				<td><input type="text" name="telefono" value="<%=telefono %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Email:</i></td>
				<td><input type="text" name="email" value="<%=email %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Indirizzo:</i></td>
				<td><input type="text" name="indirizzo" value="<%=indirizzo %>"></td>
			</tr>
			<tr>
				<td><center><input type=submit value="Salva"></center></td>
				<td><center><a href=../EliminaFornitore?partita_iva=<%=partita_iva %>><button>Elimina Fornitore</button></a></center></td>
			</tr>
		</table>
	</form>
	
	<p>
		<a href="gestioneFornitori.jsp"><button>Indietro</button></a>
	</p>
</body>
</html>