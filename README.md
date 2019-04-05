Kong declarative examples
=========================

# Simple

Just run the example like this:

```
$ ./run.sh 
Error, please specify a type of example to load (simple, transformer, withkey)
Usage: ./run.sh simple

$ ./run.sh simple
51a27242b26568f9567b8812be8ffeeffb587ea69905f2eccc35f7f3957b1932
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

# Withkey

The second example adds a key in front:

```
$ ./run.sh withkey
85d0a73c1160d4430b7ba0e7f4fac585ce65c0165ad7bae4e4343ceee9209dd5
$ curl -H "apikey:mykey" http://localhost:8000/mocky
{"test": "HelloWorld"}
```

If you pass the wrong key:

```
$ curl -H "apikey:mykey2" http://localhost:8000/mocky
{"message":"Invalid authentication credentials"}
```

# Transformer

The third example is removing the headers 'x-myfield', if you run for ex tshark on docker0 with the simple example, you should see 2 times toto passing by:

```
$ tshark -V -i docker0 | grep toto
Running as user "root" and group "root". This could be dangerous.
Capturing on 'docker0'
```

And then launch the client:

```
$ curl -H 'x-myfield:toto' http://localhost:8000/mocky
```

You should see 2x times toto:

```
$ tshark -V -i docker0 | grep toto
Running as user "root" and group "root". This could be dangerous.
Capturing on 'docker0'
    x-myfield:toto\r\n
    x-myfield: toto\r\n
```

Now stop the simple docker container, and launch the transformer example:

```
$ ./run.sh transformer
5532e30ce257f00e5e35b4bdfd865d4de507b28b5f615245a06dfa89c7ecbb34
```

Repeat the tshark sniffing as before, you should only see one toto passing by.
