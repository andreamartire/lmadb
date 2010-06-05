<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="util.ConnectionManager"%>
<%! int nig, importo; String nis, dt_ac, dt_at, dt_sc, garanzia, conforme, obsoleto, targhetta; %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Modifica Bene</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
<%

HttpSession sess = request.getSession(false);
String user = (String) sess.getAttribute("type");
if( user.equals("addetto amministrativo") ) {
	%><center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr> 
	<p><i><font size="4">Modifica Bene</font></i></p><%
}
else if ( user.equals("amministratore") ){
	%><center><i><font size="5">Profilo Amministratore</font></i></center><hr> 
	<p><i><font size="4">Modifica Bene</font></i></p><%
}

if( sess == null ) {
	response.sendRedirect("../Login");
	return;
}

String done =  request.getParameter("done");

if( done != null ) {
	if( done.equals("true") ) {
		%><p><i><font size="2" color="BLUE">Modifica andata a buon fine</font></i></p><%
	} else {
		%><p><i><font size="2" color="RED">Modifica fallita</font></i></p><%
	}
}

Connection conn = ConnectionManager.getConnection();
int bene = Integer.valueOf( request.getParameter("idBene") );
PreparedStatement st = conn.prepareStatement("SELECT * FROM bene WHERE numero_inventario_generico = ?");
st.setInt( 1, bene );
ResultSet rs = st.executeQuery();

if( rs.next() ) {
	nig = rs.getInt("numero_inventario_generico");
	nis = rs.getString("numero_inventario_seriale");
	importo = rs.getInt("importo");
	dt_ac = rs.getString("data_acquisto");
	if( dt_ac != null ) 
		dt_ac = dt_ac.split(" ")[0];
	garanzia = rs.getString("garanzia");
	dt_at = rs.getString("data_attivazione");
	if( dt_at != null )
		dt_at = dt_at.split(" ")[0];
	dt_sc = rs.getString("data_scadenza");
	if( dt_sc != null ) 
		dt_sc = dt_sc.split(" ")[0];
	targhetta = rs.getString("targhetta");
	conforme = rs.getString("conforme");
	obsoleto = rs.getString("obsoleto");
}

%>


<p><font size="4">Informazioni Bene:</font></p>
<form action="../modificaBene" method="get" onsubmit="return check(this)">
	<table>
		<tr><td align="right"><i>Num.Inv.Gen.:</i></td><td><input type="text" name="nig" readonly="readonly" value="<%=nig %>"></td><td></td></tr>
		<tr><td align="right"><i>Num.Inv.Ser:</i></td><td><input type="text" name="nis" readonly="readonly" value="<%=nis %>"></td></tr>
		<tr><td align="right"><i>Importo:</i></td><td><input type="text" name="importo" value="<%=importo %>"></td></tr>
		<tr><td align="right"><i>Data Acquisto:</i></td><td><input type="text" name="dt_ac" value="<%=dt_ac %>"></td></tr>
		<tr><td align="right"><i>Garanzia:</i></td><td><input type="text" name="garanzia" value="<%=garanzia %>"></td></tr>
		<tr><td align="right"><i>Data Attivazione:</i></td><td><input type="text" name="dt_at" value="<%=dt_at %>"></td></tr>
		<tr><td align="right"><i>Data Scadenza:</i></td><td><input type="text" name="dt_sc" value="<%=dt_sc %>"></td></tr>
		<tr><td align="right"><i>Targhetta:</i></td><td><input type="text" name="targ" value="<%=targhetta %>"></td></tr>
		<tr>
			<td align="right"><i>Conforme:</i></td><td>
				<SELECT NAME ="conforme">
					<% if (conforme != null && conforme.equals("S") )  { %>
							<OPTION value= "S" selected> SI </OPTION>
							<OPTION value= "N" > NO </OPTION>
					<% } else { %>
							<OPTION value= "S" > SI </OPTION>
							<OPTION value= "N" selected> NO </OPTION>
					<% } %>			
				</SELECT>
			</td>
		</tr>
		<tr><td align="right"><i>Obsoleto:</i></td><td>
			<SELECT NAME ="obsoleto">
				<% if (obsoleto!=null && obsoleto.equals("S"))  { %>
						<OPTION value= "S" selected> SI </OPTION>
						<OPTION value= "N" > NO </OPTION>
				<% } else { %>
						<OPTION value= "S" > SI </OPTION>
						<OPTION value= "N" selected> NO </OPTION>
				<% } %>
			</SELECT>
		</tr>
		<tr><td><input type=submit value="Salva"></td></tr>
	</table>
</form>


<p>
<a href="visualizzaBeni.jsp"><button>Indietro</button></a>
</p>
</body>

<script type="text/javascript">
	function check( form ) {
		var data = /^\d{2}[A-Z]{3}\d{4}$/i;
		if ( !dt_ac.match(data) ) {//|| !form.dt_at.match(data) || !form.dt_sc.match(data) ) {
			window.alert("La data deve essere nel formato DDMMMAAAA");
			return false;
		}
		return true;
	}
</script>
</html>