FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
COPY .env .

ARG BACKEND_USERS_URL
ARG BACKEND_PRODUCTS_URL

RUN echo "BACKEND_USERS_URL=${BACKEND_USERS_URL}" > .env && \
    echo "BACKEND_PRODUCTS_URL=${BACKEND_PRODUCTS_URL}" >> .env

RUN mvn compile exec:java

FROM nginx:alpine
COPY --from=builder /app/output /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]