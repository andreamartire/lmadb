<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jdbc.JDBC" %>
<%@ page import="java.sql.*" %>
<%! String codice, denom, pos, note;  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="util.ConnectionManager"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Richieste</title>
<link rel="stylesheet" type="text/css" href="../style.css" />

</head>
<body>
	<a href="addettohome.jsp"><button>Back</button></a>
	<br><br>

	<%  
		try {
			HttpSession sess = request.getSession(false);
			if( sess == null || !sess.getAttribute("type").equals("addetto amministrativo") ) {
				%><p><i><font size="4" color="#FF8000">Autenticazione fallita</font></i></p>
				<p>
				<a href="login.html"><button>Indietro</button></a>
				</p><%
				return;
			}
			
			Connection connection = ConnectionManager.getConnection();
			Statement st = connection.createStatement();

			// eseguo query
			ResultSet res = st.executeQuery("SELECT * FROM richiesta R, sotto_categoria_bene S "+
					"WHERE R.sotto_categoria_bene = S.");%>
			<table border="1" cellpadding="3" cellspacing="0">
				<tr><th><b>Codice</b></th><th><b>Denominazione</b></th><th><b>Posizione</b></th><th><b>Note</b></th></tr>
			<%
			while ( res.next() ) {
				codice = res.getString("codice");
				denom  = res.getString("denominazione");
				pos = res.getString("posizione");
				note = res.getString("note");%>
				
				<tr><td><%=codice%></td><td><%=denom%></td>
				<td><%=pos%></td><td><%=note%></td>
				<td><a href="gestioneStanza.jsp?idStanza=<%=codice%>"><button>Modifica</button></a></td>
				<td><a href="eliminaStanza.jsp?idStanza=<%=codice%>" onClick="return conferma();"><button>Elimina</button></a></td>
				<td><a href="visualizzaBeni.jsp?idStanza=<%=codice%>"><button>Visualizza Beni</button></a></td>
				</tr>
				<%
			}%>
			</table>
			<br>
			<a href="inserisciStanza.jsp"><button>Inserisci</button></a>
			<%
		}
		catch ( Exception e ) {
			
		}
	%>

</body>
</html>