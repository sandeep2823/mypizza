module Helpers
  def self.table_to_hash(table)
    table.transpose.raw.inject({}) do |hash, column|
      column.reject!(&:empty?)
      hash[column.shift.to_sym] = column
      hash
    end
  end
end
