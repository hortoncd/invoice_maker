module InvoiceMaker
  class Invoice
    PDF_CONTENT_TYPE  = 'application/pdf'
    JSON_CONTENT_TYPE = 'application/json'

    attr_accessor :dest_dir
    attr_reader :data

    def initialize
      @dest_dir = '/tmp'
      @data = Hash.new
      @base_uri = 'https://invoice-generator.com'
    end

    # set invoice data
    def set(options = {})
      @data = options
    end

    def data
      @data
    end

    def append_item(item)
      raise "Unable to add items to an empty invoice data.  Did you 'set' first?" if @data.empty?
      @data['items'] = [] unless @data.has_key?('items')
      @data['items'].push item unless @data.empty?
    end

    # Let's generate a pdf
    def generate
      response = HTTParty.post(@base_uri, body: @data.to_json, headers: { "Content-Type" => JSON_CONTENT_TYPE })
      if response.success? && response.content_type == PDF_CONTENT_TYPE
        filename = File.join(@dest_dir, SecureRandom.urlsafe_base64(16)) + '.pdf'
        save_pdf(filename, response.parsed_response)
      else
        return nil
      end
      return filename
    end

    private

    def save_pdf(filename, data)
      File.open(filename, "wb+") do |f|
        f << data
      end
    end
  end
end
