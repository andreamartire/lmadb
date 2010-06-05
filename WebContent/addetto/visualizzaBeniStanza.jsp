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
	<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
<%! Connection conn; String stanza; 

public ResultSet getResult( String orderby, String stnz, String nig, String nis, String imp, String gar, String conf, String obso, String sottocat ) 
throws Exception {
	//query
	String query = "SELECT B.* FROM Ubicazione U, Bene B WHERE U.stanza = ? AND U.bene = B.numero_inventario_generico ";
	if ( nig != null && !nig.equals("") )
		query = query + " AND numero_inventario_generico = "+nig;
	if ( nis != null && !nis.equals("") )
		query = query + " AND upper( numero_inventario_seriale ) LIKE upper('%"+nis+"%') ";
	if ( imp != null && !imp.equals("") )
		query = query + " AND importo = "+imp;
	if ( gar != null && !gar.equals("") )
		query = query + " AND upper( garanzia ) LIKE upper('%"+gar+"%') ";
	if ( conf != null && !conf.equals("") )
		query = query + " AND upper( conforme ) LIKE upper('%"+conf+"%') ";
	if ( obso != null && !obso.equals("") )
		query = query + " AND upper( obsoleto ) LIKE upper('%"+obso+"%') ";
	if ( sottocat != null && !sottocat.equals("") )
		query = query + " AND upper( sotto_categoria_bene ) LIKE upper('%"+sottocat+"%') ";
	// applico ordinamenti
	
	if ( orderby != null )
		query = query + " ORDER BY " + orderby;
	PreparedStatement st = conn.prepareStatement(query);
	System.out.println(query);
	st.setString(1,stnz);
	return st.executeQuery();
}

%>
<%
	HttpSession sess = request.getSession(false);
	if( sess == null || !sess.getAttribute("type").equals("addetto amministrativo") ) {
	%><p><i><font size="4" color="#FF8000">Autenticazione fallita</font></i></p>
	<p>
	<a href="login.html"><button>Indietro</button></a>
	</p><%
		return;
	}
	
	conn = ConnectionManager.getConnection();
	stanza = request.getParameter("idStanza");

%><br><font size="3">Visualizza</font><br>
		<form action="../Login" onclick="return true"><%
			if( request.getParameter("view") == null || request.getParameter("view").equals("tutti") ) {%>
				<input type="radio" name="esito" value="tutti" checked onclick="self.document.location.href='visualizzaBeniStanza.jsp?view=tutti&idStanza=<%=stanza %>';">Tutti
				<input type="radio" name="esito" value="ricerca" onclick="self.document.location.href='visualizzaBeniStanza.jsp?view=ricerca&idStanza=<%=stanza %>';">Ricerca<br><br><%
			}
			else {%>
				<input type="radio" name="esito" value="tutti" onclick="self.document.location.href='visualizzaBeniStanza.jsp?view=tutti&idStanza=<%=stanza %>';">Tutti
				<input type="radio" name="esito" value="ricerca" checked onclick="self.document.location.href='visualizzaBeniStanza.jsp?view=ricerca&idStanza=<%=stanza %>';">Ricerca<br><br><%
			}%>
		</form><%
	
	if( request.getParameter("view") != null && request.getParameter("view").equals("ricerca") ){%>
		<form action="visualizzaBeniStanza.jsp">
			<table><tr><th>Criteri di ricerca</th></tr>
				<tr><td>Num. Inv. Generico</td>
				<td><input type="text" name="nig" ></input></td></tr>
				<tr><td>Num. Inv. Seriale</td>
				<td><input type="text" name="nis" ></input></td></tr>
				<tr><td>Importo</td>
				<td><input type="text" name="imp" ></input></td></tr>
				<tr><td>Garanzia</td>
				<td><input type="text" name="gar" ></input></td></tr>
				<tr><td>Conforme</td>
				<td><input type="text" name="conf" ></input></td></tr>
				<tr><td>Obsoleto</td>
				<td><input type="text" name="obso" ></input></td></tr>
				<tr><td>Sotto Categoria</td>
				<td><input type="text" name="sottocat" ></input></td>
				<td><input type="hidden" name="view" value="ricerca"></input></td>
				<td><input type="hidden" name="idStanza" value="<%=stanza %>"></input></td>
				<td><input type="submit" value="Cerca"></td></tr>
			</table>
		</form>
		<%
	}%>

<p><i><font size="4" color="#FF8000">Beni associati alla stanza</font></i></p>

<form action="ModificaStanza" method="get">
	
<%
	ResultSet rs = getResult(request.getParameter("orderby"),
			request.getParameter("idStanza"),
			request.getParameter("nig"),
			request.getParameter("nis"),
			request.getParameter("imp"),
			request.getParameter("gar"),
			request.getParameter("conf"),
			request.getParameter("obso"),
			request.getParameter("sottocat"));
	
	if(!rs.isBeforeFirst()){%>
		<font size="3">Non ci sono beni associati alla stanza</font>
	<%}
	else {
		int nig, importo;
		String nis, data_acq, garanzia, data_att,
			data_scad, conforme, obsoleto, sotto_cat_bene, forn;%>
		<table border="1" cellpadding="3" cellspacing="0" bgcolor="#D0F5A9">
		<tr><th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=numero_inventario_generico">Num.Inv. Generico</a></b></th>
		<th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=numero_inventario_seriale">Num.Inv. Seriale</a></b></th>
		<th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=importo">Importo</a></b></th>
			<th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=data_acquisto">Data Acquisto</a></b></th>
			<th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=garanzia">Garanzia</a></b></th>
			<th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=data_attivazione">Data Attivazione</a></b></th>
			<th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=data_scadenza">Data Scadenza</a></b></th>
			<th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=conforme">Conforme</a></b></th>
			<th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=obsoleto">Obsoleto</a></b></th>
			<th><b><a href="visualizzaBeniStanza.jsp?idStanza=<%=stanza %>&orderby=sotto_categoria_bene">SottoCategoria</a></b></th></tr>
		<%
		while( rs.next() ) {
			nig = rs.getInt("numero_inventario_generico");
			nis = rs.getString("numero_inventario_seriale");
			importo = rs.getInt("importo");
			data_acq = rs.getString("data_acquisto");
			garanzia = rs.getString("garanzia");
			data_att = rs.getString("data_attivazione");
			data_scad = rs.getString("data_scadenza");
			conforme = rs.getString("conforme");
			obsoleto = rs.getString("obsoleto");
			sotto_cat_bene = rs.getString("sotto_categoria_bene");
			forn = rs.getString("fornitore");%>
			<tr><td><%=nig%></td><td><%=nis%></td><td><%=importo%></td><td><%=data_acq%></td>
				<td><%=garanzia%></td><td><%=data_att%></td><td><%=data_scad%></td><td><%=conforme%></td><td><%=obsoleto%></td>
				<td><%=sotto_cat_bene%></td></tr>
		<%}
		}%>
		</table>
	
</form>

<p>
<a href="gestioneStanze.jsp"><button>Indietro</button></a>
</p>
</body>
</html>