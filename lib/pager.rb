class Pager
  attr_reader :page, :page_count, :total, :next_page

  def initialize(hash)
    @page = hash["page"]
    @page_count = hash["pageCount"]
    @total = hash["total"]
    @next_page = hash["nextPage"]
  end
end
