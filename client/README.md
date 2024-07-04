# URL Shortener

This project is a URL shortener application, consisting of server and client folders to run the client application.

## Requirements

- Node.js (version 18 or higher)
- Go (latest version)
- PostgreSQL

## Setup Instructions

### Client Side

1. Navigate to the `client` folder:

```sh
cd client
```

2. Install dependencies using either Yarn or npm:

```sh
yarn install
# or
npm install
```

3. Start the development server:

```sh
yarn dev
# or
npm run dev
```

### Server Side

1. Navigate to the `server` folder:
   ```sh
   cd server
   ```
2. Copy the sample environment file and configure it:
   ```sh
   cp .env.sample .env
   ```
3. Run the server:
   ```sh
   go run cmd/main.go
   ```

### Additional Information

Make sure PostgreSQL is installed and running, and the database configuration in the .env file is correct.

Feel free to contribute to this project by opening issues or submitting pull requests.
