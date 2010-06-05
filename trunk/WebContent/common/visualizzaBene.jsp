<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="util.ConnectionManager"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Visualizza Beni</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body bgcolor="#F5F6CE">
<%! Connection conn; %>
<%

	HttpSession sess = request.getSession(false);
	
	if( sess.getAttribute("type").equals("addetto amministrativo") ) {
		%><center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr><%
	}
	else if ( sess.getAttribute("type").equals("amministratore") ){
		%><center><i><font size="5">Profilo Amministratore</font></i></center><hr><%
	}
	
	if( sess == null ) {
		response.sendRedirect("Login");
		return;
	}
	
	conn = ConnectionManager.getConnection();

%><p><i><font size="4" color="#FF8000">Dettagli Bene</font></i></p>

<p><font size="4">Informazioni Bene:</font></p>
<form action="ModificaStanza" method="get">
	<table border="1" cellpadding="3" cellspacing="0">

<%
	
	int bene = Integer.valueOf( request.getParameter("idBene") );
	
	PreparedStatement st = conn.prepareStatement("SELECT * FROM Bene B WHERE numero_inventario_generico=? ");
	st.setInt( 1, bene );
	ResultSet rs = st.executeQuery();
	int nig, importo;
	String nis, data_acq, garanzia, data_att, targhetta, descrizione, 
		data_scad, conforme, obsoleto, sotto_cat_bene, forn;%>
	
	<%
	if( rs.next() ) {
		nig = rs.getInt("numero_inventario_generico");
		nis = rs.getString("numero_inventario_seriale");
		importo = rs.getInt("importo");
		targhetta = rs.getString("targhetta");
		descrizione = rs.getString("descrizione");
		data_acq = rs.getString("data_acquisto");
		garanzia = rs.getString("garanzia");
		data_att = rs.getString("data_attivazione");
		data_scad = rs.getString("data_scadenza");
		conforme = rs.getString("conforme");
		obsoleto = rs.getString("obsoleto");
		sotto_cat_bene = rs.getString("sotto_categoria_bene");
		forn = rs.getString("fornitore");%>
		<tr><th>Num.Inv.Gen.</th><td><%=nig%></td></tr>
		<tr><th>Num.Inv.Ser.</th><td><%=nis%></td></tr>
		<tr><th>Importo</th><td><%=importo%></td></tr>
		<tr><th>Targhetta</th><td><%=targhetta %></td></tr>
		<tr><th>Descrizione</th><td><%=descrizione %></td></tr>
		<tr><th>Data Acquisto</th><td><%=data_acq%></td></tr>
		<tr><th>Garanzia</th><td><%=garanzia%></td></tr>
		<tr><th>Data Att.</th><td><%=data_att%></td></tr>
		<tr><th>Data Scad.</th><td><%=data_scad%></td></tr>
		<tr><th>Conforme</th><td><%=conforme%></td></tr>
		<tr><th>Obsoleto</th><td><%=obsoleto%></td></tr>
		<tr><th>SottoCat.Bene</th><td><%=sotto_cat_bene%></td></tr>
		<tr><th>Fornitore</th><td><%=forn%></td></tr>
		<%
	}
%>
	</table>
</form>

<p>
<a href="visualizzaBeni.jsp"><button>Indietro</button></a>
</p>
</body>
</html>