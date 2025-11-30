# Microservice app for demo

## Images

```
muarwi/demo-microservice-nginx
muarwi/demo-microservice-app
muarwi/demo-microservice-db
```

## Docker Compose
```bash
docker-compose up --build -d .
```

## Kubernetes
tba.

### NGINX

Expose an unsecured route:
```
oc expose svc nginx -n demo
```


### App
tba.

### Postgres

```
psql -U user -h localhost app_db
```