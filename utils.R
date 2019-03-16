db_connect_old <- function(db_drv = RSQLite::SQLite(), db_name = "r_object_db.sqlite"){

  output <- dbConnect(drv = db_drv, name = db_name)

  return(output)

} # Not working

db_connect <- function(db_drv = RSQLite::SQLite(), db_name = "r_object_db.sqlite"){

  RSQLite::dbConnect(drv = db_drv, name = db_name)

} # Not working

db_disconnect <- function(db_conn, del_con_obj = TRUE){

  dbDisconnect(conn = eval(parse(text = db_conn)))

  if (isTRUE(del_con_obj)) {

    envr_conn <- get_environment(object = paste0(db_conn))

    eval(parse(text = paste0("rm(", db_conn, "", ", " , "envir =", envr_conn, ")"))) #", " , "envir = parent.frame()",
    }

  return(TRUE)

}

where <- function(name, env = parent.frame()) { # from the pryr package
  if (identical(env, emptyenv())) {
    # Base case
    stop("Can't find ", name, call. = FALSE)

  } else if (exists(name, envir = env, inherits = FALSE)) {
    # Success case
    env

  } else {
    # Recursive case
    where(name, parent.env(env))

  }
} # from pryr package

get_environment <- function(object, env = parent.frame()){

  envr <- capture.output(where(name = object, env = env))[1]

  output <- stringr::str_remove(string = envr, pattern = "<environment: ")
  output <- stringr::str_remove(string = output, pattern = ">")

  if (output == "R_GlobalEnv") {
    output <- ".GlobalEnv"
  }

  return(output)

}
