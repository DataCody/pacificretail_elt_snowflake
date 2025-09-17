create database if not exists pacificretail_db
create schema if not exists bronze

use pacificretail_db.bronze

create or replace storage integration azure_int
  type = external_stage
  storage_provider = azure
  enabled = true
  storage_allowed_locations = ('azure://pacificretail123.blob.core.windows.net/landing')
  azure_tenant_id = 'Tenant_ID'

  desc storage integration azure_int;
  use pacificretail_db.bronze
create or replace stage azure_stage
  url='azure://pacificretail123.blob.core.windows.net/landing'
  storage_integration=azure_int;

  ls @azure_stage