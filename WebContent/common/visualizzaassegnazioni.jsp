<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.*"%>
<%@page import="util.ConnectionManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Visualizzazione Assegnazioni</title>

<link rel="stylesheet" type="text/css" href="../style.css" />

<%!
public ResultSet getAssegnazioni( String cat1, String assegnatari, String data ) {
	Connection conn = ConnectionManager.getConnection();
	String sql;
	String cat2;
	if( cat1.equals("MB/MA") ) {
		cat2 = cat1.substring(3);
		cat1 = cat1.substring(0,2);
	} else {
		cat2 = cat1;
	}
	if( assegnatari.equals("dipendenti") ) {
		sql = 	"SELECT D.codice AS cod, P.matricola, P.nome, P.cognome, D.data_inizio, D.data_fine, D.note, " +
					"D.bene, B.targhetta, S.categoria_bene " +
				"FROM personale P JOIN dotazione D ON D.personale = P.matricola " +
					"JOIN bene B ON B.numero_inventario_generico = D.bene " +
					"JOIN sottocategoriabene S ON S.codice = B.sotto_categoria_bene " +
				"WHERE (S.categoria_bene = ? OR S.categoria_bene = ?) ";
		
		if( data != null && !data.equals("") ) {
			sql = sql + "AND D.data_fine >= ? AND D.data_inizio <= ?";
		} else {
			sql = sql + "AND D.data_fine >= current_date AND D.data_inizio <= current_date";
		}
	} else {
		sql = 	"SELECT A.codice AS cod, G.codice, G.denominazione, A.data_inizio, A.data_fine, A.note, " +
					"A.bene, B.targhetta, S.categoria_bene " +
				"FROM gruppodilavoro G JOIN assegnazione A ON G.codice = A.gruppo_di_lavoro " +
					"JOIN bene B ON B.numero_inventario_generico = A.bene " +
					"JOIN sottocategoriabene S ON S.codice = B.sotto_categoria_bene " +
				"WHERE (S.categoria_bene = ? OR S.categoria_bene = ?) ";
		
		if( data != null && !data.equals("") ) {
			sql = sql + "AND A.data_fine >= ? AND A.data_inizio <= ?";
		} else {
			sql = sql + "AND A.data_fine >= current_date AND A.data_inizio <= current_date";
		}
	}
	try {
		PreparedStatement st = conn.prepareStatement(sql);
		st.setString(1, cat1);
		st.setString(2, cat2);
		
		if( data != null && !data.equals("") ) {
			SimpleDateFormat f = new SimpleDateFormat( "dd-MM-yyyy" );
			Date date = new Date( f.parse(data).getTime() );
			st.setDate(3, date);
			st.setDate(4, date);
		}
		return st.executeQuery();
	} catch (Exception e) {
		return null;
	}
}
%>

</head>


