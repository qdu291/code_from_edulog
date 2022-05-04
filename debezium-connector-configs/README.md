# debezium-connector-configs
Repository to Manage Debezium Connector Configurations

  #### Naming Conventions:
  :heavy_exclamation_mark: **Folders:** folders based on environment ```<ENV>```
  
  :heavy_exclamation_mark: :heavy_exclamation_mark: **Files:** 
*  *connector config:* **```<ENV>_```connector```_<TYPE>```-```<TABLE_NAME>```.json**
*  *worker config:* **```<ENV>_```worker_dbz-config.list**


##### Best Practices
* Have Kafka Setup with multiple bootstrap servers for High Availability
* It would be better to create Internal Topics ahead of configuring the connector
> :warning: **CONFIG_TOPIC:** Make sure Config Topic is having only one Partition, else the connector will not start. 
* Have multiple Connectors per environment. Make sure to have workers cluster per connector. Do not mix connectors. Example:
    *  File Connector Worker Seperate Cluster 
    *  Debezium worker connector Seperate Cluster
  

#### Instructions to Run Distributed Connector

***

1.  **Worker Config** : You would need worker configuration to create Debezium Image
  * :whale: **Local:** ```docker run --publish 8083:8083 --env-file ./debezium-connect-local-1.2-variables.list --name dbz-1-2-dev-msk debezium/connect:1.2 ```
      * Below File is saved as ```debezium-connect-local-1.2-variables.list``` file locally.
  *  **AWS** :cloud: **:**  Create the *ECS Task* with container definition using below environment variables  

:open_file_folder: **Sample Worker Config File** 
```properties 
#**********************COMMON FILE ALL THE CONNECTORS FOR A CLUSTER ***********************************

# Unique Id for a cluster
GROUP_ID=dbz-image-connectors-group

# Kafka Topics to save connector configs, offsets and status respectively.
CONFIG_STORAGE_TOPIC=dbz-1-2-configs
OFFSET_STORAGE_TOPIC=dbz-1-2-offsets
DBZ_STATUSES_TOPIC=dbz-1-2-status

# Bootstrap servers where the Internal Topics are Configured
# Try to provide multiple available servers for High Availability
BOOTSTRAP_SERVERS=b-2.dev-msk.lwwxjz.c3.kafka.us-east-2.amazonaws.com:9092,b-1.dev-msk.lwwxjz.c3.kafka.us-east-2.amazonaws.com:9092
# Kafka SerDes - Message Key and Value Converters 
KEY_CONVERTER=org.apache.kafka.connect.storage.StringConverter
VALUE_CONVERTER=org.apache.kafka.connect.json.JsonConverter
# Key and Value Schemas if enabled.
KEY_CONVERTER_SCHEMAS_ENABLE=false
VALUE_CONVERTER_SCHEMAS_ENABLE=false
# Kafka SerDes - Internal message Key and Value Converters 
INTERNAL_KEY_CONVERTER=org.apache.kafka.connect.storage.StringConverter
INTERNAL_VALUE_CONVERTER=org.apache.kafka.connect.json.JsonConverter
INTERNAL_KEY_CONVERTER_SCHEMAS_ENABLE=false
INTERNAL_VALUE_CONVERTER_SCHEMAS_ENABLE=false
``` 
***

2.  **Connector Config** : Debezium Connector Config Sample for ```trip_master``` table


:fire: **Sample Connector Json File** 



  * :whale: **Local or **AWS** :cloud::** ```curl -s -X POST -H 'Content-Type: application/json' 
--data @athena-np-dev-rds-connector.json http://<Host>:8083/connectors```
      * Below File is saved as ```athena-np-dev-rds-connector.json``` file locally.
      * ```<HOST>``` replace with IP or hostname
  *     

```json
{
    "name": "athena-np-trip-master-connector", 
    "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter.schemas.enable": "false",
        "value.converter.schemas.enable": "false",
        "internal.key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "internal.value..converter": "org.apache.kafka.connect.json.JsonConverter",
        "internal.key.converter.schemas.enable": "false",
        "internal.value.converter.schemas.enable": "false",
        "plugin.name": "wal2json_rds_streaming",
        "database.server.name": "athena-dev-rds",
        "database.hostname": "athena-dev-rds.cr5mzwdlkiuv.us-east-2.rds.amazonaws.com",
        "database.port": "5432",
        "database.user": "edulog",
        "database.password": "edul0g",
        "database.dbname": "Athena",
        "table.whitelist": "(.*).trip_master",
        "transforms": "Reroute",
        "transforms.Reroute.type": "io.debezium.transforms.ByLogicalTableRouter",
        "transforms.Reroute.topic.regex": "athena-dev-rds.(.*)",
        "transforms.Reroute.topic.replacement": "athena-np-trip-master-changes",
        "snapshot.mode": "never"
    }
}
```
* ```snapshot.mode```: Possible values are ```always, never, initial etc```
        More details: <a href=" https://debezium.io/documentation/reference/connectors/postgresql.html#postgresql-snapshots">snapshot modes</a>