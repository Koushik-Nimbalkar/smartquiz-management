FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src
COPY .mvn ./.mvn
COPY mvnw .
COPY mvnw.cmd .

RUN mvn -DskipTests clean package

FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat

# Deploy app as root context so users open one simple URL.
COPY --from=build /app/target/quizz-management-1.0-SNAPSHOT.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
