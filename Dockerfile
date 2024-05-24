# Stage 1: Build the Go binary
FROM golang:alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN cd examples/base && GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o base

# Stage 2: Create a minimal runtime image
FROM alpine:latest

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/examples/base/base .

# Ensure the binary has execute permissions
RUN chmod +x base

# Expose the necessary port (change if needed)
EXPOSE 8090

# Command to run the executable
CMD ["./base", "serve"]
