package tests

import (
	"github.com/fivernote/fivernote/app/db"
	"testing"
	//	. "github.com/fivernote/fivernote/app/lea"
	//	"github.com/fivernote/fivernote/app/service"
	//	"gopkg.in/mgo.v2"
	//	"fmt"
)

func TestDBConnect(t *testing.T) {
	db.Init("mongodb://localhost:27017/leanote", "leanote")
}
