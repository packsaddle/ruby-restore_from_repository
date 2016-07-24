require_relative 'helper'

module RestoreFromRepository
  class TestRestore < Test::Unit::TestCase
    test 'version' do
      assert do
        !::RestoreFromRepository::VERSION.nil?
      end
    end
  end
end
