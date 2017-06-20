package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    static final Logger logger = LoggerFactory.getLogger(LoginController.class);

    @SuppressWarnings("static-access")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        DbManager db = new DbManager();
        Connection con = null;
        ResponseMessage responseMessage = new ResponseMessage();
        Gson jsonResponse = new Gson();
        Gson gsonParse = new Gson();
        StringBuilder jsonRequest = new StringBuilder();
        String s;
        PrintWriter out = response.getWriter();

        response.setContentType("application/json");
        while ((s = request.getReader().readLine()) != null) {
            jsonRequest.append(s);
        }

        User user = (User) gsonParse.fromJson(jsonRequest.toString(), User.class);
        String userName = user.getUserName();
        String password = user.getPassword();
        String userNameInDb = null;
        String passwordInDb = null;
        logger.info("Requested User : [{}]", userName);

        try {
            con = db.getconnection();
            PreparedStatement prepStmt = con.prepareStatement("select * from users where userName = ?");
            prepStmt.setString(1, userName);
            ResultSet result = prepStmt.executeQuery();

            while (result.next()) {

                userNameInDb = result.getString("userName");
                passwordInDb = result.getString("password");

            }
            if (userNameInDb.equals(userName) && passwordInDb.equals(password)) {
                responseMessage.setLoginStatus(Constants.LOGIN_PASS);
                responseMessage.setStatusCode(response.SC_OK);
                String jsonInString = jsonResponse.toJson(responseMessage);

                HttpSession session = request.getSession(true);
                session.setAttribute("userName", userName);

                out.println(jsonInString);
            } else {
                responseMessage.setLoginStatus(Constants.UNAUTHORISED);
                responseMessage.setStatusCode(response.SC_UNAUTHORIZED);
                String jsonInString = jsonResponse.toJson(responseMessage);
                out.println(jsonInString);
                logger.info("Wrong User Name or Password : [{}]", response.SC_UNAUTHORIZED);
            }
            out.close();

        } catch (SQLException e) {
            out.close();
            logger.error("There is some problem while fething data from DateBase");
        }

    }
}
