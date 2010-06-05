<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.Connection"%>
<%@page import="util.ConnectionManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Ricerca Gruppo</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
	<% 
	String from = request.getParameter("from");
	String done = request.getParameter("done");
	String bene = request.getParameter("bene");
	%> 
	<center><i><font size=5>Ricerca Gruppo</font></i></center><hr>
	
	<%
	if( done != null ) {
		// effettua la ricerca e visualizza i risultati
		%>
		<p><font size=3>Risultati ricerca</font></p>
		<%
		String nome = request.getParameter("nome");
		
		Connection conn = ConnectionManager.getConnection();
		PreparedStatement st;
		st = conn.prepareStatement(
				"SELECT * " +
				"FROM gruppodilavoro " +
				"WHERE upper( denominazione ) LIKE upper( ? )");
		nome = "%" + nome + "%";
		st.setString(1, nome);
		
		ResultSet rs = st.executeQuery();
		
		if( !rs.isBeforeFirst() ) {
			%>
			<font size=3>Nessun record trovato</font>
			<%
			if( from.equals("assegnabene") ) {
				String cat = request.getParameter("cat");
				String assegnatari = request.getParameter("assegnatari");
				%><p><a href="ricercagruppo.jsp?from=assegnabene&cat=<%=cat%>&assegnatari=<%=assegnatari%>&bene=<%=bene%>"><button>Indietro</button></a></p><%
			}
		} else {
			%>
			<table border="1">
				<tr>
					<th>Codice</th>
					<th>Denominazione</th>
				</tr>
			<%
			while( rs.next() ) {
				%>
				<tr>
					<td><%=rs.getString("codice") %></td>
					<td><%=rs.getString("denominazione") %></td>
					<%
					if( from.equals("assegnabene") ) {
						String cat = request.getParameter("cat");
						String assegnatari = request.getParameter("assegnatari");
						%><td>
							<a href="assegnabene.jsp?cat=<%=cat%>&assegnatari=<%=assegnatari %>&gruppo=<%=rs.getString("codice")%>&bene=<%=bene%>">
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
				%><p><a href="ricercagruppo.jsp?from=assegnabene&cat=<%=cat%>&assegnatari=<%=assegnatari%>&bene=<%=bene%>"><button>Indietro</button></a></p><%
			}
		}
			
	} else {
		// inserisci i parametri di ricerca
		%>
		<p><font size=2>Inserisci i valori su cui fare la ricerca</font></p>
		<form action="ricercagruppo.jsp">
			<table>
				<tr>
					<td>
						<input type="hidden" name="from" value="<%=from %>" />
						<input type="hidden" name="done" value="true" />
						<input type="hidden" name="bene" value="<%=bene %>" />
					</td>
				</tr>
				<tr>
					<td>Nome gruppo: </td>
					<td><input type="text" name="nome"/></td>
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
						<td>
							<input type="hidden" name="cat" value="<%=cat%>"/>
							<input type="hidden" name="assegnatari" value="<%=assegnatari%>" />
							<input type=hidden name=bene value="<%=bene%>"/>
						</td>
					</tr>
					</table>
					</form>
					
					<p><a href="assegnabene.jsp?cat=<%=cat%>&assegnatari=<%=assegnatari%>&bene=<%=bene%>"><button>Indietro</button></a></p>
					<%
				}
	}
	
	%>
	
</body>
</html>