package filter;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;

import pojo.ResponseMessage;

@WebFilter(urlPatterns = "/users")
public class LoginFilter implements Filter {

    static final Logger logger = LoggerFactory.getLogger(LoginFilter.class);

    public void destroy() {
    }

    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        Gson jsonObj = new Gson();
        ResponseMessage jsonResponse = null;
        PrintWriter out = response.getWriter();
        if (request.getSession().getAttribute("userName") != null) {
            chain.doFilter(servletRequest, servletResponse);
        } else {
            jsonResponse.setLoginStatus("Session Not Found");
            jsonResponse.setStatusCode(response.SC_NOT_FOUND);
            out.println(jsonObj.toJson(jsonResponse));
        }
    }

    public void init(FilterConfig fConfig) throws ServletException {
    }

}
