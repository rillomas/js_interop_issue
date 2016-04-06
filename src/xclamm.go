package js_interop_issue

import (
	"fmt"
	"google.golang.org/appengine"
	"google.golang.org/appengine/channel"
	"google.golang.org/appengine/log"
	"net/http"
	"text/template" // using text/template because html/template is slow on huge web pages
	// "html/template"
)

const (
	rootDirectory          string = "web/build/web" // root directory when deploying
	leftTemplateDelimiter  string = "{{{"
	rightTemplateDelimiter string = "}}}"
	indexFileName          string = "index.html"
)

type IndexParam struct {
	ChannelToken string
}

// Create a template with a custom delimiter
// because the default delimiter interferes with polymer's templating
var tmpl *template.Template = template.Must(
	template.New("js_interop_issue").
		Delims(leftTemplateDelimiter, rightTemplateDelimiter).
		ParseFiles(
		fmt.Sprintf("%s/%s", rootDirectory, indexFileName)))

// setup handlers
func init() {
	http.HandleFunc("/", handler)
}

func handler(w http.ResponseWriter, r *http.Request) {
	c := appengine.NewContext(r)
	token, err := channel.Create(c, "testclient")
	if err != nil {
		log.Errorf(c, "Error while creating channel: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	err = tmpl.ExecuteTemplate(w, indexFileName, IndexParam{ChannelToken: token})
	if err != nil {
		log.Errorf(c, "Error while executing template: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
