require 'digest/md5'

module WeixinPay
  module Sign
    def self.generate(params)
      key = WeixinPay.key
      query_str = params.sort.map do |k, v|
        "#{k}=#{v}"
      end.join('&')
      Rails.logger.info query_str

      Rails.logger.info "#{query_str}&key=#{key}"
      Digest::MD5.hexdigest("#{query_str}&key=#{key}").upcase
    end

    def self.verify?(params)
      params = params.dup
      sign = params.delete('sign') || params.delete(:sign)

      generate(params) == sign
    end
  end
end