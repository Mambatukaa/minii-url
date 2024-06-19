package db

import (
	"context"
	"fmt"
	"os"
	"sync"

	"github.com/jackc/pgx/v5/pgxpool"
)

var (
	dbpool *pgxpool.Pool
	dbmu   sync.Mutex
)

func DbConnection() {
	DB_HOST := os.Getenv("DB_HOST")
	DB_USER := os.Getenv("DB_USER")
	DB_PASSWORD := os.Getenv("DB_PASSWORD")
	DATABASE := os.Getenv("DATABASE")

	fmt.Println(DB_HOST)
	fmt.Println(DB_USER)
	fmt.Println(DB_PASSWORD)
	fmt.Println(DATABASE)

	ctx := context.Background()

	if DATABASE == "" {
		fmt.Fprintf(os.Stderr, "Make sure your DB connection url okay? URL: %v", DATABASE)
		os.Exit(1)
	}

	var connectionString string = fmt.Sprintf("host=%s user=%s password=%s dbname=%s sslmode=require", DB_HOST, DB_USER, DB_PASSWORD, DATABASE)

	// connect PostreSQL
	var err error
	dbpool, err = pgxpool.New(ctx, connectionString)

	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to connect to database: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("DB connection successfully. 🚀")
}

func GetDBPool() *pgxpool.Pool {
	dbmu.Lock()
	defer dbmu.Unlock()
	return dbpool
}

func CloseDBPool() {
	dbmu.Lock()
	defer dbmu.Unlock()
	if dbpool != nil {
		dbpool.Close()
	}
}
