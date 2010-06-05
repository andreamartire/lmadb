<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.ConnectionManager"%>
<%! String garanzia, sottocat; int nig, importo; Connection connection; %>
<%!
public ResultSet getResult( String orderby, String nig, String imp, String gar, String sot ) 
throws Exception {
	//query
	String query = "SELECT * FROM bene " +
				"WHERE numero_inventario_generico NOT IN ( " +
				"SELECT bene FROM assegnazione) " +
				"AND numero_inventario_generico NOT IN ( " +
				"SELECT bene FROM dotazione)";
	if ( nig != null && !nig.equals("") )
		query = query + " AND numero_inventario_generico = "+nig;
	if ( imp != null && !imp.equals("") )
		query = query + " AND importo = "+imp;
	if ( gar != null && !gar.equals("") )
		query = query + " AND garanzia LIKE '%"+gar+"%'";
	if ( sot != null && !sot.equals("") )
		query = query + " AND sotto_categoria_bene LIKE '%"+sot+"%'";
	
	// applico ordinamenti
	if ( orderby != null )
		query = query + " ORDER BY " + orderby;
	//System.out.println(query);
	PreparedStatement st = connection.prepareStatement(query);
	
	return st.executeQuery();
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Visualizza Beni</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
<%

	HttpSession sess = request.getSession(false);
	
	if( sess.getAttribute("type").equals("addetto amministrativo") ){%>
		<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr> <% 
	}
	else if ( sess.getAttribute("type").equals("amministratore") ){%>
		<center><i><font size="5">Profilo Amministratore</font></i></center><hr> <% 
	}%>
	<a href="gestioneBeniCatForn.jsp"><button>Indietro</button></a><br><br>
	<% 

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
	
	connection = ConnectionManager.getConnection();
	
	%>
	
	<a href="InserisciBene.jsp"><button>Inserisci</button></a><br><br>
	
		<form action="../Login" onclick="return true"><%
			if( request.getParameter("view") == null || request.getParameter("view").equals("tutti") ) {%>
				<input type="radio" name="esito" value="tutti" checked onclick="self.document.location.href='visualizzaBeniDisponibili.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" onclick="self.document.location.href='visualizzaBeniDisponibili.jsp?view=ricerca';">Ricerca<br><br><%
			}
			else {%>
				<input type="radio" name="esito" value="tutti" onclick="self.document.location.href='visualizzaBeniDisponibili.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" checked onclick="self.document.location.href='visualizzaBeniDisponibili.jsp?view=ricerca';">Ricerca<br><br><%
			}%>
		</form><%
	
	if( request.getParameter("view") != null && request.getParameter("view").equals("ricerca") ){%>
		<form action="visualizzaBeniDisponibili.jsp">
			<table><tr><th>Criteri di ricerca</th></tr>
				<tr><td>Codice</td>
				<td><input type="text" name="numero_inventario_generico" ></input></td></tr>
				<tr><td>Importo</td>
				<td><input type="text" name="importo" ></input></td></tr>
				<tr><td>Garanzia</td>
				<td><input type="text" name="garanzia" ></input></td></tr>
				<tr><td>Sotto Categoria</td>
				<td><input type="text" name="sottocategoria"></input></td>
				<td><input type="hidden" name="view" value="ricerca"></input></td>
				<td><input type="submit" value="Cerca"></td></tr>
			</table>
		</form>
		<br>
		<%
	}
		
	ResultSet res = getResult(request.getParameter("orderby"),
			request.getParameter("numero_inventario_generico"),
			request.getParameter("importo"),
			request.getParameter("garanzia"),
			request.getParameter("sottocategoria"));

		
	if(!res.isBeforeFirst()){%>
		<font size="3">Non ci sono beni</font><br><br><%
	}
	else {%>
		<table border="1" cellpadding="3" cellspacing="0" bgcolor="#D0F5A9">
		<tr><th><b><a href="visualizzaBeniDisponibili.jsp?orderby=numero_inventario_generico">Codice</a></b></th>
		<th><b><a href="visualizzaBeniDisponibili.jsp?orderby=importo">Importo</a></b></th>
		<th><b><a href="visualizzaBeniDisponibili.jsp?orderby=garanzia">Garanzia</a></b></th>
		<th><b><a href="visualizzaBeniDisponibili.jsp?orderby=sotto_categoria_bene">SottoCategoria</a></b></th><th></th><th></th><th></th></tr>
	<%
		while ( res.next() ) {
			nig = res.getInt("numero_inventario_generico");
			importo  = res.getInt("importo");
			garanzia = res.getString("garanzia");
			sottocat = res.getString("sotto_categoria_bene");%>
			
			<tr><td><%=nig%></td><td><%=importo%></td>
			<td><%=garanzia%></td><td><%=sottocat%></td>
			<td><a href="gestioneBene.jsp?idBene=<%=nig%>"><button>Modifica</button></a></td>
			<td><a href="eliminaBene.jsp?idBene=<%=nig%>"><button>Elimina</button></a></td>
			<td><a href="visualizzaBene.jsp?idBene=<%=nig%>"><button>Dettagli</button></a></td>
			</tr><%
		}
	}%>
</table>
</body>
</html>