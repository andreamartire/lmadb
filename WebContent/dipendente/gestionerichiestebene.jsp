<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Richieste Beni</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!Connection conn;
HttpSession sess;

public ResultSet getProprieRichieste() throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT S.nome, R.esito, R.codice, R.data " +
			"FROM account A, richiesta R, sottocategoriabene S " +
			"WHERE A.username=? AND A.personale = R.personale AND R.sotto_categoria_bene = S.codice"
	);
	st.setString( 1, (String)sess.getAttribute("name") );
	return st.executeQuery();
}

public ResultSet getNomeSottocategoria() throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st= conn.prepareStatement(
			"SELECT nome " +
			"FROM sottocategoriabene"
	);
	return st.executeQuery();
}
%>

<script type="text/javascript">
	function check( form ) {
		if(form.nomeSottoCategoriaBene.value == "SCB" ) {
			window.alert("Inserisci la sottocategoria");
			return false;
		}
		return true;
	}
	</script>
</head>
<body>
<%
sess = request.getSession(false);

if( sess == null || !sess.getAttribute("type").equals("dipendente") ) {
	%><p><i><font size="4">Autenticazione fallita</font></i></p>
	<p>
	<a href="../login.html"><button>Indietro</button></a>
	</p><%
	return;
}%>

<center><i><font size="5">Profilo Dipendente</font></i></center><hr>

<p><font size="4">Effettua la richiesta di un bene</font></p>

<font size="2"> Seleziona la sottocategoria</font>
<form action="../RichiesteBeni" method=post name="form" onsubmit="return check(this)">
<select name='nomeSottoCategoriaBene'>
<%ResultSet rs=getNomeSottocategoria();%>
<%while(rs.next()){%>
	<option value =<%=rs.getString("nome")%>><%=rs.getString("nome")%></option>
<%} %>
</select>
<p><font size="2">Motivazione:</font><br></br>
<textarea name="motivazione" cols='50' rows='5'></textarea>
</p>
<p>
<input type="submit" value="Invia">
</p>

</form>
<hr></hr>
<br>
<font size="3">Elenco richieste</font><br>
<br>

<%rs=getProprieRichieste(); 
	if(!rs.isBeforeFirst()){%>
		<font size="3"> Non ci sono richieste fatte</font><br></br>
	<%}
	else{%>
		<table border="1" cellpadding="3" cellspacing="0">
		<tr><th>Codice</th><th>Sotto categoria</th><th>Data</th><th>Esito</th></tr>
		<%while(rs.next()){%>
			<tr>
				<td><%=rs.getString("codice") %></td>
				<td><%=rs.getString("nome")%></td>
				<td><%=rs.getString("data") %></td>
				<td><%=rs.getString("esito") %></td>
			</tr>
		<%}%>
		</table>
	<%} %>

<br></br>
</body>
<hr></hr>
<p><a href=diphome.jsp><button>Home</button></a></p>
</html>