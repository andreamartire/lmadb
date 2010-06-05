<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jdbc.JDBC" %>
<%@ page import="java.sql.*" %>
<%! String codice, denom, pos, note; Connection conn; 

public ResultSet getResult( String orderby, String cod, String den, String posiz, String note_ ) 
throws Exception {
	//query
	String query = "SELECT * FROM stanza WHERE 1=1 ";
	if ( cod != null && !cod.equals("") )
		query = query + " AND upper( codice ) LIKE upper('%"+cod+"%') ";
	if ( den != null && !den.equals("") )
		query = query + " AND upper( denominazione ) LIKE upper('%"+den+"%') ";
	if ( posiz != null && !posiz.equals("") )
		query = query + " AND upper( posizione ) LIKE upper('%"+posiz+"%') ";
	if ( note_ != null && !note_.equals("") )
		query = query + " AND upper( note ) LIKE upper('%"+note_+"%') ";
	// applico ordinamenti
	
	if ( orderby != null )
		query = query + " ORDER BY " + orderby;
	//System.out.println(query);
	PreparedStatement st = conn.prepareStatement(query);
	return st.executeQuery();
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="util.ConnectionManager"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Stanze</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<script>
	function conferma(){
		chiediConferma = confirm("Sei sicuro di voler eliminare la stanza corrente?");
		  
		if (chiediConferma == true){
			//location.href="addettohome.jsp"; //ricarica la pagina 
			return true;
		}
		else
			location.href="#";
		return false;
	}
</script>

</head>
<body>
	<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
	<font size=3>Inserisci una stanza      </font><a href="inserisciStanza.jsp"><button>Inserisci</button></a>
	<br><br>
		<form action="../Login" onclick="return true"><%
			if( request.getParameter("view") == null || request.getParameter("view").equals("tutti") ) {%>
				<input type="radio" name="esito" value="tutti" checked onclick="self.document.location.href='gestioneStanze.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" onclick="self.document.location.href='gestioneStanze.jsp?view=ricerca';">Ricerca<br><br><%
			}
			else {%>
				<input type="radio" name="esito" value="tutti" onclick="self.document.location.href='gestioneStanze.jsp?view=tutti';">Tutti
				<input type="radio" name="esito" value="ricerca" checked onclick="self.document.location.href='gestioneStanze.jsp?view=ricerca';">Ricerca<br><br><%
			}%>
		</form><%
	
	if( request.getParameter("view") != null && request.getParameter("view").equals("ricerca") ){%>
		<form action="gestioneStanze.jsp">
			<table><tr><th>Criteri di ricerca</th></tr>
				<tr><td>Codice</td>
				<td><input type="text" name="codice" ></input></td></tr>
				<tr><td>Denominazione</td>
				<td><input type="text" name="denominazione" ></input></td></tr>
				<tr><td>Posizione</td>
				<td><input type="text" name="posizione" ></input></td></tr>
				<tr><td>Note</td>
				<td><input type="text" name="note" ></input></td>
				<td><input type="hidden" name="view" value="ricerca"></input></td>
				<td><input type="submit" value="Cerca"></td></tr>
			</table>
		</form>
		<br>
		<%
	}%>

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
			
			conn = ConnectionManager.getConnection();
			ResultSet res = getResult(request.getParameter("orderby"),
					request.getParameter("codice"),
					request.getParameter("denominazione"),
					request.getParameter("posizione"),
					request.getParameter("note"));
			
			%>
			<table border="1" cellpadding="3" cellspacing="0">
				<tr><th><b><a href="gestioneStanze.jsp?orderby=codice">Codice</a></b></th>
				<th><b><a href="gestioneStanze.jsp?orderby=denominazione">Denominazione</a></b></th>
				<th><b><a href="gestioneStanze.jsp?orderby=posizione">Posizione</a></b></th>
				<th><b><a href="gestioneStanze.jsp?orderby=note">Note</a></b></th>
				<th></th><th></th><th></th></tr>
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
				<td><a href="visualizzaBeniStanza.jsp?idStanza=<%=codice%>"><button>Visualizza Beni</button></a></td>
				</tr>
				<%
			}%>
			</table>
			<%
		}
		catch ( Exception e ) {
			e.printStackTrace();
		}
	%>
	<p><a href="addettohome.jsp"><button>Indietro</button></a></p>
</body>
</html>