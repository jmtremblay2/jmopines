# test your site content isolated, in a docker
```bash
# build by pulling from gitlab, missing configs there will be visible here
sudo docker build -t jmopines:test -f Dockerfile_test .

# run it from docker
sudo docker run -it -p 1313:1313 jmopines:test
```

navigate to [your test site](http://localhost:1313) in your browser and verify that it works.

# build your site
```bash
# build the site
hugo build 

docker run -v ./public:/usr/share/nginx/html -p 8080:80 nginx:alpine 
```

navigate to [site served by Nginx](http://localhost:8080) in your browser and verify that it works.

# deploy

Deploy howewer you like. Maybe you are happy with running nginx with a mounted volume and updating the volume when you have new content. Or you can set up a job to look for updates on your site's main branch and auto-refresh the public folder on a schedule.