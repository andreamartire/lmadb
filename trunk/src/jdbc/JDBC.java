package jdbc;

public class JDBC {
	/** stringa di connessione per postgresql */
	public static final String postgresUrl = "jdbc:postgresql://localhost/postgres";
	/** stringa di connessione per oracle */
	public static final String oracleUrl = "jdbc:oracle:thin:@localhost:1521:xe";
	
	/** driver jdbc per oracle */
	public static final String oracleDriver = "oracle.jdbc.driver.OracleDriver";
	/** driver jdbc per postgreSQL */
	public static final String postgresDriver = "org.postgresql.Driver";
}
