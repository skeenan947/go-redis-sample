FROM golang:1.16-alpine AS build
WORKDIR /app
COPY go.mod ./
COPY go.sum ./
RUN go mod download
COPY server/main.go ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /server

FROM scratch
EXPOSE 8080
COPY --from=build /server .
CMD ["./server"]
