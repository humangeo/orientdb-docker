OrientDB running in a Docker container.

## Usage

There are two primary ways to run this container: as an OrientDB server or as
an OrientDB console.


### Use Case 1: Running an OrientDB Server

This configuration requires that the database *root* user password is set as an
environment variable (`ODB_ADMIN_PASSWORD`).

To run the OrientDB server:

    $ docker run \
      -e ODB_ADMIN_PASSWORD=password \
      -p 2480:2480 \
      -p 2424:2424 \
      humangeo/orientdb

This will run OrientDB on the default ports, but will loose data when the
container is shutdown. To persist data across container restarts, you will
need to map the `/opt/orientdb/databases` directory to your host file system.

To mount a local database directory with Docker:

    $ docker run \
      -e ODB_ADMIN_PASSWORD=password \
      -p 2480:2480 \
      -p 2424:2424 \
      -v <db-path>/databases:/opt/orientdb/databases \
      humangeo/orientdb

If you need to customize the configuration further, you can map
`/opt/orientdb/{config,databases,backup}` to local directories on the host file
system.


### Use Case 2: Running as part of a Maven project's Integration Tests

The following example spawns a temporary container that lives for the duration
of the integration tests:

```xml
...
<build>
  <plugins>
    <!-- Docker OrientDB instance for use during integration tests -->
    <plugin>
      <groupId>io.fabric8</groupId>
      <artifactId>docker-maven-plugin</artifactId>
      <version>0.14.2</version>
      <configuration>
        <showLogs>true</showLogs>
        <verbose>true</verbose>
        <keepContainer>false</keepContainer>
        <removeVolumes>true</removeVolumes>
        <images>
          <image>
            <name>humangeo/orientdb:latest</name>
            <alias>orientdb</alias>
            <run>
              <namingStrategy>alias</namingStrategy>
              <ports>
                <port>42424:2424</port>
              </ports>
              <env>
                <ODB_ADMIN_PASSWORD>${env.ODB_ADMIN_PASSWORD}</ODB_ADMIN_PASSWORD>
              </env>
              <wait>
                <log>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3} INFO success: orientdb entered RUNNING state, process has stayed up for > than 1 seconds.*</log>
              </wait>
            </run>
          </image>
        </images>
      </configuration>
      <executions>
        <execution>
          <id>start</id>
          <phase>pre-integration-test</phase>
          <goals>
            <goal>start</goal>
          </goals>
        </execution>
          <execution>
            <id>stop</id>
            <phase>post-integration-test</phase>
            <goals>
              <goal>stop</goal>
            </goals>
          </execution>
      </executions>
    </plugin>
  </plugins>
</build>
...
```

### Use Case 3: Running the OrientDB Console

You can run the OrientDB console by attaching to an existing OrientDB container
or by running a separate container. If you are trying to interact with an
OrientDB instance that is already running in a container, it is preferable to
just attach to that container and run the console from there.

To attach to a running OrientDB container:

    $ docker exec -it <container> /opt/orientdb/bin/console.sh

To run the console in a separate container:

    $ docker run -it --rm humangeo/orientdb:latest /opt/orientdb/bin/console.sh


## Resources

* Docker Hub (<https://hub.docker.com/r/humangeo/orientdb/>)
* GitHub (<https://github.com/humangeo/orientdb-docker>)
