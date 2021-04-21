link "example_link.cl"

| This is an example program |
function<int> main()
->
	start:
	ptr<int> a.
	goto start.
	stdout put "Hello World".
	return 0.
<-
