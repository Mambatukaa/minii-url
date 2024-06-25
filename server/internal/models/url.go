package dbModels

type Url struct {
	ID       int    `json:"id"`
	ShortUrl string `json:"shortUrl"`
	LongUrl  string `json:"longUrl"`
}

type LongUrl struct {
	LongUrl string `json:"longUrl"`
}
