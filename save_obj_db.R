#### Save object in database ####

# Need to:
#         1. Get information about the object
#         2. Get the object and serialise it
#         3. Insert the inforamtion about the object in the database
#         4. Insert the serialised object into the database
#         5. Create/recreate index on object information

list_objects <- function(envir = globalenv()){

  output <- objects(name = envir, sorted = T)

  return(list(output, TRUE))

}

get_object_info <- function(object){

  read_obj <- function(object){

    obj <- eval(parse(text = object))

    list(name = as.character(object),
         class = class(obj),
         str = capture.output(str(obj)),
         length = ifelse(length(grep(x = class(obj), pattern = "data\\.frame|data\\.table|tibble")), nrow(obj), length(obj)),
         n_colums = ifelse(length(grep(x = class(obj), pattern = "data\\.frame|data\\.table|tibble")), ncol(obj), NA)
        )
  }

  output <- lapply(X = object, FUN = function(x) read_obj(x))
  names(output) <- object

  return(output)

}

serialize_object <- function(object_name){

}
