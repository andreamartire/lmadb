<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jdbc.JDBC" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%! String username, password, user, email, data_reg, tipologia, cf, nome, cognome; %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Profilo</title>
</head>
<body>
	<%  
		try {
			HttpSession sess = request.getSession(false);
			
			Class.forName( JDBC.oracleDriver );
			Connection connection;
			connection = DriverManager.getConnection( JDBC.oracleUrl, "basididati", "basididati" );
			PreparedStatement st = connection.prepareStatement("SELECT * FROM Account A, Personale P"+ 
					" where (A.username=? AND A.personale=P.matricola)");
			user = (String) sess.getAttribute("name");
			st.setString(1,user);
			ResultSet res = st.executeQuery();
			while ( res.next() ) {
				username = res.getString(1);
				password = res.getString(2);
				email = res.getString(3);
				data_reg = res.getString(4);
				tipologia = res.getString(5);
				cf = res.getString(8);
				nome = res.getString(9);
				cognome = res.getString(10);
			}
			connection.close();
		}
		catch ( Exception e ) {
			
		}
	%>
	Dati Utente<br><br>
	
	Username: <%= username %><br>
	Email: <%= email %><br>
	Data Registrazione: <%= data_reg %><br>
	Tipologia Utente: <%= tipologia %><br>
	Codice Fiscale: <%= cf %><br>
	Nome: <%= nome %><br>
	Cognome: <%= cognome %><br><br>
	
	Cambio Password<br><br>
	
	<form name="form_change_pass" method=post action="" onsubmit="return check(this)" >
		Vecchia Password: <input type="password" name="vecchiaPassword"></input><br>
		Nuova Password: <input type="password" name="nuovaPassword"></input><br>
		Conferma Nuova Password: <input type="password" name="checkNuovaPassword"></input><br>
		<input type="submit" name="submit" value="Cambia Password" ><br><br>
	</form>
	<button value="Back" action="http://localhost:8081/lamdb/addettohome.jsp"></button>
	
</body>

<script language="Javascript">
	function check( form ) {
		if(form.nuovaPassword.value != form.checkNuovaPassword.value ){
			window.alert("La Nuova Password non e' stata inserita correttamente");
			return false;
		}
		return true;
	}
</script>
</html>