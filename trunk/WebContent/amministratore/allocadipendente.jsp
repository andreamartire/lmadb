<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Allocazione dipendente</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
<script type="text/javascript">
/** 
 * Funzione di controllo della correttezza dei dati inseriti
 */
function check( form ) {
	var dipendente = form.dipendente.value;
	if( dipendente == "" ) {
		alert("Inserire la matricola");
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
	return true;
}
</script>
</head>


<body>
	<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
	
	<p><i><font size="4">Allocazione Dipendente</font></i></p>
	<form action="gestionegruppo.jsp" method="get" onsubmit="return check(this)">
		<table cellspacing="5">
			<tr>
				<td><input type="hidden" name=codice value="<%=request.getParameter("gruppo") %>"></td>
			</tr>
			<tr>
				<td align="right">Dipendente*:</td>
				<%
				String matricola = request.getParameter("matricola");
				if( matricola != null ) {
					%>
					<td><input type="text" name="dipendente" readonly="readonly" value="<%=matricola%>"/></td>
					<%
				} else {
					%>
					<td><input type="text" name="dipendente"/></td>
					<%
				} 
				%>
				<td>
					<a href="../common/ricercapersonale.jsp?from=allocadipendente&gruppo=<%=request.getParameter("gruppo") %>">
						<button type="button">Cerca</button>
					</a>
				</td>
			</tr>
			<tr>
				<td align="right">Data inizio*:</td> 		
				<td><input type="text" name="datainizio"/></td>
			</tr>
			<tr>
				<td align="right">Data fine*:</td> 			
				<td><input type="text" name="datafine"/></td>
			</tr>
			<tr>
				<td><input type="submit" value="Alloca"></td>
			</tr>
		</table>
	</form>
	
	<p>
		<a href="gestionegruppi.jsp"><button>Indietro</button></a>
	</p>
</body>
</html>