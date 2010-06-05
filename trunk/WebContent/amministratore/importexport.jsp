<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.ImportExport" %>
<%@ page import="java.io.File" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Data Import/Export</title>

<link rel="stylesheet" type="text/css" href="../style.css" />
</head>

<body>
	<% 
	HttpSession sess = request.getSession(false);
	if( sess == null ) {
		response.sendRedirect("/lmadb");
		return;
	}
	if( !sess.getAttribute("type").equals("amministratore") ) {
		%> <h2>Sei un impostore</h2><br>
		<a href="../Logout"><button>LogOut</button></a>
		<%
		return;
	}

	%>
	<center><i><font size="5">Profilo Amministratore</font></i></center><hr>
		
	<font size=4>Data Import/Export</font>
	<%
	
	String action = request.getParameter("action");
	if( action == null ) {
		%> 
		<ul type="circle">
			<li><a href="importexport.jsp?action=export">Esporta dati</a></li>
			<li><a href="importexport.jsp?action=import">Importa dati</a></li>
		</ul>
	<%} else {
		if( action.equals("export") ) {
			if( ImportExport.exportData("export.xml") ) {
				%>
				<font size=3>Dati esportati - <a href="/export.xml">Dowload</a></font>
				<%
			} else {
				%>
				<font size=3>Impossibile esportare i dati</font>
				<%
			}
		} else {
			if( ImportExport.importData("export.xml") ) {
				%>
				<font size=3>Dati importati</font>
				<%
			} else {
				%>
				<font size=3>Impossibile importare i dati</font>
				<%
			}
		}
	} %>
	
	
	
	<p><a href="adminhome.jsp"><button>Indietro</button></a></p>
</body>
</html>