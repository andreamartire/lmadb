<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.Connection"%>
<%@page import="util.ConnectionManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Ricerca Personale</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
	<% 
	String from = request.getParameter("from");
	String done = request.getParameter("done");
	String bene = request.getParameter("bene");
	%> 
	<center><i><font size=5>Ricerca Personale</font></i></center><hr>
	
	<%
	if( done != null ) {
		// effettua la ricerca e visualizza i risultati
		%>
		<p><font size=3>Risultati ricerca</font></p>
		<%
		String nome = request.getParameter("nome");
		String cognome = request.getParameter("cognome");
		
		Connection conn = ConnectionManager.getConnection();
		PreparedStatement st;
		st = conn.prepareStatement(
				"SELECT P.* " +
				"FROM personale P JOIN account A ON P.matricola = A.personale " +
				"WHERE A.tipologia = 'dipendente' AND upper( P.nome ) LIKE upper( ? ) AND upper( P.cognome ) LIKE upper( ? )");
		nome = "%" + nome + "%";
		cognome = "%" + cognome + "%";
		st.setString(1, nome);
		st.setString(2, cognome);
		
		ResultSet rs = st.executeQuery();
		
		if( !rs.isBeforeFirst() ) {
			%>
			<font size=3>Nessun record trovato</font>
			<%
			if( from.equals("allocadipendente") ) { 
				String gruppo = request.getParameter("gruppo");
				%><p><a href="ricercapersonale.jsp?from=allocadipendente&gruppo=<%=gruppo%>&bene=<%=bene%>"><button>Indietro</button></a></p><%
			} else if( from.equals("assegnabene") ) {
				String cat = request.getParameter("cat");
				String assegnatari = request.getParameter("assegnatari");
				%><p><a href="ricercapersonale.jsp?from=assegnabene&cat=<%=cat%>&assegnatari=<%=assegnatari%>&bene=<%=bene%>"><button>Indietro</button></a></p><%
			}
		} else {
			%>
			<table border="1">
				<tr>
					<th>Matricola</th>
					<th>Nome</th>
					<th>Cognome</th>
					<th>Codice Fiscale</th>
				</tr>
			<%
			while( rs.next() ) {
				%>
				<tr>
					<td><%=rs.getString("matricola") %></td>
					<td><%=rs.getString("nome") %></td>
					<td><%=rs.getString("cognome") %></td>
					<td><%=rs.getString("codice_fiscale") %></td>
					<%
					if( from.equals("allocadipendente") ) { 
						String gruppo = request.getParameter("gruppo");
						%><td>
							<a href="../amministratore/allocadipendente.jsp?gruppo=<%=gruppo%>&matricola=<%=rs.getString("matricola")%>&bene=<%=bene%>">
								<button>Seleziona</button>
							</a>
						</td><%
					} else {
						String cat = request.getParameter("cat");
						String assegnatari = request.getParameter("assegnatari");
						%><td>
							<a href="assegnabene.jsp?cat=<%=cat%>&assegnatari=<%=assegnatari %>&matricola=<%=rs.getString("matricola")%>&bene=<%=bene%>">
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
			if( from.equals("allocadipendente") ) { 
				String gruppo = request.getParameter("gruppo");
				%><p><a href="ricercapersonale.jsp?from=allocadipendente&gruppo=<%=gruppo%>&bene=<%=bene%>"><button>Indietro</button></a></p><%
			} else if( from.equals("assegnabene") ) {
				String cat = request.getParameter("cat");
				String assegnatari = request.getParameter("assegnatari");
				%><p><a href="ricercapersonale.jsp?from=assegnabene&cat=<%=cat%>&assegnatari=<%=assegnatari%>&bene=<%=bene%>"><button>Indietro</button></a></p><%
			}
		}
			
	} else {
		String gruppo = request.getParameter("gruppo");
		String cat = request.getParameter("cat");
		String assegnatari = request.getParameter("assegnatari");
		%>
		<p><font size=2>Inserisci i valori su cui fare la ricerca</font></p>
		<form action="ricercapersonale.jsp">
			<table>
				<tr>
					<td>
						<input type="hidden" name="from" value="<%=from %>" />
						<input type="hidden" name="done" value="true" />
						<input type="hidden" name="bene" value="<%=bene %>" />
					</td>
				</tr>
				<tr>
					<td>Nome: </td>
					<td><input type="text" name="nome"/></td>
				</tr>
				<tr>
					<td>Cognome: </td>
					<td><input type="text" name="cognome"/></td>
				</tr>
				<tr>
					<td><input type="submit" value="Cerca"/></td>
				</tr>
				<tr>
				<%
				if( from.equals("allocadipendente") ) {
					%>
					<td><input type="hidden" name="gruppo" value="<%=gruppo %>"/></td>
					<%
				} else if( from.equals("assegnabene") ) {
					%> 
					<td><input type="hidden" name="cat" value="<%=cat %>"/></td>
					<td><input type="hidden" name="assegnatari" value="<%=assegnatari %>"/></td>
					<%
				}
				%>
				</tr>
			</table>
		</form>
		<%
		if( from.equals("allocadipendente") ) {
			%>
			<p>
				<a href="../amministratore/allocadipendente.jsp?gruppo=<%=gruppo%>&bene=<%=bene%>">
					<button>Indietro</button>
				</a>
			</p><%
		} else if( from.equals("assegnabene") ) {
			%>
			<p>
				<a href="assegnabene.jsp?cat=<%=cat%>&assegnatari=<%=assegnatari %>&bene=<%=bene%>">
					<button>Indietro</button>
				</a>
			</p><%
		}
	}
	%>
	
</body>
</html>