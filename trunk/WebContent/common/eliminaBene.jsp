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
	if( sess == null || (!sess.getAttribute("type").equals("addetto amministrativo") &&
			!sess.getAttribute("type").equals("amministratore"))) {
		%><p><i><font size="4" color="#FF8000">Autenticazione fallita</font></i></p>
		<p>
		<a href="login.html"><button>Indietro</button></a>
		</p><%
		return;
	}
	
	Connection conn = ConnectionManager.getConnection();
	try {
		conn.setAutoCommit(false);
		PreparedStatement pst = conn.prepareStatement("DELETE FROM ubicazione WHERE bene=?");
		pst.setInt(1, Integer.parseInt( request.getParameter("idBene") ));
		pst.executeUpdate();
		
		PreparedStatement pst2 = conn.prepareStatement("DELETE FROM dotazione WHERE bene=?");
		pst2.setInt(1, Integer.parseInt( request.getParameter("idBene") ));
		pst2.executeUpdate();
		
		PreparedStatement pst3 = conn.prepareStatement("DELETE FROM assegnazione WHERE bene=?");
		pst3.setInt(1, Integer.parseInt( request.getParameter("idBene") ));
		pst3.executeUpdate();
		
		PreparedStatement pst4 = conn.prepareStatement("DELETE FROM finanziamento WHERE bene=?");
		pst4.setInt(1, Integer.parseInt( request.getParameter("idBene") ));
		pst4.executeUpdate();
		
		PreparedStatement st = conn.prepareStatement(
				"DELETE FROM bene WHERE numero_inventario_generico=?");
		st.setInt(1, Integer.parseInt( request.getParameter("idBene") ));
		st.executeUpdate();
		%>
			<p><i><font size="4" color="#FF8000">Bene Eliminato</font></i></p>
			Bene Eliminato: <%= request.getParameter("idBene") %>
		<%
		conn.commit();
		conn.setAutoCommit(true);
	}
	catch ( Exception e ) {
		conn.rollback();
		conn.setAutoCommit(true);
		%>
			<p><i><font size="4" color="#FF8000">Errore</font></i></p>
			Errore nell'eliminazione del bene <%= request.getParameter("idBene") %>
		<%		
	}
%>
<p>
<a href="visualizzaBeni.jsp"><button>Indietro</button></a>
</p>
</body>
</html>