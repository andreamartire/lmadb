<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Ubicazione</title>
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
	
	<p><i><font size="4">Gestione Ubicazione</font></i></p>

	
<%!
	public ResultSet getStanze() throws Exception{
		conn=ConnectionManager.getConnection();
		PreparedStatement st=conn.prepareStatement("SELECT * FROM stanza");
		return st.executeQuery();
	}

	public ResultSet getBeniNonUbicati() throws Exception{
		Connection conn=ConnectionManager.getConnection();
		Statement st1=conn.createStatement();
		return st1.executeQuery(
				"SELECT numero_inventario_generico FROM bene "+
				"WHERE numero_inventario_generico NOT IN (SELECT bene FROM ubicazione)");
	}
%>
<%
	String codice = request.getParameter("codice");
	String done = request.getParameter("done");

	if( done != null ) {
		if( done.equals("true") ) {
		%><p><i><font size="2" color="BLUE">Modifica andata a buon fine</font></i></p><%
		} else {
		%><p><i><font size="2" color="RED">Modifica fallita</font></i></p><%
		}
	}

	String bene="", stanza="", dt_in="", dt_fn="";
	PreparedStatement st = conn.prepareStatement("SELECT * FROM ubicazione WHERE codice = ?");
	System.out.println("Codice "+(String)request.getParameter("codice"));
	st.setString( 1, (String)request.getParameter("codice"));
	ResultSet rs = st.executeQuery();
	
	if( rs.next() ) {
		codice = rs.getString("codice");
		bene = rs.getString("bene");
		stanza = rs.getString("stanza");
		dt_in = rs.getString("data_inizio");
		dt_fn = rs.getString("data_fine");
	} else {
		System.out.println("Errore: nessuna tupla presente");
	}
	
	ResultSet res = getStanze();
	ResultSet res2 = getBeniNonUbicati();
	%>
	
	<p><font size="3">Informazione SottoCategoria:</font></p>
	<form action="../ModificaUbicazione" method="get">
		<table>
			<tr>
				<td align="right"><i>Codice:</i></td>
				<td><input type="text" name="codice" readonly="readonly" value="<%=codice %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Bene:</i></td>
				<td><select name='bene'>
						<option value="<%=bene%>" selected><%=bene%></option><%
						while( res2.next() ) {%>
							<option value="<%=res2.getString("numero_inventario_generico")%>"><%=res2.getString("numero_inventario_generico")%></option><%
						}%>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right"><i>Stanza:</i></td>
				<td><select name='stanza'><%
					while( res.next() ) {
					
						if(!stanza.equals(res.getString("codice"))) {%>
						<option value="<%=res.getString("codice")%>"><%=res.getString("codice")%></option><%
						}
						else{%>
						<option value="<%=res.getString("codice")%>" selected><%=res.getString("codice")%></option><%
						}
					}%>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right"><i>Data Inizio:</i></td>
				<td><input type="text" name="dt_in" value="<%=dt_in %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Data Fine:</i></td>
				<td><input type="text" name="dt_fn" value="<%=dt_fn %>"></td>
			</tr>
			<tr>
				<td><center><input type=submit value="Salva"></center></td>
				<td><center><a href=../EliminaUbicazione?codice=<%=codice %>><button>Elimina Ubicazione</button></a></center></td>
			</tr>
		</table>
	</form>
	
	<p>
		<a href="GestioneUbicazioni.jsp"><button>Indietro</button></a>
	</p>
</body>
</html>