+++
title = "My Website Config"
date = "2024-11-25T13:00:54-05:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
author = ""
cover = ""
tags = ["porkbun", "dclient", "dns", "nginx proxy manager", "ssl", "https", "certificates"]
keywords = ["", ""]
description = "Automate DNS record updates on Porkbun and update SSL certificates from Porkbun in Nginx Proxy Manager"
showFullContent = false
readingTime = false
hideComments = false
+++

# My situation
I have two domains registered with [Porkbun](https://porkbun.com/), and I host my sites locally in my house with [Nginx Proxy Manager](https://nginxproxymanager.com/). This is the promise that was made to me, and mostly kept:

* Porkbun promises a cool API to manage your sites and generates SSL certificates for you.
* Nginx Proxy Manager handles SSL termination and can dispatch my various sites requests to the hosts serving them.

The original setup is really easy (there are tutorials out there). However I ran into the following problems:
* My machines did not come with a version of dclient that supports updating my DNS using the Porkbun API
    * New versions of dclient are supposed to support it but I could not find a working config example. Quite frankly at this point I thought it was too much work to do something that should be simple. [These instructions](https://thedutch.dev/setup-dynamic-dns-with-ddclient-and-porkbun) looked promising. Having to tinker with docker compose for this task *and* having to work to see a working config was a dealbreaker for me
* Nginx Proxy Manager does not have an API/CLI/other to update SSL certificates programatically. This is my fault, I just assumed it would be possible. 
    * [Nginx API](https://github.com/NginxProxyManager/nginx-proxy-manager/blob/develop/backend/schema/swagger.json): I could find a lot of stuff in there, but no way to update certificates
    * [This guy](https://github.com/NginxProxyManager/nginx-proxy-manager/issues/1618#issuecomment-1115757916) claims that you can hack around the limitation by just updating the certificates in the container. This is the route that I wanted to follow.

# Plan
My idea is that two python scripts running as systemd services will do the job.

[Detailed Instructions](https://github.com/jmtremblay2/porkbun/blob/main/README.md)

### Update DNS record
[DNS update on Porkbun](https://github.com/jmtremblay2/porkbun/blob/main/ddns.py) 

Pseudo-code to update DNS records:
```python
my_site = "jmopines.com"
sleep_time_seconds = 900
while True:
    current_ip = get_external_ip()
    my_site_ip = get_domain_ip(my_site)
    if current_ip and my_site_ip and current_ip != my_site_ip:
        porkbun_api_update_dns_record(my_site, current_id)
    time.sleep(sleep_time_seconds)
```

### Update Certificates
[Update Nginx Proxy Manager SSL Certs](https://github.com/jmtremblay2/porkbun/blob/main/certs.py)

Pseudo-code to update SSL certificates
```python
nsginx_cert_id = 1
my_site = "jmopines.com"
start_looking_for_updates = datetime.timedelta("30 days")
sleep_time = "1 day"
while True:
    # read the certs in the nginx data, decode them and check when they expire
    expires = get_nginx_pm_cert_expiration(nginx_cert_id)
    if (expires - now()) < start_looking_for_updates:
        print("certificates nearing expiration. checking for updates")
        # at this point porkbun should have updated SSL certs
        new_certs = porkbun_api_get_certs(my_site)
        new_certs_expires = get_cert_expiration(new_certs)
        if new_certs_expires == expires:
            print("new certificates not available yet")
        else:
            print("updating certificates")
            # stop the service
            stop_nginxpm()
            # update the text files with the certs in the container
            update_nginxpm_data(my_site, new_certs)
            update_nginxpm_database(my_site, new_certs)
            # restart nginxpm, with up to date certificates
            start_nginxpm()
    else:
        print("certificates are still good")
    
    time.sleep(sleep_time)
```

# Other Considerations
There are a couple gotchas that I skipped in the previous sections:
* I liberally grouped domains and subdomains. If you don't deal with all your subdomains wholesale, you may have to adjust your strategy.
* Assume you manage only one domain. With two ore more domains you might have to spin more than one service, or adjust the main loop to update all your domains.
* Since I'm only hacking nginx proxy manager, I wasn't sure to what extent I needed to perform my update. Should you create new certificates and link your proxy hosts to them. I ignored this kind of detail.
* Lookup strategy. Currently I only look up the public DNS record for my domain without calling the Porkbun API. I am not sure what is the best strategy for this.
* Strategy to get LAN external IP. I put code together until it works but there might be an art to it.
* Sleeping. for SSL certificates. If you know they expire in a long time, maybe sleeping and looking every day is not optimal. You could sleep until you actually want to update them. 
* My friend [Michael Carpenter](https://github.com/malcom2073) pointed out that this could just be a cron job. Maybe it should. His certificates were expired when I checked his site so maybe he should follow my instructions. :-) 
