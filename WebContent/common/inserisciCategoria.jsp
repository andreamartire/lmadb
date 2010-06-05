<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.*"%>
<%@ page import="util.ConnectionManager" %>
<%!

public ResultSet getCategorie() throws Exception{
	Connection conn=ConnectionManager.getConnection();
	PreparedStatement st=conn.prepareStatement("SELECT * FROM CategoriaBene");
	return st.executeQuery();
}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inserimento Categoria</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<script type="text/javascript">
/** 
 * Funzione di controllo della correttezza dei dati inseriti
 */
function check( form ) {
	if( form.nome.value == "" || form.sigla.value == "" ){
		window.alert("Inserisci correttamente i valori");
		return false;
	}
	return true;
}
</script>

</head>
<body>
	<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
	<p><i><font size="4">Inserimento Nuova Categoria</font></i></p>

<!-- Form di inserimento dati personale -->
<form name="form1" action="../InserimentoCategoria" method="get" onsubmit="return check(this)">
	<table cellspacing="5">
	<tr><td align="right">Sigla:</td> 	<td><input type="text" name="sigla" size="50"/></td></tr>
	<tr><td align="right">Nome:</td> 	<td><input type="text" name="nome" size="50"/></td>
	<td><input type=submit value="Inserisci"></td></tr>
	</table>
</form>
<p><a href="gestioneCategorie.jsp"><button>Indietro</button></a></p>
</body>
</html>