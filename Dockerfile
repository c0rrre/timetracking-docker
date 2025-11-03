# === Build-Stage ===
FROM node:20-alpine AS build

# Argument für GitHub Token
ARG GITHUB_TOKEN

# Arbeitsverzeichnis
WORKDIR /app

# Git installieren und Projekt klonen
RUN apk add --no-cache git
RUN git clone https://${GITHUB_TOKEN}@github.com/c0rrre/timetracking.git . && \
    rm -rf .git

# Abhängigkeiten installieren und Build erzeugen
RUN npm ci && npm run build

# === Runtime-Stage ===
FROM nginx:alpine

# Statische Dateien aus dem Build übernehmen
COPY --from=build /app/dist /usr/share/nginx/html

# Nginx-Konfiguration anpassen (optional)
# Falls du z. B. React Router nutzt, damit 404 -> index.html geht:
RUN echo '\
server {\n\
    listen 80;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location / {\n\
        try_files $uri /index.html;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

# Port öffnen
EXPOSE 80

# Container-Start
CMD ["nginx", "-g", "daemon off;"]
