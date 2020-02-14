module Admin
  class Table
    attr_reader :table, :row_order_by, :col_order_by
    def initialize( row_order_by: nil, col_order_by: nil)

      @table ||= []
      @row_order_by = row_order_by
      @col_order_by = col_order_by
    end


    def insert_calc(row_key, col_key, data)
      row_i = insert_row(row_key)
      col_i = insert_col(col_key)

      if @table[row_i][col_i]
        @table[row_i][col_i] += data
      else
        @table[row_i][col_i] = data
      end

    end

    def get_data(row_key, col_key)
      row_i = find_row(row_key)
      col_i = find_col(col_key)
      @table[row_i][col_i]
    end

    def row_primary_keys
      table.map { |row| row[0] }
    end

    def col_primary_keys
      @col_primary_keys ||= []
    end

    private

    def find_row(row_key)
      row_primary_keys.index(row_key)
    end

    def find_col(col_key)
      i = col_primary_keys.index(col_key)
      i += 1 if i
    end

    def insert_row(row_key)
      # insert row when row not exist.
      unless find_row(row_key)
        new_row_pk_index = insert_sorted_new_row_pk(row_key, order_by: row_order_by)
        insert_new_row_to_table(new_row_pk_index, row_key)
      end

      row_primary_keys.index(row_key)
    end

    def insert_sorted_new_row_pk(row_key, order_by: nil)
      # return if row_key exist
      return if find_row(row_key)

      new_row_primary_keys = row_primary_keys << row_key
      if order_by
        new_row_primary_keys.sort! { |a, b| a.send(order_by) <=> b.send(order_by) }
      else
        new_row_primary_keys.sort!
      end
      new_row_primary_keys.index(row_key)
    end

    def insert_new_row_to_table(row_pk_index, row_key)
      table.insert(row_pk_index, [row_key])
    end

    def insert_col(col_key)
      # insert col when col not exist.
      unless find_col(col_key)
        new_col_pk_index = insert_sorted_new_col_pk(col_key, order_by: col_order_by)
        insert_new_col_to_table(new_col_pk_index)
      end

      find_col(col_key)
    end

    def insert_sorted_new_col_pk(col_key, order_by: nil)
      return if find_col(col_key)

      col_primary_keys << col_key
      if order_by
        col_primary_keys.sort! { |a, b| a.send(order_by) <=> b.send(order_by) }
      else
        col_primary_keys.sort!
      end

      find_col(col_key)
    end

    def insert_new_col_to_table(col_pk_index)
      table.each do |row|
        row.insert(col_pk_index, nil)
      end
    end

  end
end
