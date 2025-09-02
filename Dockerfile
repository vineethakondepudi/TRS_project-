FROM tomcat:9.0
COPY src/AdminLogin.html /usr/local/tomcat/webapps/ROOT/AdminLogin.html
EXPOSE 8080
