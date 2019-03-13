library(RSQLite)
library(data.table)
library(stringr)

setwd("Apps/R/stoRobjects/stoRobjects/")



cn_db <- db_connect(RSQLite::SQLite(), "r_object_db.sqlite")

lst_obj_db <- dbGetQuery(cn_db, "SELECT * FROM objects;")

obj_new <- retrieve_object(db_conn = cn_db, obj_name = "ls_objects")

all_obj_db <- retrieve_all_object_names(db_conn = cn_db, tbl_name = "objects")
