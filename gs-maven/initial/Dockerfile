FROM openjdk:8-jdk-alpine
VOLUME /var/run/docker.sock /var/run/docker.sock
COPY target/gs-maven-0.1.0.jar app.jar
EXPOSE 80 8080
ENTRYPOINT ["java","-jar","/app.jar"]