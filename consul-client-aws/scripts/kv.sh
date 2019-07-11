#!/usr/bin/env bash

set -x

HOST=$(hostname)
# API add value
curl -s \
    --request PUT \
    --data '<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx from '$HOST'!</h1>
</body>
</html>' \
    http://127.0.0.1:8500/v1/kv/$HOST/nginx

set +x




   
