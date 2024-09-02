package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"

	database "url-shortener/internal/db"
	"url-shortener/internal/utils"
)

func init() {
	// db connection
	database.DbConnection()

	// Snowflake code generator
	utils.CodeGenerator()
}

func main() {
	PORT := os.Getenv("PORT")
	MAIN_APP_URL := os.Getenv("MAIN_APP_URL")

	if PORT == "" {
		PORT = "8000"
	}

	r := chi.NewRouter()
	r.Use(middleware.Logger)

	db := database.GetDBPool()

	r.Use(cors.Handler(cors.Options{
		// AllowedOrigins:   []string{"https://foo.com"}, // Use this to allow specific origin hosts
		AllowedOrigins: []string{MAIN_APP_URL},
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

	r.Post("/url", func(w http.ResponseWriter, r *http.Request) {
		createUrl(w, r, db)
	})

	r.Get("/{code}", func(w http.ResponseWriter, r *http.Request) {
		handleRedirect(w, r, db)
	})

	fmt.Println("Server is running on port", PORT, "🚀🚀🚀")
	http.ListenAndServe(fmt.Sprintf(":%s", PORT), r)
	database.CloseDBPool()
}

type UrlRequest struct {
	LongUrl string `json:"longUrl"`
}

func createUrl(w http.ResponseWriter, r *http.Request, db *pgxpool.Pool) {
	var urlRequest UrlRequest

	err := json.NewDecoder(r.Body).Decode(&urlRequest)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	}

	query := "SELECT code FROM url WHERE long_url = $1"

	row := db.QueryRow(context.Background(), query, urlRequest.LongUrl)

	var decodedCode string

	row.Scan(&decodedCode)

	if decodedCode == "" {
		worker := utils.GetWorker()

		code, err := worker.NextID()

		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		decodedCode = utils.Base64(code)

		query = "INSERT INTO url (long_url, code) VALUES ($1, $2) RETURNING code"

		_, err = db.Exec(context.Background(), query, urlRequest.LongUrl, decodedCode)

		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK) // Explicitly setting the status code to 200
	w.Write([]byte(decodedCode))
}

func handleRedirect(w http.ResponseWriter, r *http.Request, db *pgxpool.Pool) {
	code := chi.URLParam(r, "code")

	query := "SELECT long_url FROM url WHERE code = $1"
	var longUrl string
	err := db.QueryRow(context.Background(), query, code).Scan(&longUrl)

	if err != nil {
		http.Error(w, "URL not found", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK) // Explicitly setting the status code to 200
	w.Write([]byte(longUrl))
}
