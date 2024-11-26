# test

this looks silly but you can test the site like this. All local configs will be ignored because the site is built from its repository on github

```bash
# build a docker image of the site with hugo
sudo docker build -t jmopines:test .

# run it from docker
sudo docker run -it -p 1313:1313 jmopines:test
```

navigate to [your test site](http://localhost:1313) in your browser and verify that it works.