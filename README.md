# ngrok-k8s
ngrok build with k8s chart

### Environment Variables

* `NGROK_AUTHTOKEN` - Ngrok Authtoken (provide with a K8S secret)

### Configuration



* 



## Docker Image

Automatic build with GitHub Actions.
Should update daily with latest ngrok version.

### Trigger test job

```plain
curl -H "Accept: application/vnd.github.everest-preview+json" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    --request POST \
    --data '{"event_type": "build"}' \
    https://api.github.com/repos/jgreat/ngrok-k8s/dispatches
```

I will need a to add an entrypoint script to process the authtoken as a env var
And copy a /tmp/config.yml to /home/ngrok/.ngrok2/ngrok.yml
Set command ngrok start --all
