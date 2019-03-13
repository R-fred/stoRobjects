#### Retrieve object from database ####

# Need to:
#         1. List information about all objects.
#         2. Select the object based on the information retrieved
#         3. Get the object
#         4. Unserialise the object into a new object (possibly with the same name?)
#         5. Keep a record of how many times the object has been used

retrieve_object <- function(db_conn, obj_name){

  if (dbIsValid(db_conn) == FALSE) {
    cat("Database (link) invalid. Trying to reset the connection now...")

    ## Disconnect and reconnect to the database to ensure a clean connection
    db_name <- db_conn@dbname
    dbDisconnect(db_conn)
    db_conn <- dbConnect(drv = RSQLite::SQLite(), name = db_name)
    ##
  }

  sql <- sprintf("SELECT object_blob FROM objects WHERE name = '%s';", obj_name)

  query <- sqlInterpolate(conn = db_conn, sql = sql)

  qry_res <- dbGetQuery(conn = db_conn,
                        statement = query
                        )
  obj_text <- as.character(qry_res)
  to_parse <- parse(text = obj_text)

  output <- eval(parse(text = to_parse))

  output <- unserialize_object(output)

  return(output)

}

retrieve_all_object_names <- function(db_conn, tbl_name = "objects"){

  sql <- sprintf("SELECT name from %s", tbl_name)

  query <- sqlInterpolate(conn = db_conn, sql = sql)

  output <- dbGetQuery(conn = db_conn, statement = query)

}

unserialize_object <- function(retrieved_object){

  output <- unserialize(retrieved_object)
  return(output)

}
