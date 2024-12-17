# Base image
FROM postman/newman:5.3.1-alpine

# Set working directory
WORKDIR /etc/newman

# Update and upgrade the image packages to the latest
RUN apk update && apk upgrade --no-cache

# Install extra packages
RUN apk add --no-cache curl zip iputils

# Install global node modules
RUN npm install -g newman-reporter-csvallinone

# Remove installation cache
RUN rm -rf /var/cache/apk/*

# Set environment variable NODE_PATH
ENV NODE_PATH=/usr/local/lib/node_modules

# Set entry point to newman
ENTRYPOINT ["newman"]
