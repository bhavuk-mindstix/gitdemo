package util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/*
 * Class to create DataBase Connection
 */
public class DbManager {
	
	static final Logger logger = LoggerFactory.getLogger(DbManager.class);
    public static Connection con = null;
    public String dbDriver;
    public String dbHost;
    public String dbName;
    public String dbUser;
    public String dbPwd;
    public String dbHostUrl;
    /*
     * This method creates and return Connection object
     */
    public Connection getconnection() {
       
    	Properties property = new Properties();
        InputStream input = null;
        
        try {
            input = DbManager.class.getClassLoader().getResourceAsStream("dbconfig.properties");
            property.load(input);
            
            dbDriver = property.getProperty("DB_DRIVER");
            dbHost = property.getProperty("DB_HOST");
            dbName = property.getProperty("USERS_DB_NAME");
            dbUser = property.getProperty("DB_USER");
            dbPwd = property.getProperty("DB_PWD");
            dbHostUrl = dbHost+dbName;
            
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(dbHostUrl, dbUser, dbPwd);
            return con;
        } catch (Exception e) {
                logger.info("DataBase Connection Error");
                return null;
        } 			
}
    }
