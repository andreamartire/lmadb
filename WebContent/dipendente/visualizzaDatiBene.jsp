<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<%! String bene; %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Visualizza Dati Bene</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
Connection conn;
HttpSession sess; 

public ResultSet getDatiBene( int cod ) throws Exception{
	conn=ConnectionManager.getConnection();
	
	PreparedStatement st=conn.prepareStatement(
			"SELECT B.numero_inventario_generico, B.numero_inventario_seriale, " +
			"B.targhetta, B.descrizione, B.conforme, B.obsoleto, S.nome, F.nome_organizzazione " +
			"FROM Bene B, Sottocategoriabene S, Fornitore F "+
			"WHERE B.numero_inventario_generico = ? AND S.codice = B.sotto_categoria_bene " +
		        "AND F.partita_iva = B.fornitore");
	st.setInt(1, cod );
	return st.executeQuery();
}


%>
</head>


<body>

<%
sess=request.getSession(false);
bene=request.getParameter("name");
if( sess == null || !sess.getAttribute("type").equals("dipendente") ) {
	%><p><i><font size="4">Autenticazione fallita</font></i></p>
	<p>
	<a href="../login.html"><button>Indietro</button></a>
	</p><%
	return;
}
%>

<center><i><font size="5">Profilo Dipendente</font></i></center><hr>

<p><font size=4>Visualizzazione dati bene</font></p>
<% 
int cod = Integer.parseInt( request.getParameter("Codbene") );
ResultSet rs=getDatiBene( cod );
%>

<table border="1" cellpadding="3" cellspacing="0">
	<%if(rs.next()) {%>
	<tr><th>Numero Inventario Generico</th><td><%=rs.getInt("numero_inventario_generico") %></td></tr>
	<tr><th>Numero Inventario Seriale</th><td><%=rs.getString("numero_inventario_seriale") %></td></tr>
	<tr><th>Targhetta</th><td><%=rs.getString("targhetta") %></td></tr>
	<tr><th>Descrizione</th><td><%=rs.getString("descrizione") %></td></tr>
	<tr><th>Conforme</th><td><%=rs.getString("conforme") %></td></tr>
	<tr><th>Obsoleto</th><td><%=rs.getString("obsoleto") %></td></tr>
	<tr><th>Nome Sotto Categoria Bene</th><td><%=rs.getString("nome") %></td></tr>
	<tr><th>Nome Fornitore</th><td><%=rs.getString("nome_organizzazione") %></td></tr>
	<%}%>
</table>

<p>
<%String referer = request.getHeader("referer"); %>
<a href=<%=referer %>><button>Indietro</button></a>
</p>
</body>
</html>