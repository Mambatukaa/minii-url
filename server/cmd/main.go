package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"

	"url-shortener/internal/db"
	"url-shortener/internal/utils"
)

func init() {
	err := godotenv.Load()

	if err != nil {
		log.Fatal("Error loading .env file")
	}

	// db connection
	db.DbConnection()
}

func main() {
	PORT := os.Getenv("PORT")

	r := chi.NewRouter()
	r.Use(middleware.Logger)

	r.Use(cors.Handler(cors.Options{
		// AllowedOrigins:   []string{"https://foo.com"}, // Use this to allow specific origin hosts
		AllowedOrigins: []string{"https://*", "http://*"},
		// AllowOriginFunc:  func(r *http.Request, origin string) bool { return true },
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: false,
		MaxAge:           300, // Maximum value not ignored by any of major browsers
	}))

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK) // Explicitly setting the status code to 200
		w.Write([]byte("welcome"))
	})

	r.Post("/url", createUrl)

	http.ListenAndServe(fmt.Sprintf(":%s", PORT), r)
	db.CloseDBPool()
}

type UrlRequest struct {
	LongUrl string `json:"longUrl"`
}

func createUrl(w http.ResponseWriter, r *http.Request) {
	print("creating url.....................................")
	db := db.GetDBPool()

	var urlRequest UrlRequest

	err := json.NewDecoder(r.Body).Decode(&urlRequest)

	fmt.Println("--------------------", urlRequest)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	query := "SELECT code FROM url WHERE long_url = $1"

	row := db.QueryRow(context.Background(), query, urlRequest.LongUrl)

	var code string

	err = row.Scan(&code)

	if err != nil {
		query = "INSERT INTO url (long_url, code) VALUES ($1, $2) RETURNING code"

		code, err = utils.CodeGenerator(urlRequest.LongUrl)

		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		err = db.QueryRow(context.Background(), query, urlRequest.LongUrl, code).Scan(&code)

		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK) // Explicitly setting the status code to 200
	w.Write([]byte(code))
}

func CodeGenerator(s string) {
	panic("unimplemented")
}
