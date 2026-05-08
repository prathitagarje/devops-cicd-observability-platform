# ---------- Stage 1: Build ----------
FROM node:18-alpine AS builder

WORKDIR /app

# Copy only package files first (better caching)
COPY package*.json ./

# Install all dependencies (including dev if needed)
RUN npm install

# Copy application source
COPY . .


# ---------- Stage 2: Production ----------
FROM node:18-alpine

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app ./

# Install only production dependencies (cleaner + smaller)
RUN npm prune --production

# Expose app port
EXPOSE 3000

# Run app
CMD ["node", "index.js"]