# Root object is the prayer object
object @prayer

# Declare the properties to include
attributes :id, :name, :request, :times_prayed_for, :created_at

# Rewrite reported to times_reported
attributes :reported => :times_reported