<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inserimento Stanza</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<script type="text/javascript">
/** 
 * Funzione di controllo della correttezza dei dati inseriti
 */
function check( form ) {
	if( form.denominazione.value == "" ){
		window.alert("Inserisci la denominazione");
		return false;
	}
	else if( form.posizione.value == "" ){
		window.alert("Inserisci la posizione");
		return false;
	}
	else if( form.note.value == "" ){
		window.alert("Inserisci le note");
		return false;
	}
	return true;
}
</script>

</head>
<body>
	<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
	<p><i><font size="4">Inserimento Stanza</font></i></p>

<!-- Form di inserimento dati personale -->
<form name="form1" action="../InserimentoStanza" method="get" onsubmit="return check(this)">
	<table cellspacing="5">
	<tr><td align="right">Denominazione:</td> 	<td><input type="text" name="denominazione" size="50"/></td></tr>
	<tr><td align="right">Posizione:</td> 			<td><input type="text" name="posizione" size="50"/></td></tr>
	<tr><td align="right">Note:</td>			<td><input type="text" name="note" size="50"/></td></tr>
	<tr><td><input type="submit" value="Inserisci"></td></tr>
	</table>
</form>
<p>
<a href="gestioneStanze.jsp"><button>Indietro</button></a>
</p>
</body>
</html>