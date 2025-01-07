
# Instructions
```bash
# update site
./update.sh

./build.sh
# check that it built something:
tree /public/jmopines

# run it locally (on production server skip that, you should have tested first)
./stop.sh # if you were already running
./run.sh
firefox http://localhost:10555
./stop.sh

# deploy, you only need to do this once, after that the site data
# is just updated with new content
./deploy.sh
# check status
sudo systemctl status jmopines
```
