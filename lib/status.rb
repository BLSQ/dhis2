module Dhis2
  class Status
    attr_reader :raw_status

    def initialize(raw_status)
      @raw_status = raw_status
    end

    def success?
      @raw_status["importTypeSummaries"].all? { |summary| summary["status"] == "SUCCESS" }
    end

    def import_count
      @raw_status["importCount"]
    end

    def total_imported
      total = 0
      import_count.each do |_, count|
        total += count
      end
      total
    end

    def last_imported_ids
      @raw_status["importTypeSummaries"].map { |summary| summary["lastImported"] }
    end
  end
end

# {
#   "importCount"=>{
#     "imported"=>1, 
#     "updated"=>0, 
#     "ignored"=>0, 
#     "deleted"=>0
#   }, 
#   "importTypeSummaries"=>[
#     {
#       "responseType"=>"ImportTypeSummary", 
#       "status"=>"SUCCESS", 
#       "importCount"=>
#       {
#         "imported"=>1, 
#         "updated"=>0, 
#         "ignored"=>0, 
#         "deleted"=>0
#       }, 
#       "type"=>"DataElement", 
#       "lastImported"=>"lMadHjxdo5q"
#     }
#   ]
# }