<body>
	<%
	String cat = request.getParameter("cat");
	String assegnatari = request.getParameter("assegnatari");
	if( assegnatari == null ) 
		assegnatari = "dipendenti";
	String data = request.getParameter("data");
	if( data == null ) 
		data = "";
	String deleted = request.getParameter("deleted");
	
	if( cat == null || ( !cat.equals("SA") && !cat.equals("MB/MA") ) ) {
		%>
		<p><i><font size="4">Errore</font></i></p>
		<p><a href="gestionerichieste.jsp"><button>Indietro</button></a></p>
		<%
		return;
	}
	
	HttpSession sess = request.getSession(false);
	if( sess == null ) {
		%>
		<p><i><font size="4">Sessione scaduta. Rieffettuare il login</font></i></p>
		<p><a href="/lmadb"><button>Login</button></a></p>
		<%
		return;
	} 
	if( (sess.getAttribute("type").equals("amministratore") && cat.equals("MB/MA")) ||
		(sess.getAttribute("type").equals("addetto amministrativo") && cat.equals("SA")) ||
		(sess.getAttribute("type").equals("dipendente")) ) {
		%>
		<p><i><font size="4">Autenticazione fallita</font></i></p>
		<p><a href="/lmadb"><button>Login</button></a></p>
		<%
		return;
	} 
	
	if( cat.equals("SA") ) { // categoria SA
		%>
		<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
		<p><i><font size=4>Assegnazioni beni di categoria SA</font></i></p>
		<%
	} else { // categoria MA o MB
		%>
		<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
		<p><i><font size=4>Assegnazioni beni di categoria MB/MA</font></i></p>
		<%
	}
	
	if( deleted != null )
		if( deleted.equals("true") ) {
			%><p><font size=2>Eliminazione andata a buon fine</font></p><%
		} else {
			%><p><font size=2>Eliminazione fallita</font></p><%
		}
	
	%><font size=3>Seleziona gli assegnatari:   </font><%
	if( assegnatari.equals("dipendenti") ) {%>
		<input type="radio" checked onclick="self.document.location.href='visualizzaassegnazioni.jsp?cat=<%=cat %>&assegnatari=dipendenti';" /> Dipendenti
	<%} else { %>
		<input type="radio" onclick="self.document.location.href='visualizzaassegnazioni.jsp?cat=<%=cat %>&assegnatari=dipendenti';" /> Dipendenti
	<%} 
	if( assegnatari.equals("gruppi") ) {%>
		<input type="radio" checked onclick="self.document.location.href='visualizzaassegnazioni.jsp?cat=<%=cat %>&assegnatari=gruppi';" /> Gruppi di Lavoro
	<%} else { %>
		<input type="radio" onclick="self.document.location.href='visualizzaassegnazioni.jsp?cat=<%=cat %>&assegnatari=gruppi';" /> Gruppi di Lavoro
	<%}
	%><p></p>
	
	<form action="visualizzaassegnazioni.jsp">
		<font size=3>Filtra per data </font> <input type="text" name="data" />
		<input type="submit" value="Filtra" />
		<input type="hidden" name="cat" value="<%=cat %>" />
		<input type="hidden" name="assegnatari" value="<%=assegnatari %>"/>
	</form>	
	<p></p>
	<%
	ResultSet rs = getAssegnazioni( cat, assegnatari, data );
	if( rs == null ) {
		%><p><font size=2>Errore</font></p><%
	} else if( !rs.isBeforeFirst() ) {
		%><font size=3><i>Nessuna assegnazione a <%=assegnatari%> nella data specificata</i></font><%
	} else {
		%>
		<font size=3><i>Elenco assegnazioni a <%=assegnatari%></i></font>
		<table border=1>
			<tr>
				<%
				if( assegnatari.equals("dipendenti") ) {
					%><th>Dipendente</th><%
				} else {
					%><th>Gruppo di Lavoro</th><%
				}
				%>
				<th>Bene</th>
				<th>Categoria Bene</th>
				<th>Data inizio</th>
				<th>Data fine</th>
				<th>Note</th>
				<th></th>
				<th></th>
			</tr>
		<%
		while( rs.next() ) {
			%>
			<tr>
				<%
				if( assegnatari.equals("dipendenti") ) {
					%><td><%=rs.getString("matricola") %> - <%=rs.getString("nome")%> <%=rs.getString("cognome") %></td><%
				} else {
					%><td><%=rs.getString("codice") %> - <%=rs.getString("denominazione") %></td><%
				}
				%>
				<td><%=rs.getString("bene") %> - <%=rs.getString("targhetta") %></td>
				<td><%=rs.getString("categoria_bene") %></td>
				<td><%=rs.getString("data_inizio") %></td>
				<td><%=rs.getString("data_fine") %></td>
				<td><%=rs.getString("note") %></td>
				<td>
					<a href="modificaassegnazione.jsp?cat=<%=cat %>&assegnatari=<%=assegnatari%>&codice=<%=rs.getString("cod")%>">
						<button>Modifica</button>
					</a>
				</td>
				<td>
					<a href="../EliminaAssegnazione?cat=<%=cat %>&assegnatari=<%=assegnatari%>&codice=<%=rs.getString("cod")%>">
						<button>Elimina</button>
					</a>
				</td>
			</tr>
			<%
		}
		%>
		</table>
		
		<p><a href="assegnazionebeni.jsp?cat=<%=cat %>"><button>Indietro</button></a></p>
	<%
	} 
%>

</body>
</html>