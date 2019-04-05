Kong declarative examples
=========================

Just run the example like this:

```
$ docker run -d -e KONG_DATABASE=off -e KONG_DECLARATIVE_CONFIG=/etc/kong/kong.yml -v $PWD:/etc/kong -p8000:8000 zoobab/kong:1.1.1-openshift
```

Then hit the ```/``` endpoint with curl:

```
$ curl http://localhost:8000/
{"message":"no Route matched with those values"}
```

Then hit ```/mocky``` :

```
$ curl http://localhost:8000/mocky
{"test": "HelloWorld"}
```
