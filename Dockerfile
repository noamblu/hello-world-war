FROM maven:3.8.3-openjdk as build
COPY src /app/src
COPY pom.xml /app
RUN mvn -f /app/pom.xml clean package

FROM tomcat
COPY --from=build /app/target/hello-world-war*.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
