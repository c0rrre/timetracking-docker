# Node.js Basisimage
FROM node:20-alpine

# Argument für GitHub Token
ARG GITHUB_TOKEN

# Arbeitsverzeichnis
WORKDIR /app

# Git installieren
RUN apk add --no-cache git

# Privates Repo klonen
RUN git clone https://${GITHUB_TOKEN}@github.com/c0rrre/timetracking.git . && \
    rm -rf .git

# Abhängigkeiten installieren
RUN npm install

# Port öffnen (z. B. Vite)
EXPOSE 5173

# Startbefehl
CMD ["npm", "run", "dev"]
