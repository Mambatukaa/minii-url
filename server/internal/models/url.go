package dbModels

type Url struct {
	ID      int    `json:"id"`
	Code    string `json:"code"`
	LongUrl string `json:"longUrl"`
}

type LongUrl struct {
	LongUrl string `json:"longUrl"`
}
