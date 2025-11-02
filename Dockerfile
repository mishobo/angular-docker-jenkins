# ------------------------
# Stage 1: Build Angular App
# ------------------------
FROM node:20 AS builder

WORKDIR /app

# Copy dependency files first (for caching)
COPY package*.json ./

# Use npm ci for clean, reproducible installs
RUN npm ci

# Copy the rest of the app
COPY . .

# Build the app (can switch mode via ARG)
ARG BUILD_ENV=production
RUN if [ "$BUILD_ENV" = "production" ]; then \
      npm run build -- --configuration production; \
    else \
      npm run build; \
    fi

# ------------------------
# Stage 2: Development (ng serve)
# ------------------------
FROM node:20 AS dev

WORKDIR /app

COPY package*.json ./
RUN npm ci
COPY . .

# Expose Angular dev server port
EXPOSE 4200

# Start Angular in dev mode
CMD ["npm", "run", "start", "--", "--host", "0.0.0.0"]

# ------------------------
# Stage 3: Production (Nginx)
# ------------------------
FROM nginx:alpine AS prod

# Copy build output from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
