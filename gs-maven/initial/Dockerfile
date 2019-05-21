FROM openjdk:8-jdk-alpine
VOLUME /tmp
COPY target/gs-maven-0.1.0.jar app.jar
EXPOSE 80 8080
CMD ["nohup","java","-jar","/app.jar","&"]