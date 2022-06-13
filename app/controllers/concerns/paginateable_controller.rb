module PaginateableController
  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_PAGE_SIZE = 10

  private

  def pagination?
    params[:pagination] != 'off'
  end

  def paginate_collection(collection)
    if pagination?
      collection.page(page).per(size)
    else
      collection
    end
  end

  def page
    params.dig(:page, :number) || DEFAULT_PAGE_NUMBER
  end

  def size
    params.dig(:page, :size) || DEFAULT_PAGE_SIZE
  end

  def render_json(serializer, obj, options = {}, render_options = {})
    if options[:is_collection] && pagination?
      render_collection(serializer, obj, options, render_options)
    else
      render_serialized_json(serializer, obj, options, render_options)
    end
  end

  def render_collection(serializer, collection, options = {}, render_options = {})
    options = add_pagination_options(collection, options)
    render_serialized_json(serializer, collection, options, render_options)
  end

  def render_serialized_json(serializer, record, options = {}, render_options = {})
    render json: serializer.new(record, options), **render_options
  end

  def add_pagination_options(collection, options = {})
    options[:meta] = {} unless options.has_key?(:meta)
    options[:links] = {} unless options.has_key?(:links)
    options[:meta].merge!(generate_meta_pagination_options(collection))
    options[:links].merge!(generate_link_options(collection, options))
    options
  end

  def generate_meta_pagination_options(collection)
    {
      pagination: {
        currentPage: collection.current_page,
        prevPage: collection.prev_page,
        nextPage: collection.next_page,
        totalPages: collection.total_pages,
        totalItemCount: collection.total_count,
      }
    }
  end

  def generate_link_options(collection, options)
    {
      current: url_for(route_params(page, options)),
      first: url_for(route_params(DEFAULT_PAGE_NUMBER, options)),
      prev: collection.prev_page && url_for(route_params(collection.prev_page, options)),
      next: collection.next_page && url_for(route_params(collection.next_page, options)),
      last: url_for(route_params(collection.total_pages, options))
    }
  end

  def route_params(page, options)
    {
      action: action_name,
      controller: controller_name,
      page: {
        number: page,
        size: size
      }
    }.merge(options[:query_params] || {})
  end
end
