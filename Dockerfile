# Stage 1: Build the WAR file
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the final image
FROM tomcat:10.1-jdk21-temurin
COPY --from=build /app/target/docaid.war ${CATALINA_HOME}/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
