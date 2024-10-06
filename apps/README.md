# Cash API

This application provides a simple API for managing account balances and checking the health of the service.

- GET /: Returns the current balance.
- POST /transaction: Handles deposit and withdrawal transactions.
- GET /health: Returns the health status of the application.

Testing the API with curl:

1. Get Current Balance:

```sh
curl -X GET http://localhost:8443/
```

2. Deposit Transaction:

```sh
curl -X POST http://localhost:8443/transaction -H "Content-Type: application/json" -d '{"amount": 100, "type": "deposit"}'
```

3. Withdraw Transaction:

```sh
 curl -X POST http://localhost:8443/transaction -H "Content-Type: application/json" -d '{"amount": 50, "type": "withdraw"}'
 ```

 4. Health Check:
 
 ```sh
 curl -X GET http://localhost:8443/health
 ```

## Build and Deploy

Usage

- Build the Docker image: `make build`
- Tag the Docker image: `make tag`
- Push the Docker image to Docker Hub: `make push`
- Run the Docker container: `make run`
- Stop the Docker container: `make stop`
- Remove the Docker container: `make rm`
- Clean up (stop and remove the container): `make clean`
- Rebuild and run the Docker container: `make rebuild`

This `Makefile` provides a convenient way to manage your Docker container lifecycle.

Make sure to replace `yourusername` with your actual Docker Hub username in the `DOCKER_USERNAME` variable.