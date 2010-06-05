<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.*"%>
<%@ page import="util.ConnectionManager" %>
<%! String catSelected, catSel; %>
<%!

public ResultSet getCategorie() throws Exception{
	Connection conn=ConnectionManager.getConnection();
	Statement st1=conn.createStatement();
	return st1.executeQuery("SELECT * FROM CategoriaBene");
}

public ResultSet getSottoCategorie() throws Exception{
	Connection conn=ConnectionManager.getConnection();
	Statement st2=conn.createStatement();
	return st2.executeQuery("SELECT * FROM sottocategoriabene");
}

public ResultSet getSottoCategorieSelected( String nome ) throws Exception{
	Connection conn=ConnectionManager.getConnection();
	PreparedStatement st3=conn.prepareStatement(
			"SELECT * FROM sottocategoriabene S JOIN categoriabene C ON C.sigla = S.categoria_bene " +
			"WHERE C.nome=?");
	st3.setString(1,nome);
	return st3.executeQuery();
}

public ResultSet getFornitore() throws Exception{
	Connection conn=ConnectionManager.getConnection();
	Statement st4=conn.createStatement();
	return st4.executeQuery("SELECT * FROM Fornitore");
}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inserimento Bene</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<script type="text/javascript">
/** 
 * Funzione di controllo della correttezza dei dati inseriti
 */
function cat_selected( categoria ) {
	str = "InserisciBene.jsp?categoria="+String(categoria.value);
	window.location = str;
	return true;
}

function check( form ) {
	if ( form.categ.value == "-" ) {
		window.alert("Scegli la categoria");
		return false;
	}
	if ( form.sottoCateg.value == "-" ) {
		window.alert("Scegli la sottoCategoria");
		return false;
	}
	if ( form.importo.value == "" ) {
		window.alert("Scegli un importo");
		return false;
	}
	var dataRegExp = /^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-(19|20)\d\d$/;
	if ( form.dt_at.value != "" && !form.dt_at.value.match( dataRegExp ) ) {
		window.alert("Inserisci la data nel formato dd-MM-yyyy. es: 03-01-2010");
		return false;
	}
	if ( form.dt_sc.value != "" && !form.dt_sc.value.match( dataRegExp ) ) {
		window.alert("Inserisci la data nel formato dd-MM-yyyy. es: 03-01-2010");
		return false;
	}
	if ( !form.dt_aq.value.match( dataRegExp ) ) {
		window.alert("Inserisci la data nel formato dd-MM-yyyy. es: 03-01-2010");
		return false;
	}
	if ( form.importo.value == "" ) {
		window.alert("Scegli un importo");
		return false;
	}
	if ( form.targ.value == "" ) {
		window.alert("Scegli una targhetta");
		return false;
	}
	if ( form.conforme.value == "-" ) {
		window.alert("Scegli un valore per il campo: conforme");
		return false;
	}
	if ( form.obsoleto.value == "-" ) {
		window.alert("Scegli un valore per il campo: obsoleto");
		return false;
	}
	if ( form.fornitore.value == "-" ) {
		window.alert("Scegli il fornitore");
		return false;
	}
	return true;
}
</script>

</head>
<body>
	<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
	<p><i><font size="4">Inserimento Nuovo Bene</font></i></p>

<!-- Form di inserimento dati bene -->
<form name="form" action="../InserimentoBene" method="get" onsubmit="return check(this)">
	<table cellspacing="5">
		<tr><td align="right">Categoria:</td>
			<td>
				<select name="categ" onchange="return cat_selected(this)">
				<option value="-" selected>-</option>
					<%
					catSel = request.getParameter("categoria");
					if ( catSel != null && !catSel.equals("-") ) { %>
						<option value="<%=catSel%>" selected><%=catSel%></option>
						<%
						ResultSet res = getCategorie();
						while( res.next() ) {
							if( !res.getString("nome").equals(catSel) ) {%>
							<option value="<%=res.getString("nome")%>"><%=res.getString("nome")%></option><%
							}
						}
					}
					else {
						ResultSet res = getCategorie();
						while( res.next() ) {%>
							<option value="<%=res.getString("nome")%>"><%=res.getString("nome")%></option><%
						}
					}%>
				</select>
			</td></tr>
		<tr><td align="right">SottoCategoria:</td>
			<td>
				<select name="sottoCateg">
				<option value="-" selected>-</option>
					<%
					
					catSelected = request.getParameter("categoria");
					if ( catSelected != null ) { 
						ResultSet resSottSel = getSottoCategorieSelected(catSelected);
						while( resSottSel.next() ) { %>
							<option value="<%=resSottSel.getString("codice")%>"><%=resSottSel.getString("nome")%></option><%
						}
					}
					else {
						ResultSet resSott = getSottoCategorie();
						while( resSott.next() ) {%>
							<option value="<%=resSott.getString("codice")%>"><%=resSott.getString("nome")%></option><%
						}
					}%>
				</select>
			</td></tr>
		<tr><td align="right">Importo:</td> 	<td><input type="text" name="importo" size="50"/></td></tr>
		<tr><td align="right">Data Aquisto:</td> 	<td><input type="text" name="dt_aq" size="50"/></td></tr>
		<tr><td align="right">Garanzia:</td> 	<td><input type="text" name="garanzia" size="50"/></td></tr>
		<tr><td align="right">Data Attivazione:</td> 	<td><input type="text" name="dt_at" size="50"/></td></tr>
		<tr><td align="right">Data Scadenza:</td> 	<td><input type="text" name="dt_sc" size="50"/></td></tr>
		<tr><td align="right">Targhetta:</td> 	<td><input type="text" name="targ" size="50"/></td></tr>
		<tr><td align="right">Descrizione:</td> 	<td><input type="text" name="desc" size="50"/></td></tr>
		<tr><td align="right">Conforme:</td>
			<td>
				<select name="conforme">
					<option value="-">-</option>
					<option value="S">S</option>
					<option value="N">N</option>
				</select>
			</tr>
		<tr><td align="right">Obsoleto:</td>
			<td>
				<select name="obsoleto">
					<option value="-">-</option>
					<option value="S">S</option>
					<option value="N">N</option>
				</select>
			</td></tr>
		<tr><td align="right">Fornitore:</td>
			<td>
				<select name="fornitore">
				<option value="-" selected>-</option>
					<%
					ResultSet resForn = getFornitore();
					while( resForn.next() ) {%>
						<option value="<%=resForn.getString("partita_iva")%>"><%=resForn.getString("nome_organizzazione")%></option><%
					}%>
				</select>
			</td>
		<td><input type=submit value="Inserisci"></td></tr>
	</table>
	
</form>
<p><a href="visualizzaBeni.jsp"><button>Indietro</button></a></p>
</body>
</html>