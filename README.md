# ProxySQL
An **unofficial** container for ProxySQL that includes the MySQL client inside.

## Usage

### Start ProxySQL container with persistent volume named `proxysqldata`
```sh
docker run -d -P -v proxysqldata:/var/lib/proxysql --name proxysql strombergs/proxysql
```

### Manage Proxysql settings from the `mysql` CLI
```sh
docker exec -it proxysql mysql
```

## Extra Configuration
### Specify your own custom `proxysql.cnf`
```sh
-v /path/to/proxysql.cnf:/etc/proxysql.cnf 
```

### Specify a custom MySQL client options file
The default `client.cnf` assumes the default proxysql login of `admin:admin`.
```sh
-v /path/to/.my.cnf:/etc/mysql/conf.d/client.cnf
```
or you could just override some of it using parameters
```sh
docker exec -it proxysql mysql -pNewSecretPassword -P 42069 -h 127.0.0.1
```

## Credits
[The official ProxySQL repository](https://hub.docker.com/r/proxysql/proxysql)
