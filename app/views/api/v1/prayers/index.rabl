# Do not provide default object
object false

# Node of oldest request - used for pagination
node(:oldest_request) { |m| @last }

# Prayers collection
child(@prayers) { extends "api/v1/prayers/show" }