FROM openjdk:8-jdk-alpine
VOLUME /tmp
COPY gs-maven-0.1.0.jar app.jar
EXPOSE 80 8080
ENTRYPOINT ["java","-jar","/app.jar"]