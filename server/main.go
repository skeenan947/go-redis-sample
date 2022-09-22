package main

import (
	"context"
	"encoding/json"
	"net/http"
  "os"
  "fmt"

	"github.com/go-redis/redis/v9"
	"github.com/gorilla/mux"
)

type Entry struct {
	Key   string `json:"key,omitempty"`
	Value string `json:"value"`
}

func GetEntriesByKey(
	ctx context.Context,
	rdb *redis.Client,
	key string) Entry {

	val, err := rdb.Get(ctx, key).Result()
	if err != nil {
		val = ""
	}

	return Entry{key, val}
}

func PutEntries(
	ctx context.Context,
	rdb *redis.Client,
	entry *Entry) error {
	return rdb.Set(ctx, entry.Key, entry.Value, 0).Err()
}

func DelEntries(
	ctx context.Context,
	rdb *redis.Client,
	key string) {
	rdb.Del(ctx, key)
}

func HandleEntries(
	w http.ResponseWriter,
	r *http.Request) {

	rdb := redis.NewClient(&redis.Options{
		Addr:     getEnv("REDIS_ADDR", "127.0.0.1:6789"),
		Password: "",
	})

	vars := mux.Vars(r)
	key, _ := vars["key"]

	switch r.Method {
	case http.MethodGet:
    fmt.Printf("GET /entries/%s\n", key)
		entry := GetEntriesByKey(
			r.Context(),
			rdb,
			key)

		response, _ := json.Marshal(entry)
		w.WriteHeader(http.StatusOK)
		w.Header().Set("Content-type", "application/json")
		w.Write(response)

		break
	case http.MethodPut:
		var entry Entry
		err := json.NewDecoder(r.Body).Decode(&entry)
		if err != nil {
			http.Error(w, "Bad request body", http.StatusBadRequest)
      fmt.Printf("Bad request body\n")
			return
		}
		entry.Key = key

    fmt.Printf("PUT /entries/%s: %s\n", key, entry.Value)
		err = PutEntries(
			r.Context(),
			rdb,
			&entry)

		if err == nil {
			response, _ := json.Marshal(entry)
			w.WriteHeader(http.StatusCreated)
			w.Header().Set("Content-type", "application/json")
			w.Write(response)
		} else {
			http.Error(w, "Redis not accessible", http.StatusServiceUnavailable)
      fmt.Printf("Redis not accessible: %s\n", getEnv("REDIS_ADDR", "127.0.0.1:6789"))
		}
		break
	case http.MethodDelete:
		DelEntries(
			r.Context(),
			rdb,
			key)
		break
	default:
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
    fmt.Printf("Method Not Allowed\n")
		break
	}
}

func getEnv(key string, defaultVal string) string {
    if value, exists := os.LookupEnv(key); exists {
	return value
    }

    return defaultVal
}

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/entries/{key}", HandleEntries)
	http.ListenAndServe(":8080", router)
}
