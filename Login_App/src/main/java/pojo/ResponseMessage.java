package pojo;

public class ResponseMessage {
	
	private String loginStatus;
	private int statusCode;
    public String getLoginStatus() {
        return loginStatus;
    }
    public void setLoginStatus(String loginStatus) {
        this.loginStatus = loginStatus;
    }
    public int getStatusCode() {
        return statusCode;
    }
    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }
    @Override
    public String toString() {
        return "ResponseMessage [loginStatus=" + loginStatus + ", statusCode=" + statusCode + "]";
    }
	
	
	
}
