package pojo;
/*
 * This class is for mapping username and password
 * with database
 */
public class User {
    
    String userName;
    String password;
    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    @Override
    public String toString() {
        return "Users [userName=" + userName + ", password=" + password + "]";
    }
    
}
