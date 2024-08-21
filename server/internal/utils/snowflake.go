package utils

import (
	"errors"
	"fmt"
	"os"
	"strconv"
	"sync"
	"time"
)

/*
	! Snowflake-like ID generator
		1 bit not use (sign bit), (0 - positive, 1 - negative)
		41 bits for timestamp ( milliseconds ),
		5 bits for data center ID,
		5 bits for worker ID,
		12 bits for sequence number
		Total 64 bits

		1 41 5 5 12
*/

// Basic Constants
const (
	workerIDBits     = uint64(5) // 5bit workerID out of 10bit worker machine ID
	dataCenterIDBits = uint64(5) // 5bit workerID out of 10bit worker dataCenterID
	sequenceBits     = uint64(12)

	maxWorkerID     = int64(-1) ^ (int64(-1) << workerIDBits) // The maximum value of the node ID used to prevent overflow
	maxDataCenterID = int64(-1) ^ (int64(-1) << dataCenterIDBits)
	maxSequence     = int64(-1) ^ (int64(-1) << sequenceBits)

	timeLeft = uint8(22) // timeLeft = workerIDBits + sequenceBits // Timestamp offset left
	dataLeft = uint8(17) // dataLeft = dataCenterIDBits + sequenceBits
	workLeft = uint8(12) // workLeft = sequenceBits // Node IDx offset to the left

	// twepoch is the time of the Twepoch (2022-04-06 06:20:40)
	// The time of the Twepoch is the starting point of the snowflake algorithm
	// The snowflake algorithm uses a 64-bit integer to represent a unique ID
	twepoch = int64(1659674040000) // constant timestamp (milliseconds)
)

type Worker struct {
	mu           sync.Mutex
	LastStamp    int64 // Record the timestamp of the last ID
	WorkerID     int64 // the ID of the node
	DataCenterID int64 // The data center ID of the node
	Sequence     int64 // ID sequence numbers that have been generated in the current millisecond (accumulated from 0) A maximum of 4096 IDs are generated within 1 millisecond
}

// In distributed cases, we should assign each machine an independent id through an external configuration file or other means
func NewWorker(workerID, dataCenterID int64) *Worker {
	return &Worker{
		WorkerID:     workerID,
		LastStamp:    0,
		Sequence:     0,
		DataCenterID: dataCenterID,
	}
}

func (w *Worker) getMilliSeconds() int64 {
	return time.Now().UnixNano() / 1e6
}

func (w *Worker) NextID() (uint64, error) {
	w.mu.Lock()
	defer w.mu.Unlock()

	return w.nextID()
}

func (w *Worker) nextID() (uint64, error) {
	timeStamp := w.getMilliSeconds()
	if timeStamp < w.LastStamp {
		return 0, errors.New("time is moving backwards,waiting until")
	}

	if w.LastStamp == timeStamp {

		w.Sequence = (w.Sequence + 1) & maxSequence

		if w.Sequence == 0 {
			for timeStamp <= w.LastStamp {
				timeStamp = w.getMilliSeconds()
			}
		}
	} else {
		w.Sequence = 0
	}

	w.LastStamp = timeStamp
	id := ((timeStamp - twepoch) << timeLeft) |
		(w.DataCenterID << dataLeft) |
		(w.WorkerID << workLeft) |
		w.Sequence

	return uint64(id), nil
}

var (
	worker *Worker
)

// Generate a code for the short URL
func CodeGenerator() (string, error) {
	MACHINE_ID := os.Getenv("MACHINE_ID")
	DATA_CENTER_ID := os.Getenv("DATA_CENTER_ID")

	if MACHINE_ID == "" || DATA_CENTER_ID == "" {
		fmt.Fprintf(os.Stderr, "MACHINE_ID or DATA_CENTER_ID is not set to start snowflake worker\n")
		os.Exit(1)
	}

	// Code generator function
	worker := NewWorker(5, 5)

	id, err := worker.NextID()

	if err != nil {
		return "", err
	}

	fmt.Println("Snowflake UNIQUE ID GENERATOR is connected. 🟢 Initial ID:", Base64(id))

	return Base64(id), nil
}

func Base64(id uint64) string {
	return strconv.FormatUint(id, 36)
}

func GetWorker() *Worker {
	return worker
}
