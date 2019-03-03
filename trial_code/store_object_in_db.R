#### Structure of return object ####

# 1. query
# 2. query results
# 3. plots created
# 4. date of analysis
# 5. user

# When returning the list of saved show time and title

# Is a json better for data frame / data table and query? Better to search afterward? Need to search afterward?

#### Trial with objects ####
plot(mtcars$mpg, mtcars$cyl)
p <- recordPlot()

# serialise the data frame
ser_mtcars <- serialize(object = mtcars, connection = NULL)
# serialise a plot
ser_plot1_mtcars <- serialize(object = p, connection = NULL)

# unserialise and restore objects
un_mtcars <- unserialize(connection = ser_mtcars)
un_plot1_mtcars <- unserialize(connection = ser_plot1_mtcars)

#### Trial with SQLite ####
'CREATE TABLE data (blob BLOB);'

# insert into SQLite
RSQLite::dbGetQuery(db.conn, 'INSERT INTO data VALUES (:blob)', params = list(blob = list(serialize(some_object))))

# read from SQLite
some_object <- unserialize(RSQLite::dbGetQuery(db.conn, 'SELECT blob FROM data LIMIT 1')$blob[[1]])
