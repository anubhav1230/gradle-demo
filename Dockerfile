# Step 1: Use a Gradle image with Java 21 to build the app
FROM gradle:8.5.0-jdk21 AS build

# Set working directory
WORKDIR /app

# Copy everything needed for the build
COPY . .

# Build the application (creates a fat JAR if using Spring Boot plugin)
RUN ./gradlew clean bootJar --no-daemon

# Step 2: Use a lightweight JDK 21 runtime for the final image
FROM eclipse-temurin:21-jdk-alpine

# Set working directory in the runtime container
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose port (update if your app uses a different port)
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
