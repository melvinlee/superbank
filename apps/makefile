# Define variables
IMAGE_NAME = cash-api
IMAGE_TAG = latest
CONTAINER_NAME = cash-api-container
PORT = 80
DOCKER_USERNAME = melvinlee
DOCKER_REPO = docker.io/$(DOCKER_USERNAME)/$(IMAGE_NAME)

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) . --platform=linux/amd64 

# Tag the Docker image for Docker Hub
tag:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(DOCKER_REPO):$(IMAGE_TAG)

# Push the Docker image to Docker Hub
push: tag
	docker push $(DOCKER_REPO):$(IMAGE_TAG)

# Run the Docker container in detached mode
run:
	docker run -d -p $(PORT):8443 --name $(CONTAINER_NAME) $(IMAGE_NAME):$(IMAGE_TAG)

# Stop the Docker container
stop:
	docker stop $(CONTAINER_NAME)

# Remove the Docker container
rm:
	docker rm $(CONTAINER_NAME)

# Clean up (stop and remove the container)
clean: stop rm

# Rebuild and run the Docker container
rebuild: clean build run