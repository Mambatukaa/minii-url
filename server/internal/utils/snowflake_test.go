package utils

import (
	"fmt"
	"sync"
	"testing"
)

var wg sync.WaitGroup // Remove the unused variable declaration

// Rename the main function to a different name
func TestSnowflake(t *testing.T) {
	w := NewWorker(5, 5)

	ch := make(chan uint64, 10000)
	count := 10000
	wg.Add(count)
	defer close(ch)
	// Concurrently count goroutines for snowFlake ID generation
	for i := 0; i < count; i++ {
		go func() {
			defer wg.Done()
			id, _ := w.NextID()
			ch <- id
		}()
	}
	wg.Wait()
	m := make(map[uint64]int)
	for i := 0; i < count; i++ {
		id := <-ch
		// If there is a key with id in the map, it means that the generated snowflake ID is duplicated
		_, ok := m[id]
		if ok {
			fmt.Printf("repeat id %d\n", id)
			return
		}
		// store id as key in map
		m[id] = i
	}
	// successfully generated snowflake ID
	fmt.Println("All", len(m), "snowflake ID Get successed!")

}

func TestSnowflakeWorker(t *testing.T) {
	t.Setenv("MACHINE_ID", "1")
	t.Setenv("DATA_CENTER_ID", "1")

	id, err := CodeGenerator()

	if err != nil {
		t.Errorf("Error: %v", err)
	}

	// successfully generated snowflake ID
	fmt.Println("id", id, "snowflake initial ID Get successed!")

}
