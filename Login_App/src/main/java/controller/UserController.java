package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;

import pojo.ResponseMessage;
import pojo.User;
import util.Constants;
import util.DbManager;

@WebServlet("/users")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    static final Logger logger = LoggerFactory.getLogger(UserController.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        Connection con = null;
        PrintWriter out = null;
        Gson jsonObj = new Gson();
        String jsonResponse = null;
        DbManager db = new DbManager();
        ResponseMessage responseMsg = new ResponseMessage();

        response.setContentType("application/json");
        String requestedUserName = request.getParameter(Constants.REQUEST_NAME);
        User user = new User();
        out = response.getWriter();

        con = db.getconnection();
        PreparedStatement prepStmt = null;
        ResultSet result = null;
        HttpSession session = request.getSession(false);

        if (requestedUserName != null) {
            try {
                prepStmt = con.prepareStatement("Select * from users where userName=?");
                prepStmt.setString(1, requestedUserName);
                result = prepStmt.executeQuery();

                while (result.next()) {
                    user.setUserName(result.getString("userName"));
                    user.setPassword(result.getString("password"));
                }
                if (user.getUserName() == null && user.getPassword() == null) {
                    responseMsg.setLoginStatus(Constants.NO_CONTENT);
                    responseMsg.setStatusCode(response.SC_NO_CONTENT);
                    jsonResponse = jsonObj.toJson(responseMsg);
                    out.println(jsonResponse);
                    logger.info("User Not Exist : [{}]", requestedUserName);
                } else {
                    jsonResponse = jsonObj.toJson(user);
                    out.println(jsonResponse);
                }
            } catch (SQLException e) {
                logger.error("DataBase Access Error");
            }
        } else {
            List<User> userList = new ArrayList<User>();

            try {
                prepStmt = con.prepareStatement("Select * from users");
                result = prepStmt.executeQuery();
                while (result.next()) {
                    User objUser = new User();
                    objUser.setUserName(result.getString(Constants.DB_COL_USERNAME));
                    objUser.setPassword(result.getString(Constants.DB_COL_PASSWORD));
                    userList.add(objUser);
                }
                jsonResponse = jsonObj.toJson(userList);
                out.println(jsonResponse);
            } catch (SQLException e) {
                logger.error("DataBase Access Error");
            }
        }
    }
}
