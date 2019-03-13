setup_object_db <- function(db_name = "r_object_db.sqlite", db_type = "SQLite"){

  db_conn <- DBI::dbConnect(drv = RSQLite::SQLite(), name = db_name)

  tbl_obj <-  "CREATE TABLE objects(uuid, name, object_blob);" # Small table containing only the most basic information and the object data.
  tbl_images <-   "CREATE TABLE images(uuid, image_file);" # Table to save pictures in case of plots
  tbl_metadata <- "CREATE TABLE object_metadata(uuid, class, size_mb, length, n_columns);" # Information about the object
  tbl_objInfo <- "CREATE TABLE object_info(uuid, timestamp, os, r_version, comment);" # Object metadata - context information

  sql <- paste0(tbl_obj, tbl_images, tbl_metadata, tbl_objInfo)

  query <- DBI::sqlInterpolate(conn = db_conn, sql = sql)

  DBI::dbSendQuery(db_conn, query)
  DBI::dbDisconnect(db_conn)

  return(TRUE)

}
