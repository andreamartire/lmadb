<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="util.ConnectionManager"%>
<%@page import="java.text.SimpleDateFormat"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Modifica Assegnazioni</title>

<link rel="stylesheet" type="text/css" href="../style.css" />

</head>
<body>

<%
	
	String cat = request.getParameter("cat");
	String assegnatari = request.getParameter("assegnatari");
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
	
	String codice = request.getParameter("codice");
	Connection conn = ConnectionManager.getConnection();
	
	if( cat.equals("SA") ) {
		%>
		<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
		<p><i><font size=4>Modifica assegnazioni beni di categoria SA a <%=assegnatari %></font></i></p>
		<%
	} else {
		%>
		<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
		<p><i><font size=4>Modifica assegnazioni beni di categoria MB/MA a <%=assegnatari %></font></i></p>
		<%
	}
	
	if( request.getParameter("edit") != null ) {
		int bene = Integer.parseInt( request.getParameter("bene") );
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		Date datainizio = new Date( f.parse(request.getParameter("datainizio")).getTime() );
		Date datafine = new Date( f.parse(request.getParameter("datafine")).getTime() );
		String note = request.getParameter("note");
		
		if( !datainizio.before( datafine ) ) {
			%><font size=2>La data finale dev'essere maggiore della data iniziale</font><%
		} else {
			PreparedStatement st;
			String update;
			if( assegnatari.equals("dipendenti") ) {
				int personale = Integer.parseInt( request.getParameter("personale") );
				update = "UPDATE dotazione SET personale = ?, bene = ?, data_inizio = ?, data_fine = ?, note = ? " +
						"WHERE codice = ?";
				st = conn.prepareStatement(update);
				st.setInt(1, personale);
			} else {
				String gruppo = request.getParameter("gruppo");
				update = "UPDATE assegnazione SET gruppo_di_lavoro = ?, bene = ?, data_inizio = ?, data_fine = ?, note = ? " +
						"WHERE codice = ?";
				st = conn.prepareStatement(update);
				st.setString(1, gruppo);
			}
			st.setInt(2, bene);
			st.setDate(3, datainizio);
			st.setDate(4, datafine);
			st.setString(5, note);
			st.setString(6, codice);
			
			try {
				st.executeUpdate();
				%><p><font size=2>Modifica andata a buon fine</font></p><%
			} catch (Exception e) {
				%><p><font size=2>Modifica fallita</font></p><%
			}
		}
	}
	
	String sql;
	if( assegnatari.equals("dipendenti") ) {
		sql = "SELECT * FROM dotazione WHERE codice = ?";
	} else {
		sql = "SELECT * FROM assegnazione WHERE codice = ?";
	}
	PreparedStatement st = conn.prepareStatement(sql);
	st.setString(1, codice);
	ResultSet rs = st.executeQuery();
	rs.next();
	%>
	
	<form action="modificaassegnazione.jsp" method="post">
		<table>
			<tr>
				<td>
					<input type=hidden name=cat value=<%=cat %> />
					<input type=hidden name=assegnatari value=<%=assegnatari %> />
					<input type=hidden name=edit value=true />
					Codice: 
				</td>
				<td>
					<input type="text" readonly name=codice value=<%=codice %> />
				</td>
			</tr>
			<tr>
				<%if( assegnatari.equals("dipendenti") ) { %>
					<td>Dipendente: </td>
					<td><input type=text name=personale value=<%=rs.getInt("personale") %>></td>
				<%} else { %>
					<td>Gruppo: </td>
					<td><input type=text name=gruppo value=<%=rs.getString("gruppo_di_lavoro") %>></td>
				<%} %>
			</tr>
			<tr>
				<td>Bene: </td>
				<td><input type=text name=bene value=<%=rs.getInt("bene") %>></td>
			</tr>
			<tr>
				<td>Data inizio: </td>
				<td><input type=text name=datainizio value=<%=rs.getDate("data_inizio") %>></td>
			</tr>
			<tr>
				<td>Data fine: </td>
				<td><input type=text name=datafine value=<%=rs.getDate("data_fine") %>></td>
			</tr>
			<tr>
				<td>Note: </td>
				<td><textarea name=note cols='30' rows=''><%=rs.getString("note") %></textarea></td>
			</tr>
			<tr>
				<td><input type=submit value=Modifica /></td>
			</tr>
		</table>
	</form>
	
	<%if( request.getParameter("edit") == null ) { %>
		<%String referer = request.getHeader("referer"); %>
		<p><a href=<%=referer %>><button>Indietro</button></a></p>
	<%} else { %>
		<p><a href="visualizzaassegnazioni.jsp?cat=<%=cat%>&assegnatari=<%=assegnatari%>"><button>Indietro</button></a></p>
	<%}
%>

</body>
</html>