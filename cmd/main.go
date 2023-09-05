package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {
	r := mux.NewRouter()

	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello 👋🏻")
	})

	fmt.Println("Server listening at port 8080")
	http.ListenAndServe(":8080", r)
}
