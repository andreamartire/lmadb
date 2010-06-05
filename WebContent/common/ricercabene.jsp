<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.Connection"%>
<%@page import="util.ConnectionManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Ricerca Bene</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
	<% 
	HttpSession sess = request.getSession(false);
	if( sess == null ) {
		response.sendRedirect("../Login");
		return;
	}
	String user = (String) sess.getAttribute("type");
	String from = request.getParameter("from");
	String done = request.getParameter("done");
	String matricola = request.getParameter("matricola");
	String gruppo = request.getParameter("gruppo");
	%> 
	<center><i><font size=5>Ricerca Bene</font></i></center><hr>
	
	<%
	if( done != null ) {
		// effettua la ricerca e visualizza i risultati
		%>
		<p><font size=3>Risultati ricerca</font></p>
		<%
		String targhetta = request.getParameter("targhetta");
		String sottocategoria = request.getParameter("sottocategoria");
		
		Connection conn = ConnectionManager.getConnection();
		PreparedStatement st;
		
		String sql = 	"SELECT * " +
						"FROM bene JOIN sottocategoriabene ON codice = sotto_categoria_bene " +
						"WHERE upper( targhetta ) LIKE upper( ? ) AND upper( nome ) LIKE upper( ? )";
		
		if( user.equals("amministratore") ) {
			sql = sql + " AND categoria_bene = 'SA'";
		} else if( user.equals("addetto amministrativo") ) {
			sql = sql + " AND (categoria_bene = 'MB' OR categoria_bene = 'MA')";
		} else {
			%><font size=3>Autenticazione fallita</font><%
			return;
		}
		
		st = conn.prepareStatement( sql );
		targhetta = "%" + targhetta + "%";
		sottocategoria = "%" + sottocategoria + "%";
		st.setString(1, targhetta);
		st.setString(2, sottocategoria);
		
		ResultSet rs = st.executeQuery();
		
		if( !rs.isBeforeFirst() ) {
			%>
			<font size=3>Nessun record trovato</font>
			<%
			if( from.equals("assegnabene") ) {
				String cat = request.getParameter("cat");
				String assegnatari = request.getParameter("assegnatari");
				
				%><p><a href="ricercabene.jsp?from=assegnabene&cat=<%=cat%>&assegnatari=<%=assegnatari%>&matricola=<%=matricola%>&gruppo=<%=gruppo%>"><button>Indietro</button></a></p><%
			}
		} else {
			%>
			<table border="1">
				<tr>
					<th>Codice</th>
					<th>Targhetta</th>
					<th>Descrizione</th>
					<th>Sotto categoria</th>
				</tr>
			<%
			while( rs.next() ) {
				%>
				<tr>
					<td><%=rs.getString("numero_inventario_generico") %></td>
					<td><%=rs.getString("targhetta") %></td>
					<td><%=rs.getString("descrizione") %></td>
					<td><%=rs.getString("nome") %></td>
					<%
					if( from.equals("assegnabene") ) {
						String cat = request.getParameter("cat");
						String assegnatari = request.getParameter("assegnatari");
						%><td>
							<a href="assegnabene.jsp?cat=<%=cat%>&assegnatari=<%=assegnatari%>&matricola=<%=matricola%>&gruppo=<%=gruppo%>&bene=<%=rs.getString("numero_inventario_generico")%>">
								<button>Seleziona</button>
							</a>
						</td><%
					}
					%>
				</tr>
				<%
			}
			%>
			</table>
			<%
			if( from.equals("assegnabene") ) {
				String cat = request.getParameter("cat");
				String assegnatari = request.getParameter("assegnatari");
					
				%><p><a href="ricercabene.jsp?from=assegnabene&cat=<%=cat%>&assegnatari=<%=assegnatari%>&matricola=<%=matricola%>&gruppo=<%=gruppo%>"><button>Indietro</button></a></p><%
			}
		}
			
	} else {
		// inserisci i parametri di ricerca
		%>
		<p><font size=2>Inserisci i valori su cui fare la ricerca</font></p>
		<form action="ricercabene.jsp">
			<table>
				<tr>
					<td>
						<input type="hidden" name="from" value="<%=from %>" />
						<input type="hidden" name="done" value="true" />
						<input type="hidden" name="matricola" value="<%=matricola%>" />
						<input type="hidden" name="gruppo" value=<%=gruppo%> />
					</td>
				</tr>
				<tr>
					<td>Targhetta: </td>
					<td><input type="text" name="targhetta"/></td>
				</tr>
				<tr>
					<td>Sotto Categoria: </td>
					<td><input type="text" name="sottocategoria"/></td>
				</tr>
				<tr>
					<td><input type="submit" value="Cerca"/></td>
				</tr>
				<%
				if( from.equals("assegnabene") ) {
					String cat = request.getParameter("cat");
					String assegnatari = request.getParameter("assegnatari");
					%> 
							<tr>
								<td><input type="hidden" name="cat" value="<%=cat %>"/></td>
								<td><input type="hidden" name="assegnatari" value="<%=assegnatari %>"/></td>
							</tr>
						</table>
					</form>
					
					<p><a href="assegnabene.jsp?cat=<%=cat%>&assegnatari=<%=assegnatari%>"><button>Indietro</button></a></p>
					<%
				}
	}
	
	%>
	
</body>
</html>