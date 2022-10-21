# LXC Local environment setup

## FILES/VOLUMES needed before running docker containers:
* /local/path/to/project/dbdata
* /local/path/to/project/esdata
* /local/path/to/project/lrdata/document_library
* /local/path/to/project/liferay/files/portal-ext.properties
* /local/path/to/project/liferay/files/osgi/configs


--------------
## ELASTICSEARCH:
Run container based on elasticsearch:7.17.2:

Note: Change path to project accordingly
```
docker run -d --name lxc-es -v /local/path/to/project/esdata:/usr/share/elasticsearch/data -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "cluster.name=lxc-cluster" elasticsearch:7.17.2
```


Install Analysis plugins:
```
docker exec -it lxc-es bash
```

```
#: /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
#: /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-kuromoji
#: /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-smartcn
#: /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-stempel
#: exit
```

```
docker restart lxc-es
```
--------------

## DB:
Run docker container based on mariadb:10.6. Included script to initialize lportal database.

Note: Change path to project, accordingly.

```
docker run -itd --name lxc-db -e MARIADB_USER=lportal -e MARIADB_PASSWORD=lportal -e MARIADB_ROOT_PASSWORD=secret -v /local/path/to/project/dbdata:/var/lib/mysql -v /local/path/to/project/dbschema:/docker-entrypoint-initdb.d -p 3306:3306 mariadb:10.6
```

-------------

## LR:
Run docker container based on currently last update of liferay/dxp.

Note: Change path to project, accordingly. 

Note2: Get IP addresses for elasticsearch and database containers, and change them accordingly:
```
docker inspect lxc-es | grep IPAddress
docker inspect lxc-db | grep IPAddress
```
```
docker run -itd --name lxc-lr-u45 --add-host lxc-es:172.17.0.2 --add-host lxc-db:172.17.0.3 -e LIFERAY_JPDA_ENABLED=true -e JPDA_ADDRESS=*:8000 -e JPDA_TRANSPORT=dt_socket -p 8080:8080 -p 8000:8000 -v /local/path/to/project/liferay:/mnt/liferay -v /local/path/to/project/lrdata/document_library:/opt/liferay/data/document_library liferay/dxp:7.4.13-u45
```
-------------

## UPGRADE
To upgrade to the latest update:

Note: Change paths and IPs accordingly, as stated on previous section
```
docker stop lxc-lr-u45

docker run -itd --name lxc-lr-u46 --add-host lxc-es:172.17.0.2 --add-host lxc-db:172.17.0.3 -e LIFERAY_JPDA_ENABLED=true -e JPDA_ADDRESS=*:8000 -e JPDA_TRANSPORT=dt_socket -p 8080:8080 -p 8000:8000 -v /local/path/to/project/liferay:/mnt/liferay -v /local/path/to/project/lrdata/document_library:/opt/liferay/data/document_library liferay/dxp:7.4.13-u46
```
Access GoGo Shell and execute modules upgrade:
```
upgrade:checkAll
upgrade:executeAll
```
## TO-DO
Moving to docker-compose or k8s for an easier project kick-start


