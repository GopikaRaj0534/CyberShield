package com.cybershield.filter;

import com.cybershield.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Protects citizen, admin, and investigator portal pages. Unauthenticated
 * users are redirected to login. Non-admin users cannot access /admin/*
 * paths, and only investigation officers can access /investigator/* paths.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/user/*", "/admin/*", "/investigator/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        String ctx = req.getContextPath();
        String path = req.getServletPath();

        if (user == null) {
            res.sendRedirect(ctx + "/login.jsp");
            return;
        }

        if (path != null && path.startsWith("/admin") && !"ADMIN".equals(user.getRole())) {
            res.sendRedirect(ctx + ("INVESTIGATOR".equals(user.getRole()) ? "/investigator/dashboard.jsp" : "/user/dashboard.jsp"));
            return;
        }

        if (path != null && path.startsWith("/investigator") && !"INVESTIGATOR".equals(user.getRole())) {
            res.sendRedirect(ctx + ("ADMIN".equals(user.getRole()) ? "/admin/dashboard.jsp" : "/user/dashboard.jsp"));
            return;
        }

        chain.doFilter(request, response);
    }
}
