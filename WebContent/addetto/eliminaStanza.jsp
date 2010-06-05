<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="util.ConnectionManager"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>

<%
	HttpSession sess = request.getSession(false);
	if( sess == null || !sess.getAttribute("type").equals("addetto amministrativo") ) {
		%><p><i><font size="4" color="#FF8000">Autenticazione fallita</font></i></p>
		<p>
		<a href="login.html"><button>Indietro</button></a>
		</p><%
		return;
	}
	
	Connection conn = ConnectionManager.getConnection();
	try {
		conn.setAutoCommit(false);
		PreparedStatement st1 = conn.prepareStatement(
			"DELETE FROM postazione WHERE stanza=?");
		st1.setString(1,request.getParameter("idStanza"));
		st1.executeUpdate();
		
		PreparedStatement st2 = conn.prepareStatement(
			"DELETE FROM ubicazione WHERE stanza=?");
		st2.setString(1,request.getParameter("idStanza"));
		st2.executeUpdate();
		
		PreparedStatement st = conn.prepareStatement(
				"DELETE FROM stanza WHERE codice=?");
		st.setString(1,request.getParameter("idStanza"));
		st.executeUpdate();
		%>
			<p><i><font size="4" color="#FF8000">Stanza Eliminata</font></i></p>
			Stanza Eliminata: <%= request.getParameter("idStanza") %>
			
		<%
		conn.commit();
	}
	catch ( Exception e ) {
		conn.rollback();
		conn.setAutoCommit(true);
		%>
			<p><i><font size="4" color="#FF8000">Errore</font></i></p>
			Errore nell'eliminazione della stanza
		<%		
	}
%>
<p>
<a href="gestioneStanze.jsp"><button>Indietro</button></a>
</p>
</body>
</html>