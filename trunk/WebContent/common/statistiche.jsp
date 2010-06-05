<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="util.ConnectionManager"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Types"%>
<%@page import="org.apache.catalina.Session"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Statistiche</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
public ResultSet getBandi() {
	try {
		Statement st = ConnectionManager.getConnection().createStatement();
		ResultSet rs = st.executeQuery("SELECT * FROM bando");
		return rs;
	} catch (Exception e) {
		return null;
	}
}

public ResultSet getCategorie() {
	try {
		Statement st = ConnectionManager.getConnection().createStatement();
		ResultSet rs = st.executeQuery("SELECT * FROM categoriabene");
		return rs;
	} catch (Exception e) {
		return null;
	}
}

public int getImporto( String bando ) {
	String sql = "{? = call statistica1( ? )}";
	try {
		CallableStatement cst = ConnectionManager.getConnection().prepareCall(sql);
		cst.registerOutParameter( 1, Types.INTEGER );
		cst.setString( 2, bando );
		cst.execute();
		return cst.getInt(1);
	} catch (Exception e) {
		e.printStackTrace();
		return 0;
	}
}

public String fornitoreMaxNumBeni( String sottocat ) {
	String sql = "{? = call statistica2( ? )}";
	try {
		CallableStatement cst = ConnectionManager.getConnection().prepareCall(sql);
		cst.registerOutParameter( 1, Types.VARCHAR );
		cst.setString( 2, sottocat );
		cst.execute();
		return cst.getString(1);
	} catch (Exception e) {
		e.printStackTrace();
		return null;
	}
}

public String fornitoreImporto( String sottocat, String dtin, String dtfin, String importo ) {
	String sql;
	if( importo.equals("maggiore") ) {
		sql = "{? = call statistica31( ?, ?, ? )}";
	} else {
		sql = "{? = call statistica32( ?, ?, ? )}";
	}
	try {
		CallableStatement cst = ConnectionManager.getConnection().prepareCall(sql);
		cst.registerOutParameter( 1, Types.VARCHAR );
		cst.setString( 2, sottocat );
		SimpleDateFormat f = new SimpleDateFormat("dd-MM-yyyy");
		cst.setDate( 3, new Date( f.parse(dtin).getTime() ) );
		cst.setDate( 4, new Date( f.parse(dtfin).getTime() ) );
		cst.execute();
		return cst.getString(1);
	} catch (Exception e) {
		e.printStackTrace();
		return null;
	}
}

