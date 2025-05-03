# Step 1: Use Gradle with JDK 21 for building
FROM gradle:8.5.0-jdk21 AS build

WORKDIR /app

# Copy all project files
COPY . .

# 🔧 Make the Gradle wrapper executable
RUN chmod +x ./gradlew

# Build the Spring Boot JAR
RUN ./gradlew clean bootJar --no-daemon

# Step 2: Lightweight runtime image
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
