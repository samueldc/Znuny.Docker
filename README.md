# Znuny.Docker

Znuny docker image project based on Znuny 6.4.


## About o Znuny

- [Source code](https://github.com/znuny/znuny).
- [Documentation](https://doc.znuny.org/).
- [Downloads](https://download.znuny.org).

## Architecture

- Application: Apache/mod_perl serving Znuny code.
- Batch: Znuny Daemon.
- Database: PostgreSQL.
- Database administration: pgAdmin (optional).
- Cache: TMPFS volume ou similar.
- Filesystem: Named volume.
- Runtime: Docker.

## Requirements

- Linux ou WSL2 (Windows >10/2004).
- Docker.

To setup WSL with Docker follow this [instructions](https://www.objectivity.co.uk/blog/how-to-live-without-docker-desktop-developers-perspective/).

In the case of WSL, if you want to bind the project directory on (```/opt/otrs```), you should enable mount at ```sudo -e /etc/wsl.conf``` adding:

```
[automount]
options = "metadata"
```

If you computer has less than 16GB of RAM, I suggest tune WSL memory running ```vim .wslconfig``` at you Windows home profile folder and adding:

```
[wsl2]
memory=3000MB
processors=2
```

At least 6GB of RAM is recommended to run the whole stack.

## First time instructions

- Clone the repository.
- If you use bind, run the script ```docker/local-users.sh``` as root to create the local users accounts and groups (in the case of WSL, ser config **metadata** above) passing the the name of you local user as argument. Example: ```sudo docker/local-users.sh nomeusuario```.
- You could restore a previous database backup saving the backup file as ```docker/postgres/otrs.backup```.
- Run the stack described in the ```docker-compose.yml``` using ```docker-compose up -d --build```.
- Check if the 4 containers are running using ```docker ps -a```.
- Check if the volumes were created using ```docker volume ls```.
- Check if the startup of the database.
- Check if httpd and the Znuny Daemon was initiated.
- Access services using localhost.
  - Znuny: http://localhost:8080/otrs/index.pl
  - pgAdmin: http://localhost:8089
- In the first time, you need to setup the connection in the pgAdmin console.
- Complete Znuny installation process using http://localhost:8080/otrs/installer.pl.

## Database restore instructions

Run the script ```docker/postgres/restoredb.sh``` (you should have the file ```docker/postgres/otrs.backup```). 

## About Docker disk space

I suggest run ```docker system prune``` from time to time. The tutorial linked below could be useful.

- [How to Shrink a WSL2 Virtual Disk](https://stephenreescarter.net/how-to-shrink-a-wsl2-virtual-disk/)

## Useful commands

SMTP package analyzing

```tcpdump -A host <mail server address> and port 587```

## Step by step to process implementation using Znuny Process Management option

* Analisar especificação
* Criar grupos
* Criar perfils
* Associar perfis e grupos
* Criar filas
* Criar grupos no IDEA para cada perfil
* Criar campos de formulários
* Criar serviços
* Criar SLAs
* Associar SLAs e serviços
* Definir serviços como serviço padrão
* Criar processo
* Criar formulários
* Criar atividades
* Criar transições
* Criar ações de transições
* Criar ACLs
* Criar atendentes genéricos
* Criar notificações
* Outros

## push e pull best practices (only if you use bind to your project folder)

* Run ```pull``` with the stack stopped (```docker-compose down```). 
* Run ```push``` with the stack running (```docker-compose up -d```).

## Common problems

* [Postgres startup failure](https://stackoverflow.com/questions/8799474/postgresql-error-panic-could-not-locate-a-valid-checkpoint-record)

## Work in progress

* Daemon dedicated container.
* Postfix dedicated container.
* Everything else.