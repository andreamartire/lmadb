<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Gestione Richiesta</title>

<link rel="stylesheet" type="text/css" href="../style.css" />

</head>


<body>
	<%! 
	Connection conn;
	String cat; 
	String codice;
	%>
	<%
	
	cat = request.getParameter("cat");
	codice = request.getParameter("codice");
	if( cat == null || codice == null || ( !cat.equals("SA") && !cat.equals("MB/MA") ) ) {
		%>
		<p><i><font size="4">Errore</font></i></p>
		<p><a href="gestionerichieste.jsp?cat=SA"><button>Indietro</button></a></p>
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
	
	conn = ConnectionManager.getConnection();
	PreparedStatement st;
	String action = request.getParameter("action");
	String esito = "pendenti";
	String dip;
	String subject = null; 
	String body = null;
	String from;
	if( action != null ) {
		st = conn.prepareStatement(
			"UPDATE richiesta SET esito = ? WHERE codice = ?");
		PreparedStatement pst = conn.prepareStatement(
			"SELECT * FROM richiesta NATURAL JOIN account " +
			"WHERE codice = ?");
		pst.setInt(1, Integer.parseInt( codice ));
		ResultSet r = pst.executeQuery();
		r.next();
		dip = r.getString("email");
		
		if( action.equals("accept") ) {
			st.setString(1, "S");
			subject = "Richiesta " + codice + " accettata";
			body = "Mime-Version: 1.0;\nContent-Type: text/plain;\nLa presente per informarLa che la sua richiesta per la sottocategoria " + r.getString("sotto_categoria_bene") + " è stata accettata";
			st.setInt(2, Integer.parseInt( codice ));
			st.executeUpdate();
			MailSender.sendMail( "richieste@lmadb.it", dip, subject, body );
		} else if( action.equals("reject") ) {
			st.setString(1, "N");
			subject = "Richiesta " + codice + " rifiutata";
			body = "Mime-Version: 1.0;\nContent-Type: text/plain;\nLa presente per informarLa che la sua richiesta per la sottocategoria " + r.getString("sotto_categoria_bene") + " è stata rifiutata";
			st.setInt(2, Integer.parseInt( codice ));
			st.executeUpdate();
			MailSender.sendMail( "richieste@lmadb.it", dip, subject, body );
		}
	}
	
	if( cat.equals("SA") ) {
		%>
		<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
		<p><i><font size=4>Gestione richiesta SA</font></i></p>
		<%
	} else {
		%>
		<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
		<p><i><font size=4>Gestione richiesta MB/MA</font></i></p>
		<%
	}
	
	st = conn.prepareStatement(
			"SELECT P.matricola, P.nome, P.cognome, S.codice AS codst, " +
				"S.nome AS nomest, R.codice, R.motivazione, R.data, R.esito " +
			"FROM richiesta R JOIN personale P ON R.personale = P.matricola " +
				"JOIN sottocategoriabene S ON R.sotto_categoria_bene = S.codice " +
			"WHERE R.codice = ?");
	st.setInt(1, Integer.parseInt( codice ));
	ResultSet rs = st.executeQuery(); 	
	rs.next();
	esito = rs.getString("esito");
	%>
	
	<table border="1" width="400">
		<tr>
			<th>Codice</th>
			<td><%=rs.getString("codice") %></td>
		</tr>
		<tr>
			<th>Dipendente</th>
			<td><%=rs.getString("matricola")%> - <%=rs.getString("nome")%> <%=rs.getString("cognome")%></td>
		</tr>
		<tr>
			<th>Sotto categoria</th>
			<td><%=rs.getString("codst") %> - <%=rs.getString("nomest")%></td>
		</tr>
		<tr>
			<th>Data</th>
			<td><%=rs.getString("data") %></td>
		</tr>
		<tr>
			<th>Motivazione</th>
			<td><%=rs.getString("motivazione") %></td>
		</tr>
		<tr>
			<th>Esito</th>
			<td><%=esito %></td>
		</tr>
		<%
		if( esito.equals("-") ) {
			%>
			<tr>
				<td>
					<center>
						<a href="gestionerichiesta.jsp?cat=<%=cat%>&codice=<%=codice%>&action=accept">
							<button>Accetta</button>
						</a>
					</center>
				</td>
				<td>
					<center>
						<a href="gestionerichiesta.jsp?cat=<%=cat%>&codice=<%=codice%>&action=reject">
							<button>Rifiuta</button>
						</a>
					</center>
				</td>
			</tr>
			<%
			esito = "pendenti";
		} else if( esito.equals("S") ) {
			esito = "accettate";
		} else if( esito.equals("N") ) {
			esito = "rifiutate";
		}
		%>
	</table>
	
	<p><a href="richieste.jsp?cat=<%=cat %>&esito=<%=esito %>"><button>Indietro</button></a></p>
	
</body>
</html>