public String getPercentuale( String cat, String dtin, String dtfin ) {
	if( dtin == null ) 
		dtin = "01-01-2010";
	if( dtfin == null ) 
		dtfin = "31-12-2010";
	
	String sql = "{? = call statistica4( ?, ?, ? )}";
	try {
		CallableStatement cst = ConnectionManager.getConnection().prepareCall(sql);
		cst.registerOutParameter( 1, Types.VARCHAR );
		cst.setString( 2, cat );
		SimpleDateFormat f = new SimpleDateFormat("dd-MM-yyyy");
		cst.setDate( 3, new Date( f.parse(dtin).getTime() ) );
		cst.setDate( 4, new Date( f.parse(dtfin).getTime() ) );
		cst.execute();
		String percent = cst.getString(1);
		if( percent.length() > 3 )
			percent = percent.substring(0,4) + "%";
		return percent;
	} catch (Exception e) {
		e.printStackTrace();
		return null;
	}
}
%>
</head>
<body>

	<%
	HttpSession sess = request.getSession(false);
	if( sess == null ) {
		response.sendRedirect(request.getHeader("referer"));
		return;
	}
	String user = (String) sess.getAttribute("type");
	if( user == null ) {
		response.sendRedirect(request.getHeader("referer"));
		return;
	}
	%>

	<center><font size=5>Statistiche</font></center><hr/>
	<%
	String stat = request.getParameter("stat");
	if( stat == null ) {
		%>
		<ul>
			<li><a href="statistiche.jsp?stat=1">Statistica 1</a></li>
			<li><a href="statistiche.jsp?stat=2">Statistica 2</a></li>
			<li><a href="statistiche.jsp?stat=3">Statistica 3</a></li>
			<li><a href="statistiche.jsp?stat=4">Statistica 4</a></li>
		</ul>
		
		<%if( user.equals("amministratore") ) {
			%><a href="../amministratore/adminhome.jsp"><button>Indietro</button></a><% 
		} else if( user.equals("addetto amministrativo") ) {
			%><a href="../addetto/addettohome.jsp"><button>Indietro</button></a><% 
		} else {
			%><a href="../dipendente/diphome.jsp"><button>Indietro</button></a><% 
		}
	} else {
		int s = Integer.parseInt(stat);
		switch(s) {
		case 1: 
			%><p><font size=3><i>Visualizzare l’elenco dei bandi di finanziamento e per ognuno di essi visualizzare la somma degli importi dei beni acquistati dall’azienda.</i></font></p>
			<%
			ResultSet rs = getBandi();
			if( !rs.isBeforeFirst() ) {
				%>
				<font size=2>Nessun bando</font>
				<%
			} else {
				%>
				<p><font size=3>Elenco Bandi</font></p>
				<table border=1>
					<tr>
						<th>Codice</th>
						<th>Legge</th>
						<th>Denominazione</th>
						<th>Data</th>
						<th>Percentuale</th>
						<th>Importo totale</th>
					</tr>
				<%
				while( rs.next() ) {
					%>
					<tr>
						<td><%=rs.getString("codice")%></td>
						<td><%=rs.getString("legge")%></td>
						<td><%=rs.getString("denominazione")%></td>
						<td><%=rs.getString("data_bando")%></td>
						<td><%=rs.getString("percentuale_finanziamento")%></td>
						<td><%=getImporto(rs.getString("codice")) %></td>
					</tr>
					<%
				}
				%>
				</table>
				
				<%
			}
			break;
		case 2:
			%>
			<p><font size=3><i>Visualizzare il fornitore che, per una data sottocategoria di bene, ha fornito il maggior numero di beni.</i></font></p>
			
			<%String sottocat = request.getParameter("sottocat");
			if( sottocat != null ) {
				String forn = fornitoreMaxNumBeni(sottocat);
				Statement st = ConnectionManager.getConnection().createStatement();
				ResultSet rs1 = st.executeQuery("SELECT * FROM fornitore WHERE partita_iva = '" + forn + "'" );
				if( rs1.next() ) {
					%><p><font size=3><i>Fornitore: <%=rs1.getString("nome_organizzazione")%> PI: <%=rs1.getString("partita_iva") %></i></font></p><%
				} else {
					%><p><font size=3>Nessun fornitore per questa sotto categoria</font></p><%
				}
			} else { %>
				<p><font size=2>Immetti il codice della sottocategoria</font></p>
			<%} %>
			<form action="statistiche.jsp">
				<input type="hidden" name="stat" value="2" />
				Codice sottocategoria: <input type="text" name="sottocat" />
				<input type="submit" value="Invio">
			</form>
			<%
			break;
		case 3:
			%>
			<p><font size=3><i>Visualizzare il fornitore che, per una data sottocategoria di bene, in un dato periodo, ha fornito all’azienda un bene con l’importo più basso o quello con l’importo più alto.</i></font></p>
			<%
			sottocat = request.getParameter("sottocat");
			String dtin = request.getParameter("datainizio");
			String dtfin = request.getParameter("datafine");
			String importo = request.getParameter("importo");
			if( sottocat != null && dtin != null && dtfin != null && importo != null ) {
				String forn = fornitoreImporto(sottocat, dtin, dtfin, importo);
				Statement st = ConnectionManager.getConnection().createStatement();
				ResultSet rs1 = st.executeQuery("SELECT * FROM fornitore WHERE partita_iva = '" + forn + "'" );
				if( rs1.next() ) {
					%><p><font size=3><i>Fornitore: <%=rs1.getString("nome_organizzazione")%> PI: <%=rs1.getString("partita_iva") %></i></font></p><%
				} else {
					%><p><font size=3>Nessun fornitore per questa sotto categoria</font></p><%
				}
			} %>
			
			<form action="statistiche.jsp">
				<table>
					<tr><td><input type="hidden" name="stat" value="3" /></td></tr>
					<tr><td>Sottocategoria:</td> <td><input type="text" name="sottocat" /></td></tr>
					<tr><td>Data inizio:</td> <td><input type="text" name="datainizio" /></td></tr>
					<tr><td>Data fine:</td> <td><input type="text" name="datafine" /></td></tr>
					<tr><td>Importo: </td><td><select name=importo><option value="maggiore">maggiore</option><option value="minore">minore</option></select></td></tr>
					<tr><td><input type="submit" value="Invio"></td></tr>
				</table>
			</form>
			<%
			break;
		case 4:
			%>
			<p><font size=3><i>Visualizzare, in un dato periodo di tempo, per ogni categoria di bene, la percentuale dei beni acquistati dall’azienda coperti da qualche bando di finanziamento</i></font></p>
			<p><font size=2>Immetti i dati</font></p>
			
			<form action="statistiche.jsp">
				<input type="hidden" name="stat" value="<%=stat %>" />
				Data inizio: <input type="text" name="datainizio" />
				Data fine: <input type="text" name="datafine" />
				<input type="submit" value="Invio">
			</form>
			<%
			rs = getCategorie();
			if( !rs.isBeforeFirst() ) {
				%>
				<font size=2>Nessuna categoria disponibile</font>
				<%
			} else {
				%>
				<p><font size=3>Elenco Categorie di beni</font></p>
				<table border=1>
					<tr>
						<th>Sigla</th>
						<th>Nome</th>
						<th>Percentuale</th>
					</tr>
				<%
				while( rs.next() ) {
					%>
					<tr>
						<td><%=rs.getString("sigla")%></td>
						<td><%=rs.getString("nome")%></td>
						<td><%=getPercentuale( rs.getString("sigla"), request.getParameter("datainizio"), request.getParameter("datafine") ) %></td>
					</tr>
					<%
				}
				%>
				</table>
				
				<%
			}
			break;
		}
		%>
		<p><a href="statistiche.jsp"><button>Indietro</button></a></p>
		<%
	}%>
</body>
</html>