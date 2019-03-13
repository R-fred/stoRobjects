# Removed all history files (including the history-database file from RStudio)
# before starting.
# New R session.
# No packages loaded.
#
# Opening the database from the command line terminal using sqlite3
# the correct table ist listed "objects".
# sqlite> .open "/home/fred/Apps/R/stoRobjects/stoRobjects/r_object_db.sqlite"
# sqlite> .tables
# objects
#
# sqlite> .dbinfo
# database page size:  4096
# write format:        1
# read format:         1
# reserved bytes:      0
# file change counter: 3
# database page count: 5
# freelist page count: 0
# schema cookie:       1
# schema format:       4
# default cache size:  0
# autovacuum top root: 0
# incremental vacuum:  0
# text encoding:       1 (utf8)
# user version:        0
# application id:      0
# software version:    3022000
# number of tables:    1
# number of indexes:   0
# number of triggers:  0
# number of views:     0
# schema size:         45
#
# sqlite> .schema
# CREATE TABLE objects(uuid, name, object_blob);
#
# sqlite> SELECT * FROM objects LIMIT 1;
# 8a0d6946-41c3-11e9-a46c-1af3de97fb1e|a|'as.raw(c(0x58, 0x0a, 0x00, 0x00, 0x00, 0x02, 0x00, 0x03, 0x04, 0x04, 0x00, 0x02, 0x03, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x09, 0x00, 0x00, 0x00, 0x01, 0x61))'

#### Test - part 1 ####

# Using DBI::dbConnect directly
cn_db_DBI <- DBI::dbConnect(drv = RSQLite::SQLite(), name = "Apps/R/stoRobjects/stoRobjects/r_object_db.sqlite")
DBI::dbIsValid(cn_db_DBI)
DBI::dbListTables(cn_db_DBI)

lst_obj_db_DBI <- DBI::dbGetQuery(cn_db_DBI, "SELECT * FROM objects;")
print(lst_obj_db_DBI)

DBI::dbDisconnect(cn_db_DBI)
rm(cn_db_DBI)

# Using RSQLite::dbConnect directly
cn_db_RSQLite <- RSQLite::dbConnect(drv = RSQLite::SQLite(), name = "Apps/R/stoRobjects/stoRobjects/r_object_db.sqlite")
DBI::dbIsValid(cn_db_RSQLite)
DBI::dbListTables(cn_db_RSQLite)

lst_obj_db_RSQLite <- RSQLite::dbGetQuery(cn_db_RSQLite, "SELECT * FROM objects;")
print(lst_obj_db_RSQLite)

DBI::dbDisconnect(cn_db_RSQLite)
rm(cn_db_RSQLite)

#### Test - part 2 ####


# Using own wrapper function around RSQLite::dbConnect()
db_connect <- function(db_drv = RSQLite::SQLite(), db_name = "Apps/R/stoRobjects/stoRobjects/r_object_db.sqlite"){

  RSQLite::dbConnect(drv = db_drv, name = db_name)

}

cn_db_wrapRSQLite <- db_connect(db_drv = RSQLite::SQLite(), db_name = "Apps/R/stoRobjects/stoRobjects/r_object_db.sqlite")
DBI::dbIsValid(cn_db_wrapRSQLite)
DBI::dbListTables(cn_db_wrapRSQLite)

lst_obj_db_wrapRSQLite <- RSQLite::dbGetQuery(cn_db_wrapRSQLite, "SELECT * FROM objects;")
print(lst_obj_db_wrapRSQLite)

DBI::dbDisconnect(cn_db_wrapRSQLite)
rm(cn_db_wrapRSQLite)

# Using own wrapper function around RSQLite::dbConnect()
db_connect_DBI <- function(db_drv = RSQLite::SQLite(), db_name = "Apps/R/stoRobjects/stoRobjects/r_object_db.sqlite"){

  DBI::dbConnect(drv = db_drv, name = db_name)

}

cn_db_wrapDBI <- db_connect_DBI(db_drv = RSQLite::SQLite(), db_name = "Apps/R/stoRobjects/stoRobjects/r_object_db.sqlite")
DBI::dbIsValid(cn_db_wrapDBI)
DBI::dbListTables(cn_db_wrapDBI)

lst_obj_db_wrapDBI <- RSQlite::dbGetQuery(cn_db_wrapDBI, "SELECT * FROM objects;")
print(lst_obj_db_wrapDBI)

DBI::dbDisconnect(cn_db_wrapDBI)
rm(cn_db_wrapDBI)

#### Test - part 1 - repeat ####

# Using DBI::dbConnect directly
cn_db_DBI <- DBI::dbConnect(drv = RSQLite::SQLite(), name = "Apps/R/stoRobjects/stoRobjects/r_object_db.sqlite")
DBI::dbIsValid(cn_db_DBI)
DBI::dbListTables(cn_db_DBI)

lst_obj_db_DBI <- DBI::dbGetQuery(cn_db_DBI, "SELECT * FROM objects;")
print(lst_obj_db_DBI)

DBI::dbDisconnect(cn_db_DBI)
rm(cn_db_DBI)

# Using RSQLite::dbConnect directly
cn_db_RSQLite <- RSQLite::dbConnect(drv = RSQLite::SQLite(), name = "Apps/R/stoRobjects/stoRobjects/r_object_db.sqlite")
DBI::dbIsValid(cn_db_RSQLite)
DBI::dbListTables(cn_db_RSQLite)

lst_obj_db_RSQLite <- RSQLite::dbGetQuery(cn_db_RSQLite, "SELECT * FROM objects;")
print(lst_obj_db_RSQLite)

DBI::dbDisconnect(cn_db_RSQLite)
rm(cn_db_RSQLite)
