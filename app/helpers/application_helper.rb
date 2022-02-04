
# this helper model was adpated from: https://stackoverflow.com/questions/27408660/how-to-sort-ruby-table-by-column-headers
module ApplicationHelper
    def sorting_teams(column, title = nil)
      title ||= column.titleize
      css_class = column == sort_column ? "current #{sort_direction}" : nil
      direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
      link_to title, {:sort => column, :direction => direction}, {:class => css_class}
    end

    def sorting_feedback(column, title = nil)
      title || column.titleize
      direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
      link_to title, :sort => column, :direction => direction
    end
end