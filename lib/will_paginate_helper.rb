module WillPaginate
  module ViewHelpers
    def page_entries_info collection, options = {}
      p collection.size
      if collection.size == 0
        return '検索結果 0 件'
      else
        %{<b>%d</b> 件中 <b>%d&nbsp;-&nbsp;%d</b> 件目を表示} % [
          collection.total_entries,
          collection.offset + 1,
          collection.offset + collection.length
        ]
      end
    end
  end
end

