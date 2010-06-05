<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Assegnazione Bene</title>

<link rel="stylesheet" type="text/css" href="../style.css" />

<script type="text/javascript">
function check( form ) {
	if( form.bene == "" ) {
		alert("Specificare il bene da assegnare");
		return false;
	}
	if( form.dipendente == "" && form.gruppo == "" ) {
		alert("Specificare l'assegnatario");
		return false;
	}
	
	var datainizio = form.datainizio.value;
	var datafine = form.datafine.value;
	
	var dataRegExp = /^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-(19|20)\d\d$/;
	
	if( !datainizio.match( dataRegExp ) || !datafine.match( dataRegExp ) ) {
		alert("Inserire la data nel formato dd-MM-yyyy (es. 04-03-2001)");
		return false;
	} else {
		var dtin = datainizio.split("-");
		var dtfin = datafine.split("-");

		/* sistemazione giorni */
		var giornoin = dtin[0];
		var giornofin = dtfin[0];
		
		if( giornoin.match( /^0\d$/ ) ) {
			giornoin = giornoin.substring(1);
		}

		if( giornofin.match( /^0\d$/ ) ) {
			giornofin = giornofin.substring(1);
		}

		/* sistemazione mesi */
		var mesein = dtin[1];
		var mesefin = dtfin[1];
		
		if( mesein.match( /^0\d$/ ) ) {
			mesein = mesein.substring(1);
		}

		if( mesefin.match( /^0\d$/ ) ) {
			mesefin = mesefin.substring(1);
		}

		if( parseInt(dtfin[2]) < parseInt(dtin[2]) ) {
			alert("La data finale deve essere maggiore della data iniziale: controllare l'anno");
			return false;
		} else if( parseInt(mesefin) < parseInt(mesein) ) {
			alert("La data finale deve essere maggiore della data iniziale: controllare il mese");
			return false;
		} else if( parseInt(giornofin) < parseInt(giornoin) ) {
			alert("La data finale deve essere maggiore della data iniziale: controllare il giorno");
			return false;
		}
	}
}
</script>

</head>
<body>
	<%! String cat = ""; %>
	<%
	
	cat = request.getParameter("cat");
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
	
	String assegnatari = request.getParameter("assegnatari");
	if( assegnatari == null ) 
		assegnatari = "dipendenti";
	
	if( cat.equals("SA") ) {
		%>
		<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
		<p><i><font size=4>Assegnazione Bene di categoria SA</font></i></p>
		<%
	} else {
		%>
		<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
		<p><i><font size=4>Assegnazione Bene di categoria MB/MA</font></i></p>
		<%
	}
		
	%><font size=3>Seleziona gli assegnatari:   </font><%
	if( assegnatari.equals("dipendenti") ) {%>
		<input type="radio" checked onclick="self.document.location.href='assegnabene.jsp?cat=<%=cat %>&assegnatari=dipendenti';" /> Dipendenti
	<%} else { %>
		<input type="radio" onclick="self.document.location.href='assegnabene.jsp?cat=<%=cat %>&assegnatari=dipendenti';" /> Dipendenti
	<%} 
	if( assegnatari.equals("gruppi") ) {%>
		<input type="radio" checked onclick="self.document.location.href='assegnabene.jsp?cat=<%=cat %>&assegnatari=gruppi';" /> Gruppi di Lavoro
	<%} else { %>
		<input type="radio" onclick="self.document.location.href='assegnabene.jsp?cat=<%=cat %>&assegnatari=gruppi';" /> Gruppi di Lavoro
	<%}
	%><p></p><%
	
	String done = request.getParameter("done");
	if( done != null )
		if( done.equals("true") ) {
			%><p><font size=2>Assegnazione effettuata</font></p><%
		} else {
			%><p><font size=2>Assegnazione fallita</font></p><%
		}
	
	String bene = request.getParameter("bene");
	String matricola = request.getParameter("matricola");
	String gruppo = request.getParameter("gruppo");
	%>
	
	<form action="/lmadb/AssegnaBene" onsubmit="return check(this)">
		<table>
			<tr>
				<td>
					<input type="hidden" name=cat value="<%=cat %>" />
					<input type="hidden" name=assegnatari value="<%=assegnatari %>" />
				</td>
			</tr>
			<tr>
				<td>Bene*</td>
				<%
				if( bene != null && !bene.equals("null") ) {
					%><td><input type="text" name=bene readonly value="<%=bene %>"/></td><%
				} else {
					%><td><input type="text" name=bene /></td><%
				}
				%>
				<td>
					<a href="ricercabene.jsp?from=assegnabene&cat=<%=cat%>&assegnatari=<%=assegnatari%>&matricola=<%=matricola%>&gruppo=<%=gruppo%>"><button type="button">Cerca</button></a>
				</td>
			</tr>
			<%
			if( assegnatari.equals("dipendenti") ) {
			%>
				<tr>
					<td>Matr. Dipendente*: </td>
					<%
					if( matricola != null && !matricola.equals("null") ) {
						%><td><input type="text" name=dipendente readonly value="<%=matricola %>"/></td><%
					} else {
						%><td><input type="text" name=dipendente /></td><%
					}
					%>
					<td>
						<a href="ricercapersonale.jsp?from=assegnabene&cat=<%=cat%>&assegnatari=<%=assegnatari%>&bene=<%=bene%>"><button type="button">Cerca</button></a>
					</td>
				</tr>
			<%} else { %>
				<tr>
					<td>Cod Gruppo*: </td>
					<%
					if( gruppo != null && !gruppo.equals("null") ) { 
						%><td><input type="text" name=gruppo readonly value="<%=gruppo %>" /></td><%
					} else {
						 %><td><input type="text" name=gruppo /></td><%
					}
					%>
					<td>
						<a href="ricercagruppo.jsp?from=assegnabene&cat=<%=cat%>&assegnatari=<%=assegnatari%>&bene=<%=bene%>"><button type="button">Cerca</button></a>
					</td>
				</tr>
			<%} %>
			<tr>
				<td>Data inizio*: </td>
				<td><input type="text" name=datainizio /></td>
				<td>es. 22-04-2001</td>
			</tr>
			<tr>
				<td>Data fine*: </td>
				<td><input type="text" name=datafine /></td>
				<td>es. 22-05-2001</td>
			</tr>
			<tr>
				<td>Note: </td>
				<td><textarea name="note" cols='23' rows=''></textarea></td>
			</tr>
			<tr>
				<td><input type="submit" value="Assegna" /></td>
			</tr>
		</table>		
	</form>
	
	<p><a href="assegnazionebeni.jsp?cat=<%=cat %>&assegnatari=<%=assegnatari %>"><button>Indietro</button></a></p>
</body>
</html>