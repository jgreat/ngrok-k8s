# ngrok

Daily updates of ngrok powered by GitHub Actions.

Docker Image: https://hub.docker.com/repository/docker/jgreat/ngrok


## Example Usage

This example shares your users ngrok.yml with the container and published the web console on http://localhost:4040.

```
docker run -it --rm -v ~/.ngrok2/ngrok.yml:/maps/ngrok/ngrok.yml \
  -p 127.0.0.1:4040:4040 \
  jgreat/ngrok:2.3.35
```

Optional: The `authtoken` value can be provided as an environment variable instead of including it in the ngrok.yml.

```
docker run -it --rm -v ~/.ngrok2/ngrok.yml:/maps/ngrok/ngrok.yml \
  -p 127.0.0.1:4040:4040 \
  -e NGROK_AUTHTOKEN=${NGROK_AUTHTOKEN}
  jgreat/ngrok:2.3.35
```

## Configuration 

Add your AuthToken to `NGROK_AUTHTOKEN` environment variable and share your ngrok config with the container at `/maps/ngrok/ngrok.yml`.

The entrypoint script will merge the the contents of `/maps/ngrok/ngrok.yml` along with `authtoken` and `web_addr: 0.0.0.0:4040` into the default config path for the `ngrok` user.


## Example K8s Usage

This example uses maps the ngrok tunnel with the traefik Ingress included in [k3s](https://k3s.io/)

Helm chart coming soon.

```
apiVersion: v1
kind: Namespace
metadata:
  name: ngrok
---
# service
apiVersion: v1
kind: Service
metadata:
  name: ngrok
  namespace: ngrok
spec:
  selector:
    run: ngrok
  ports:
    - protocol: TCP
      port: 4040
      targetPort: 4040
---
# config map
apiVersion: v1
kind: ConfigMap
metadata:
  name: ngrok
  namespace: ngrok
data:
  ngrok.yml: |
    tunnels:
      test:
        proto: tls
        addr: traefik.kube-system:443
        hostname: test.jgreat.me
---
# secret
apiVersion: v1
kind: Secret
metadata:
  name: ngrok
  namespace: ngrok
type: Opaque
data:
  ngrok-authtoken: <base 64 encoded token here>
---
# deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: ngrok
  name: ngrok
  namespace: ngrok
spec:
  replicas: 1
  selector:
    matchLabels:
      run: ngrok
  template:
    metadata:
      labels:
        run: ngrok
    spec:
      containers:
      - image: jgreat/ngrok:latest
        imagePullPolicy: Always
        name: ngrok
        env:
          - name: NGROK_AUTHTOKEN
            valueFrom:
              secretKeyRef:
                name: ngrok
                key: ngrok-authtoken
        ports:
        - containerPort: 4040
          protocol: TCP
        volumeMounts:
          - name: ngrok-config
            mountPath: /maps/ngrok
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      volumes:
        - name: ngrok-config
          configMap:
            name: ngrok
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
```
