class DBError extends Error
  constructor: (status, msg, tableName, sqlErr) ->
    @name = 'DBError'
    @status = status
    @msg = msg || 'DB Error Occurs'
    @sqlErr = sqlErr
    @table = tableName
    @title = 'Database Error'

angular.module('greHelper.services').factory 'StorageService', ($rootScope, $cordovaSQLite, $q, $log) ->
  logTag = "StorageService"
  schema =
    list: "id integer primary key, name text, fid integer, tid integer, ftimes integer, last_finished_times text"
    review: "id integer primary key, vid integer, vtimes integer"

  initDb = ->
    createTask = Object.keys(schema).map (tableName) ->
      drop(tableName)
      create(tableName)
    $q.all(createTask)

  drop = (name) ->
    query = "DROP TABLE IF EXISTS #{name}"
    $cordovaSQLite.execute($rootScope.db, query)
    $log.debug "#{logTag} : drop table '#{name}'"

  create = (name) ->
    query = "CREATE TABLE IF NOT EXISTS #{name} (#{schema[name]})"
    $cordovaSQLite.execute($rootScope.db, query)
    .then (res) ->
      $log.debug "#{logTag} : create table '#{name}'"
      res
    , (sqlErr) ->
      err = new DBError(2, "An error occurs when create table in database", name, sqlErr)
      $log.error "#{logTag} : #{err.msg} (reason: #{err.sqlErr.message}; table: #{err.table})"
      $q.reject err

  update = (name, params) ->
    fields = Object.keys(params)
    values = fields.map (k) -> params[k]
    query = "INSERT OR REPLACE INTO #{name} (#{fields.join(',')}) VALUES (#{'?,'.repeat(fields.length-1) + '?'})"
    $cordovaSQLite.execute($rootScope.db, query, values)
    .then (res) ->
      $log.debug "#{logTag} : Insert #{res.rowsAffected} row into '#{name}' (value: #{JSON.stringify(params)})"
      res
    , (sqlErr) ->
      err = new DBError(3, "An error occurs when insert value in database", name, sqlErr)
      $log.error "#{logTag} : #{err.msg} (reason: #{err.sqlErr.message}; table: #{err.table})"
      $q.reject err

  remove = (name, params) ->
    clause = []
    values = []
    $.map params, (value, key) ->
      v_clause = if value.length > 0 then "(#{'?,'.repeat(value.length-1) + '?'})" else "()"
      clause.push "#{key} in #{v_clause}"
      for v in value
        values.push v
    query = "DELETE FROM #{name} where #{clause.join(" AND ")}"
    $cordovaSQLite.execute($rootScope.db, query, values)
    .then (res) ->
      $log.debug "#{logTag} : Delete #{res.rowsAffected} row into '#{name}' (value: #{JSON.stringify(params)})"
      res
    , (sqlErr) ->
      err = new DBError(5, "An error occurs when delete value in database", name, sqlErr)
      $log.error "#{logTag} : #{err.msg} (reason: #{err.sqlErr.message}; table: #{err.table})"
      $q.reject err

  all = (name) ->
    $cordovaSQLite.execute($rootScope.db, "SELECT * FROM #{name}")
    .then (res) ->
      $log.debug "#{logTag} : read #{res.rows.length} rows from table '#{name}'"
      data = []
      for i in [0 .. res.rows.length - 1] by 1
        data.push res.rows.item(i)
      data
    , (sqlErr) ->
      err = new DBError(4, "An error occurs when read value from database", name, sqlErr)
      $log.error "#{logTag} : #{err.msg} (reason: #{err.sqlErr.message}; table: #{err.table})"
      $q.reject(err)

  getJoins = (tables, fields) ->
    joinClause = tables.join(' JOIN ')
    onClause = "#{tables[0]}.#{fields[0]} = #{tables[1]}.#{fields[1]}"
    query = "SELECT * FROM #{joinClause} ON #{onClause}"
    $cordovaSQLite.execute($rootScope.db, query)
    .then (res) ->
      $log.debug "#{logTag} : read #{res.rows.length} rows from table '#{tables[0]}', '#{tables[1]}'"
      data = []
      for i in [0 .. res.rows.length - 1] by 1
        data.push res.rows.item(i)
      data
    , (sqlErr) ->
      err = new DBError(4, "An error occurs when read value from database", "", sqlErr)
      $log.error "#{logTag} : #{err.msg} (reason: #{err.sqlErr.message}; table: #{err.table})"
      $q.reject(err)

  get = (name, params) ->
    clause = []
    values = []
    $.map params, (value, key) ->
      v_clause = if value.length > 0 then "(#{'?,'.repeat(value.length - 1) + '?'})" else "()"
      clause.push "#{key} in #{v_clause}"
      for v in value
        values.push v
    query = "SELECT * FROM #{name} where #{clause.join(" AND ")}"
    $cordovaSQLite.execute($rootScope.db, query, values)
    .then (res) ->
      $log.debug "#{logTag} : read #{res.rows.length} rows from table '#{name}'"
      data = []
      for i in [0 .. res.rows.length - 1] by 1
        data.push res.rows.item(i)
      data
    , (sqlErr) ->
      err = new DBError(4, "An error occurs when read value from database", name, sqlErr)
      $log.error "#{logTag} : #{err.msg} (reason: #{err.sqlErr.message}; table: #{err.table})"
      $q.reject(err)


  create: create
  update: update
  all: all
  initDb: initDb
  get: get
  getJoins: getJoins
  remove: remove

