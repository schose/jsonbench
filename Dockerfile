FROM alpine:latest  

WORKDIR /app/
COPY json ./
CMD ["./json"]  
