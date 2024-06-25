package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/jackc/pgx/v5"

	"github.com/joho/godotenv"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"

	"url-shortener/internal/db"
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

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
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
	db := db.GetDBPool()

	fmt.Println("Creating short URL")

	var urlRequest UrlRequest

	err := json.NewDecoder(r.Body).Decode(&urlRequest)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Println("Long URL: ", urlRequest.LongUrl)

	query := "SELECT id FROM url"

	var rows pgx.Rows

	rows, err = db.Query(context.Background(), query)

	fmt.Println("URL: ", rows)

	// defer rows.Close()

	// for rows.Next() {
	// 	var id int
	// 	err = rows.Scan(&id)
	// 	if err != nil {
	// 		fmt.Println("Error: ", err)
	// 	}
	// 	fmt.Println("ID: ", id)

	// }

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// w.Header().Set("Content-Type", "application/json")

}
