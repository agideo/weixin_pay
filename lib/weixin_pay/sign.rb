require 'digest/md5'

module WeixinPay
  module Sign
    def self.generate(params)
      key = params.delete :key || WeixinPay.key
      query_str = params.sort.map do |key, value|
        "#{key}=#{value}"
      end.join('&')
      
      Digest::MD5.hexdigest("#{query_str}&key=#{key}").upcase
    end

    def self.verify?(params)
      params = params.dup
      sign = params.delete('sign') || params.delete(:sign)

      generate(params) == sign
    end
  end
end