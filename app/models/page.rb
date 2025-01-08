class Page
  def initialize(params:, relation:)
    @params = params
    @relation = relation
    @per_page = 20
  end

  def offset
    (current_page - 1) * per_page
  end

  def current_page
    params[:page] ? params[:page].to_i : 1
  end
  def total_count
    @total_count ||= relation.count
  end

  def total_pages
    (total_count.to_f / per_page).ceil
  end

  def next_page
    if current_page < total_pages
      current_page + 1
    else
      nil
    end
  end

  def prev_page
    if current_page > 1
      current_page - 1
    else
      nil
    end
  end

  private

  attr_accessor :per_page, :params, :relation
end
