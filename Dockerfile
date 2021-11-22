FROM maven:3.6.0-jdk-11-slim as build
COPY src /app/src
COPY pom.xml /app
RUN mvn -f /app/pom.xml clean package

FROM tomcat
COPY --from=build /app/target/hello-world-war*.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
