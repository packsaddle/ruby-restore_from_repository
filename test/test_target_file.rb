require_relative 'helper'

module RestoreFromRepository
  class TestTarget < Test::Unit::TestCase
    REGEX_BUNDLED_WITH = /^(?<pick>(?:\r\n|\r|\n)^BUNDLED WITH.*(?:\r\n|\r|\n).+(?:\r\n|\r|\n))/

    sub_test_case '.insert' do
      test 'v1.9 lock file' do
        lock_file = File.read('./test/fixtures/v1-9-example1.lock')
        section = ''
        assert do
          TargetFile.insert(lock_file, section) == TargetFile.new(lock_file)
        end
      end
      test 'v1.10 lock file' do
        deleted = File.read('./test/fixtures/v1-10-example1-deleted.lock')
        section = File.read('./test/fixtures/v1-10-example1-block.txt')
        lock_file = File.read('./test/fixtures/v1-10-example1.lock')
        assert do
          TargetFile.insert(deleted, section) == TargetFile.new(lock_file)
        end
      end
    end

    sub_test_case '#delete_bundled_with' do
      test 'v1.9 lock file' do
        lock_file = File.read('./test/fixtures/v1-9-example1.lock')
        assert do
          TargetFile.new(lock_file).delete_by_pattern(REGEX_BUNDLED_WITH) == TargetFile.new(lock_file)
        end
      end
      test 'v1.10 lock file' do
        lock_file = File.read('./test/fixtures/v1-10-example1.lock')
        deleted = File.read('./test/fixtures/v1-10-example1-deleted.lock')
        assert do
          TargetFile.new(lock_file).delete_by_pattern(REGEX_BUNDLED_WITH) == TargetFile.new(deleted)
        end
      end
    end

    sub_test_case '#pick' do
      test 'v1.9 lock file' do
        lock_file_contents = File.read('./test/fixtures/v1-9-example1.lock')
        expected = ''
        assert do
          TargetFile.new(lock_file_contents).pick_by_pattern(REGEX_BUNDLED_WITH) == expected
        end
      end
      test 'v1.10 lock file' do
        lock_file_contents = File.read('./test/fixtures/v1-10-example1.lock')
        expected = File.read('./test/fixtures/v1-10-example1-block.txt')
        assert do
          TargetFile.new(lock_file_contents).pick_by_pattern(REGEX_BUNDLED_WITH) == expected
        end
      end
    end

    sub_test_case '#==' do
      test 'compare different lock file' do
        v19 = File.read('./test/fixtures/v1-9-example1.lock')
        v110 = File.read('./test/fixtures/v1-10-example1.lock')
        assert do
          TargetFile.new(v19) != TargetFile.new(v110)
        end
      end
      test 'compare same lock file' do
        v110 = File.read('./test/fixtures/v1-10-example1.lock')
        one = TargetFile.new(v110)
        other = TargetFile.new(v110)
        assert do
          one == other
        end
      end
    end
  end
end
