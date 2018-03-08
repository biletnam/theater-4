package src.persistance;

import ballerina.data.sql;
import ballerina.io;

const string h2DbLocation = "./";
const int h2Port = 3306;
const string h2Database = "EVENTS";
const string h2UserName = "root";
const string h2Password = "root";
// Above will be replaced from the config API as below
// string mysqlHostName = config:getGlobalValue("database.host");

public sql:ClientConnector sqlCon = initDb();

function initDb () (sql:ClientConnector connInit) {

    sql:ConnectionProperties propertiesInit = {maximumPoolSize:5, connectionTimeout:300000, datasourceProperties: null};
    connInit = create sql:ClientConnector(sql:DB.H2_FILE, h2DbLocation, h2Port, h2Database, h2UserName, h2Password, propertiesInit);
    initializeDB(connInit);
    return;
}

function initializeDB (sql:ClientConnector connInit) {
    endpoint<sql:ClientConnector> ep {
    }
    bind connInit with ep;
    string query = "CREATE TABLE IF NOT EXISTS EVENTS(ID INT AUTO_INCREMENT, NAME VARCHAR(255), START_TIME
    VARCHAR(255), VENUE VARCHAR(255), ORGANIZER_NAME VARCHAR(255), PRIMARY KEY (ID))";
    int ret = ep.update(query, null);

    if (ret != 0) {
        error e = {message: "Error occured while initializing the DB"};
        throw e;
    }
}