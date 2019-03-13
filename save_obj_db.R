#### Save object in database ####

# Need to:
#         1. Get information about the object
#         2. Get the object and serialise it
#         3. Insert the inforamtion about the object in the database
#         4. Insert the serialised object into the database
#         5. Create/recreate index on object information

list_objects <- function(envir = globalenv()){

  output <- objects(name = envir, sorted = T)

  return(output)

}

list_functions <- function(envir = globalenv()){
  list_func <- capture.output(lsf.str(envir = envir))

  list_func <- lapply(list_func, function(x) strsplit(x, " : "))

  output <- vector(mode = "list", length(length(list_func)))

  for(ii in seq_along(list_func)){
    output[[ii]] <- unlist(list_func[[ii]])
    output[[ii]] <- data.table(func_name = output[[ii]][1], func_def = output[[ii]][2])
  }

  # get arguments

  output <- as.data.table(rbindlist(l = output))

  output <- get_func_arguments(output)


  return(output)


}

get_func_arguments <- function(list_func){

  list_func[, func_args := str_extract(string = func_def, pattern = "[(].*?[)]")]
  list_func[, func_args := str_sub(string = func_args, start = 2, end = (nchar(func_args)-1))]

  # need to separate arguments and their default values.

  return(list_func)
}

get_object_info <- function(object){

  read_obj <- function(object){
    obj <- eval(parse(text = object))
    ls_obj <- list(uuid = uuid::UUIDgenerate(use.time = T),
               name = as.character(object)[1],
               class = class(obj)[1],
               size_mb = capture.output(object.size(obj))[1],
               str = capture.output(str(obj))[1],
               length = ifelse(length(grep(x = class(obj)[1], pattern = "data\\.frame|data\\.table|tibble")), nrow(obj), length(obj)),
               n_colums = ifelse(length(grep(x = class(obj)[1], pattern = "data\\.frame|data\\.table|tibble")), ncol(obj), NA),
               os = version$os,
               r_version = version$version.string
              )

    ls_obj <- as.data.table(ls_obj, stringsAsFactors = F)

  }

  output <- lapply(X = object, FUN = function(x) read_obj(x))

  output <- rbindlist(output)

  return(output)

}

serialize_object <- function(object_name){
  output <- serialize(object_name, connection = NULL)
  return(output)
}

insert_serialized_object <- function(obj_info,
                                     db_conn,
                                     comment = "",
                                     obj_tbl = "objects",
                                     metadata_tbl = "object_metadata",
                                     info_tbl = "object_info"
                                     ){
  browser()

  sql_object <- sprintf("INSERT INTO ?tbl_obj VALUES (?uuid, ?name, ?blob);")
  sql_metadata <- sprintf("INSERT INTO ?tbl_meta VALUES (?uuid, ?cls, ?sz, ?lg, ?ncol);")
  sql_info <- sprintf("INSERT INTO ?tbl_info VALUES (?uuid, ?ts, ?os, ?ver, ?cmt);")

  query <- DBI::sqlInterpolate(conn = db_conn,
                               sql = paste0(sql_object, sql_metadata, sql_info),
                               tbl_obj = obj_tbl,
                               tbl_meta = metadata_tbl,
                               tbl_info = info_tbl,
                               name = obj_info$name,
                               uuid = obj_info$uuid,
                               blob = paste0("'", list(serialize_object(eval(parse(text = obj_info$name)))), "'"),
                               cls = obj_info$class,
                               sz = obj_info$size_mb,
                               lg = obj_info$length,
                               ncol = obj_info$n_colums,
                               ts = Sys.time(),
                               os = obj_info$os,
                               ver = obj_info$r_version,
                               cmt = comment
                               )

  DBI::dbSendQuery(conn = db_conn, statement = query)

  # RSQLite::dbSendQuery(db_conn,
  #                     statement = 'INSERT INTO :tbl VALUES (:uuid, :name, :blob)',
  #                     params = list(tbl = table_name,
  #                                   uuid = uuid,
  #                                   name = name,
  #                                   blob = list(serialize_object(object))
  #                                   )
  #                     )

  return(TRUE)

}
