#!/bin/bash
SSL="false"
if [ "$SECRET_NAME" ]; then
    SSL="true"
fi
json=$(jq -n -c -M --arg s "$DOMAINS" "\$s|split(\" \") as \$array | \$array|map({name:.|split(\":\")[0],target:.|split(\":\")[1]}) | {endpoints:.,ssl_enabled:${SSL}}")
cat > /reverse-proxy-deployment.yml << EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: reverse-proxy
  labels:
    name: reverse-proxy-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      name: reverse-proxy
  strategy:
    rollingUpdate:
      maxUnavailable: 0
  minReadySeconds: 15
  template:
    metadata:
      name: reverse-proxy
      labels:
        name: reverse-proxy
    spec:
      containers:
      - name: nginx
        image: xabufr/nginx:latest
        resources:
          requests:
            memory: "16Mi"
        ports:
        - containerPort: 80
        - containerPort: 443
        env:
        - name: tiller_json
          value: "$(echo "$json"|sed 's/"/\\"/g')"
EOF
if [ "$SECRET_NAME" ]; then
cat >> /reverse-proxy-deployment.yml << EOF
        volumeMounts:
        - name: certs
          mountPath: /certs
          readOnly: true
      volumes:
        - name: certs
          secret:
            secretName: ${SECRET_NAME}
EOF
fi
