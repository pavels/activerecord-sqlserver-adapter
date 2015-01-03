require 'cases/helper_sqlserver'
require 'models/company'
require 'models/project'
require 'models/subscriber'

class InheritanceTestSQLServer < ActiveRecord::TestCase
end

class InheritanceTest < ActiveRecord::TestCase

  fixtures :companies, :projects, :subscribers, :accounts

  COERCED_TESTS = [
    :test_a_bad_type_column,
    :test_eager_load_belongs_to_primary_key_quoting
  ]

  include ARTest::SQLServer::CoercedTest

  def test_coerced_a_bad_type_column
    Company.connection.execute "SET IDENTITY_INSERT [companies] ON"
    Company.connection.insert "INSERT INTO companies ([id], [type], [name]) VALUES(100, N'bad_class!', N'Not happening')"
    Company.connection.execute "SET IDENTITY_INSERT [companies] OFF"
    assert_raise(ActiveRecord::SubclassNotFound) { Company.find(100) }
  end

  def test_coerced_eager_load_belongs_to_primary_key_quoting
    con = Account.connection
    assert_sql(/\[companies\]\.\[id\] IN \(1\)/) do
      Account.includes(:firm).find(1)
    end
  end


end


