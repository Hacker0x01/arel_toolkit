# Make sure the gems are loaded before ArelToolkit
require 'postgres_ext' if Gem.loaded_specs.key?('postgres_ext')
require 'active_record_upsert' if Gem.loaded_specs.key?('active_record_upsert')
require 'pg_search' if Gem.loaded_specs.key?('pg_search')
require 'rails/railtie' if Gem.loaded_specs.key?('railties')
require 'arel'

require 'arel_toolkit/version'
require 'arel/extensions'
require 'arel/sql_to_arel'
require 'arel/middleware'
require 'arel/enhance'
require 'arel/transformer'

module ArelToolkit
end

require 'ffi'
require 'inline'

# header file is useful src/interfaces/libpq/libpq-fe.h
# docs about the library https://www.postgresql.org/docs/9.1/libpq-misc.html

# What we want to do here:
# instantiate a PGresult struct in C
# - use PQmakeEmptyPGresult()

# somehow get a VALUE object for pg_conn
# instantiate a PG::Result object in ruby
module Test
  # Great article:
  # https://medium.com/@astantona/fiddling-with-rubys-fiddle-39f991dd0565
  extend FFI::Library

  dir = Gem.loaded_specs.fetch('pg').stub.extension_dir
  file = 'pg_ext.bundle'
  path = File.join(dir, file)

  ffi_lib path

  typedef :ulong, :self
  typedef :pointer, :pg_result

  attach_function :pgresult_get, [:self], :pg_result

  # https://www.postgresql.org/docs/10/libpq-misc.html
  typedef :string, :value
  attach_function :pq_set_value, :PQsetvalue, [:pg_result, :int, :int, :value, :int], :int

  # Maybe use PQcopyResult to make a copy of an existing result object
  # pass proper flags to not copy the attributes and tuples
  # next set the attributes and tuples
  def self.test2
    result = ActiveRecord::Base.connection.raw_connection.make_empty_pgresult(2)
    result_pointer = Test.ruby_to_pointer(result)
    pg_result_pointer = Test.pgresult_get(result_pointer)
    Test.pq_set_value(pg_result_pointer, 0, 0, 'papi', 0)
  end

  typedef :pointer, :att_descs
  attach_function :pq_set_result_attrs, :PQsetResultAttrs, [:pg_result, :int, :att_descs], :int

  # src/include/postgres_ext.h:31
  # typedef unsigned int Oid;
  typedef :uint, :oid

  # src/interfaces/libpq/libpq-fe.h:235
  class PGresAttDesc < FFI::Struct
    layout :name, :pointer,
           :tableid, :oid,
           :columnid, :int,
           :format, :int,
           :typid, :oid,
           :typlen, :int,
           :atttypmod, :int

    # Scary. Ruby strings to C String pointer is hard apparently.
    # Can't simply do
    # layout :name, :string
    # and try to assign to that string, will result in "Cannot set string field"
    # because this is not a safe operation.

    # Can use a macro https://stackoverflow.com/questions/50917280/ruby-ffi-string-not-getting-to-char-function-argument
    # to safe convert a ruby string into a c string
    # which can then be used as a column name?

    # copied setter from
    # https://github.com/Paxa/fast_excel/issues/30
    def name=(val)
      pos = offset_of(:name)

      if val.is_a?(String)
        val = FFI::MemoryPointer.from_string(val)
      end

      if val.nil?
        pointer.put_pointer(pos, FFI::MemoryPointer::NULL)
      elsif val.is_a?(FFI::MemoryPointer)
        pointer.put_pointer(pos, val)
      else
        raise("keywords= requires an FFI::MemoryPointer or nil")
      end

      val
    end

    def name
      self[:name].read_string
    end

    def to_h
      result = {}

      members.each do |member|
        result[member] = self[member]
      end

      result
    end
  end

  # For query `SELECT 1 as kerk`
  # name => 'kerk'
  # tableid => 0
  # columnid => 0
  # format => 0
  # typid => 23
  # typlen => 4

  # src/interfaces/libpq/libpq-int.h:167
  class PGData < FFI::Struct
    layout :ntups, :int,
           :numAttributes, :int,
           :attDescs, :pointer

    def attributes
      val_array = FFI::Pointer.new(Test::PGresAttDesc, self[:attDescs])

      0.upto(self[:numAttributes] - 1).map do |i|
        Test::PGresAttDesc.new(val_array[i])
      end
    end
  end

  def self.test3
    result = ActiveRecord::Base.connection.execute("SELECT 1 AS kerk, 'hello' AS shine")
    # result = ActiveRecord::Base.connection.raw_connection.make_empty_pgresult(2)
    result_pointer = Test.ruby_to_pointer(result)
    pg_result_pointer = Test.pgresult_get(result_pointer)

    column = Test::PGresAttDesc.new
    column.name = 'kerk'
    column[:tableid] = 0
    column[:columnid] = 0
    column[:format] = 0
    column[:typid] = 23
    column[:typlen] = 4

    Test.pq_set_result_attrs(pg_result_pointer, 1, column.pointer)

    r = Test::PGData.new(pg_result_pointer)

    binding.pry

    # att_desc = Test::PGresAttDesc.new
    # att_desc[:name] = 'test'
  end

  # Instead of duplicating the struct here, modify the struct using public methods
  # https://www.postgresql.org/docs/10/libpq-misc.html
  # PQsetResultAttrs
  # PQsetvalue
  # PQmakeEmptyPGresult modifies all the necessary attributes
  # src/interfaces/libpq/fe-exec.c:142

  # https://stackoverflow.com/questions/41516431/can-i-pass-a-ruby-object-pointer-to-a-ruby-ffi-callback
  def self.ruby_to_pointer(obj)
    # obj.object_id << 1 # <<-- get the memory address, don't make it a pointer
    # https://stackoverflow.com/questions/2818602/in-ruby-why-does-inspect-print-out-some-kind-of-object-id-which-is-different/2818916#2818916
    # Read the article why this works
    address = obj.object_id << 1
    # ffi_pointer = ::FFI::Pointer.new(:pointer, address)
  end

  def self.test1
    # result = ActiveRecord::Base.connection.raw_connection.make_empty_pgresult(2)
    result = ActiveRecord::Base.connection.execute('SELECT 1')
    result_pointer = Test.ruby_to_pointer(result)
    pg_result_pointer = Test.pgresult_get(result_pointer)
    pg_data = Test::PGData.new(pg_result_pointer)

    puts result.ntuples

    binding.pry

    # pg_data[:ntups] = 10

    puts result.ntuples
  end
end

# Article going from C struct to Ruby and from Ruby to C struct
# http://clalance.blogspot.com/2013/11/writing-ruby-extensions-in-c-part-13.html
