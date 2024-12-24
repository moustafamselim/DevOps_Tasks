### <ins>Please read carefully and complete what is required</ins>...
####  <ins>Scripting task</ins>

1. Write a Bash shell or a python script which can..
* Process a text file which has users and their properties in each line.
* Determine one by one if the ID number of the user (last column) is odd or even number if it's specified. 
* Check whether that user has a routable, FQDN email address.
* If so, write a message to stdout like:

  > The $ID of $EMAIL is (even|odd) number. 
* If the user has no valid email address OR user ID, the script should silently continue the next user 
  showing a warning for the invalid parameters The content of the 

        source text file: 
        name, email, id 
        John, john_j123@domain.com,
        325 Susan, ,510 Jane, 
        jane_j121@domain.com, 131 
        Karl, karl_ka234@domain.com 
        Bert, bert_bb23@localhost, 150 

## Result
![Script](URL "title")


___

#### <ins>Kubernetes task</ins>

Using tools and environments of your choice, create...
* Kubernetes cluster containing: 
    > - One master 
    >- One or more nodes
    >- Access to kubernetes API is restricted to number of IP addresses. 
    >- Document creating of cluster and all needed access rights in git repository. 

## Result
![CP&W](URL "title")

* On the Kubernetes cluster:
   >- Deploy nginx ingress - https://github.com/kubernetes/ingress-nginx/. 
   >- Deploy "Juice Shop" application, you can use official docker image from ‘bkimminich/juice-shop’. 
   >- Expose “Juice Shop” application inside the cluster using a service. 
   >- Expose “Juice Shop” application to outside the cluster using the nginx ingress.

## Result
![juice-shop](URL "title")



___

#### <ins>Docker task</ins>

* Create a custom image with the following specs...

        Base image-postman/newman:5.3.1-alpine
        Update/upgrade the image packages to the latest.
        Globally Install node modules: newman-reporter-csvallinone
        Install extra packages: curl zip ping
        Set the DNS explicitly to 8.8.8.8 & 1.1.1.1
        Remove the installation cache.
        Set an environment variable NODE_PATH to have the value  /usr/local/lib/node_modules 
        Set working directory to /etc/newman 
        Set the entry point to newman 

## Result
![newman](URL "title")



   
    



