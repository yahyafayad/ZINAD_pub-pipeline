# Step 1: Build Stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Runtime Stage
FROM adoptopenjdk:17-jdk-hotspot
WORKDIR /app
# Copy the built JAR and rename to app.jar for consistency
COPY --from=build /app/target/zinad-app-*.jar app.jar

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
