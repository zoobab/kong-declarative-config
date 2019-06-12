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

Or with ```docker run```:

```
$ docker run -d -e KONG_DATABASE=off -e KONG_DECLARATIVE_CONFIG=/etc/kong/kong-simple.yml -v $PWD:/etc/kong -p8000:8000 zoobab/kong:1.1.1-openshift
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

# Validator

Refer to the other project to see how to validate your kong.yml: https://github.com/zoobab/kong-validator

# Monitor that you deployed the right version

Run the monitoring example:

```
$ ./run.sh monitoring
8565deec2a90eb6c0246b15e31031a4d9835ae1700bdca1a44fc342475a47718
```

You should be able to curl the ```/version```:

```
$ curl http://localhost:8000/version
{"message":"version-abcde"}
```

In ```kong-monitoring.yml```, I have added an endpoint that is intercepted
before going to an endpoint which does not exists (http://localhost). This
```/version``` endpoint just returns a message with string
```"version-abcde"```:

```
services:
- name: version
  url: http://localhost
  routes:
  - name: version
    paths:
    - /version
- name: mocky24
  url: http://www.mocky.io/v2/5ca725833400002c4876b363
  routes:
  - name: mocky24
    paths:
    - /mocky24

plugins:
- name: request-termination
  service: version
  config:
    status_code: 200
    message: "version-abcde"
```

You can template that yaml with sed, j2cli, envsubst or your prefered
templating tool to change that version string, for example with ```j2cli```:

```
$ pip install j2cli==0.3.8
$ export MYVERSION="1234e"
$ j2 kong-monitoring.yml.j2 -o kong-monitoring.yml
$ ./run.sh monitoring
$ sleep 5
$ curl -s http://localhost:8000/version | grep "$MYVERSION"
$ echo $?
```

# Run Kong in Kubernetes (Openshift)

Just run ```./k8s.sh``` which does the following:

```
$ kubectl create configmap kongconfig --from-file=conf.d
$ kubectl apply -f ./pod.yaml
$ kubectl apply -f ./svc.yaml
```

You should get a service running:

```
$ kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kong         ClusterIP   10.152.183.48   <none>        8000/TCP   10m
kubernetes   ClusterIP   10.152.183.1    <none>        443/TCP    123d
```

Try to curl the IP address:

```
$ curl http://10.152.183.48:8000/
{"message":"no Route matched with those values"}
```

And try to hit ```/mocky```:

```
$ curl http://10.152.183.48:8000/mocky
{"test": "HelloWorld"}
```
