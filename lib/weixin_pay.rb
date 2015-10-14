require "weixin_pay/version"
require "weixin_pay/sign"
require "weixin_pay/pay"
require "weixin_pay/result"

module WeixinPay
  class << self
    attr_accessor :appid, :mch_id, :key

    def extra_rest_client_options
      {}
    end
  end
end
