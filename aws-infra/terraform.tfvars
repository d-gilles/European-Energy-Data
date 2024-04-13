###################################
## Redshift Serverless Variables ##
###################################
redshift_serverless_namespace_name      = "mage-etl-namespace"
redshift_serverless_database_name       = "energydata" //must contain only lowercase alphanumeric characters, underscores, and dollar signs
redshift_serverless_admin_username      = "root"
redshift_serverless_admin_password      = "Ab08150815"
redshift_serverless_workgroup_name      = "mage-etl-workgroup"
redshift_serverless_base_capacity       = 32 // 32 RPUs to 512 RPUs in units of 8 (32,40,48...512)
redshift_serverless_publicly_accessible = false