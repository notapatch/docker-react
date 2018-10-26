
#
# Build phase
#  - produce a build directory with the website content
#

#  "builder sets in a a block"
FROM node:alpine as builder

WORKDIR '/app'

# npm install dependency
COPY package.json .

RUN npm install

# copy all source code into the container
COPY . .

# create all the application data for the produciton
# site put into => /app/build
RUN npm run build

#
# Run phase
#  - use the NGINX image to run the site
#

# no "as" which means a new phase has begun
# FROM stops the last block
FROM nginx

# causes AWS error if port missing
EXPOSE 80


# copy from another phase    to: special NGINX folder for static content
COPY --from=builder /app/build  /usr/share/nginx/html


# default command is to run NGINX no CMD needed