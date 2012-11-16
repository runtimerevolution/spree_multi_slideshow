class AddHtmlContentToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :html_content, :text
  end
end
