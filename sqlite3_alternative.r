
# Use sqlite3 command line utility to get data ----
# Using this, the name of the columns is not returned, can get them using "PRAGMA table_info(table_name);"
# References:
# https://sqlite.org/cli.html#using_sqlite3_in_a_shell_script
# https://sqlite.org/cli.html
#
res <- system(command = 'sqlite3 r_object_db.sqlite "SELECT * FROM objects LIMIT 1;"', intern = T)

# Commands can be serialised to get, for instance, the column names in the output of the results
# sqlite3 r_object_db.sqlite ".headers on" "SELECT * FROM objects LIMIT 1;"

# Unserialize result object ----
# The object has to be unserialised slightly differently.
obj_ser <- strsplit(x = res, split = "\\|")[[1]][3]
obj_ser <- parse(text = obj_ser)
obj_ser <- eval(parse(text = obj_ser))
unserialize_object(eval(parse(text = obj_ser)))
