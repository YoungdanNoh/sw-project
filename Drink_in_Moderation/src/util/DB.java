package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DB {
	public static Connection getConnection() {
		try {
			String dbURL = "jdbc:mysql://127.0.0.1:3306/Music_application?serverTimezone=UTC";
			String dbID = "ID";
			String dbPassword = "PASSWORD";
			Class.forName("com.mysql.jdbc.Driver");
			return DriverManager.getConnection(dbURL,dbID,dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
