module Admin
  class Table
    attr_reader :table
    def initialize( )

      @table ||= []
    end


    def insert_data(row, col, data)
      row_i = find_row(row)

      col_i = find_col(col)
      @table[row_i][col_i] = data
    end

    def row_primary_keys
      table.map { |row| row[0] }
    end

    private

    def find_row(row)
      unless row_primary_keys.include?(row[0])
        ordered_insert_new_row(row)
      end

      row_primary_keys.index(row[0])
    end

    def ordered_insert_new_row(row)
      i = insert_new_row_sorted_index(row)
      table.insert(i, row)
    end

    def insert_new_row_sorted_index(row)
      raise "row exist" if row_primary_keys.include?(row[0])
      buf = row_primary_keys << row[0]
      buf.sort
      buf.index(row[0])
    end

    def find_col(col)
      @ordered_cols ||= []
    end

  end
end
