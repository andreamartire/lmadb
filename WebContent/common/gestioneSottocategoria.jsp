<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Sottocategoria</title>
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
	
	<p><i><font size="4">Gestione Sottocategoria</font></i></p>

	
<%!
	public ResultSet getCategorie() throws Exception{
		conn=ConnectionManager.getConnection();
		PreparedStatement st=conn.prepareStatement("SELECT * FROM categoriabene");
		return st.executeQuery();
	}
%>
<%
	String codiceSottoCategoria = request.getParameter("codiceSottoCategoria");
	String done = request.getParameter("done");

	if( done != null ) {
		if( done.equals("true") ) {
		%><p><i><font size="2" color="BLUE">Modifica andata a buon fine</font></i></p><%
		} else {
		%><p><i><font size="2" color="RED">Modifica fallita</font></i></p><%
		}
	}

	String codiceSot = "", nomeSott = "", CategoriaBene = "";
	PreparedStatement st = conn.prepareStatement("SELECT * FROM sottocategoriabene WHERE codice = ?");
	st.setString( 1, codiceSottoCategoria);
	ResultSet rs = st.executeQuery();
	
	if( rs.next() ) {
		codiceSot = rs.getString("codice");
		nomeSott = rs.getString("nome");
		CategoriaBene = rs.getString("categoria_bene");
	} else {
		System.out.println("Errore: nessuna tupla presente");
		return;
	}
	
	ResultSet res = getCategorie();
	%>
	
	<p><font size="3">Informazione SottoCategoria:</font></p>
	<form action="../ModificaSottocategoria" method="get">
		<table>
			<tr>
				<td align="right"><i>Codice Sottocategoria:</i></td>
				<td><input type="text" name="codice" readonly="readonly" value="<%=codiceSot %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Nome Sottocategoria:</i></td>
				<td><input type="text" name="nome" value="<%=nomeSott %>"></td>
			</tr>
			<tr>
				<td align="right"><i>Categoria Bene:</i></td>
				<td><select name='nomeCategoriaBene'><%
					while( res.next() ) {
						String nome = res.getString("nome");
						if( CategoriaBene == null )
							CategoriaBene = "null";
						if(!CategoriaBene.equals(nome)) {%>
						<option value="<%=nome%>"><%=nome%></option><%
						}
						else{%>
						<option value="<%=nome%>" selected="selected"><%=nome%></option><%
						}
					
					}%>
					</select>
				</td>
			</tr>
			<tr>
				<td><center><input type=submit value="Salva"></center></td>
				<td><center><a href=../EliminaSottoCategoria?codiceSottCat=<%=codiceSot %>><button>Elimina Sottocategoria</button></a></center></td>
			</tr>
		</table>
	</form>
	
	<p>
		<a href="gestioneSottoCategorie.jsp"><button>Indietro</button></a>
	</p>
</body>
</html>