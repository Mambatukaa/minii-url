FROM golang:1.22-rc-alpine
# alpine is not necessary. it can be 1.20 or other tags
# set a working directory to function from. It doesn't have to be /app
WORKDIR /miniiurl
# technically you dont need to copy all the files. ONLY the go stuff. But I was being lazy
COPY . .
# this downloads all the dependencies that you have in the code
RUN go get
# or
# RUN go mod download
# create the binary/executable. The name does not have to bin e.g. you can name it mylittlebunny
RUN go build -o bin .

# tell docker which binary is your application
ENTRYPOINT [ "/miniiurl/bin" ]