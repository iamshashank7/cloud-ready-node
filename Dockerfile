# single-stage Dockerfile for Node.js (no multistage)
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy package files first for caching layers
COPY package.json package-lock.json* ./

# Install dependencies (production-ready; keeps node_modules in image)
RUN npm install --production

# Copy source code
COPY src/ ./src

# Environment
ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

# Healthcheck (uses wget; included in alpine by default as busybox wget)
HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- --timeout=2 http://localhost:3000/health || exit 1

CMD ["node", "src/index.js"]

