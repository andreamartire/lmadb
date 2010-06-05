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
<title>Inserimento SottoCategoria</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<script type="text/javascript">
/** 
 * Funzione di controllo della correttezza dei dati inseriti
 */
function check( form ) {
	if( form.nome == ""){
		window.alert("Inserisci il nome della Sottocategoria");
		return false;
	}
	return true;
}
</script>

</head>
<body>
	<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
	<p><i><font size="4">Inserimento SottoCategoria</font></i></p>

<!-- Form di inserimento dati personale -->
<form name="form1" action="../InserimentoSottoCategoria" method="get" onsubmit="return check(this)">
	<table cellspacing="5">
	<tr><td align="right">Nome:</td> 	<td><input type="text" name="nome" size="50"/></td></tr>
	<tr><td align="right">Categoria Bene:</td> 			
	<td>
		<select name='nomeCategoriaBene'><%
			ResultSet res = getCategorie();
			while( res.next() ) {%>
				<option value="<%=res.getString("sigla")%>"><%=res.getString("nome")%></option><%
			}%>
		</select>
	</td></tr>
	</table>
	<center><input type=submit value="Inserisci"></center>
</form>
<p><a href="gestioneSottoCategorie.jsp"><button>Indietro</button></a></p>
</body>
</html>