require 'rest_client'
require 'active_support/core_ext/hash/conversions'

module WeixinPay
  module Pay
    API_BASE_URL = "https://api.mch.weixin.qq.com/pay"
    API_MICRPAY_URL = "#{API_BASE_URL}/micropay"
    API_ORDERQUERY_URL = "#{API_BASE_URL}/orderquery"
    INVOKE_MICRPAY_REQUIRED_FIELDS = %w(appid mch_id nonce_str sign body out_trade_no total_fee spbill_create_ip auth_code)

    def self.micrpay(params={})
      params = {
          appid: WeixinPay.appid,
          mch_id: WeixinPay.mch_id,
          nonce_str: SecureRandom.uuid.tr('-', ''),
          time_expire: Time.now.since(1.minutes).strftime("%Y%m%d%H%M%S")
        }.merge(params)

      # TODO check_required_params(params, INVOKE_MICRPAY_REQUIRED_FIELDS)

      remote_params = params.merge(sign: WeixinPay::Sign.generate(params))
      xml = make_xml(remote_params)
      post_pay(API_MICRPAY_URL, xml)
    end

    def self.orderquery(params={})
      params = {
          appid: WeixinPay.appid,
          mch_id: WeixinPay.mch_id,
          nonce_str: SecureRandom.uuid.tr('-', '')
        }.merge(params)

      # TODO check_required_params(params, INVOKE_MICRPAY_REQUIRED_FIELDS)

      remote_params = params.merge(sign: WeixinPay::Sign.generate(params))
      xml = make_xml(remote_params)
      post_pay(API_ORDERQUERY_URL, xml)
    end

      private

      def self.post_pay(url, xml)
        Rails.logger.info url
        Rails.logger.info xml
        result = RestClient::Request.execute({
          method: :post,
          url: url,
          payload: xml,
          headers: { content_type: 'application/xml' }
        }.merge(WeixinPay.extra_rest_client_options))

        if result
          WeixinPay::Result.new Hash.from_xml(result)
        else
          nil
        end
      end

# 提交刷卡支付
# <xml>
#    <appid>wx2421b1c4370ec43b</appid>
#    <attach>订单额外描述</attach>
#    <auth_code>120269300684844649</auth_code>
#    <body>刷卡支付测试</body>
#    <device_info>1000</device_info>
#    <goods_tag></goods_tag>
#    <mch_id>10000100</mch_id>
#    <nonce_str>8aaee146b1dee7cec9100add9b96cbe2</nonce_str>
#    <out_trade_no>1415757673</out_trade_no>
#    <spbill_create_ip>14.17.22.52</spbill_create_ip>
#    <time_expire></time_expire>
#    <total_fee>1</total_fee>
#    <sign>C29DB7DB1FD4136B84AE35604756362C</sign>
# </xml>
# 查询订单
# <xml>
#    <appid>wx2421b1c4370ec43b</appid>
#    <mch_id>10000100</mch_id>
#    <nonce_str>ec2316275641faa3aacf3cc599e8730f</nonce_str>
#    <transaction_id>1008450740201411110005820873</transaction_id>
#    <out_trade_no>2008450740201411110005820874</out_trade_no>
#    <sign>FDD167FAA73459FD921B144BAF4F4CA2</sign>
# </xml>
      def self.make_xml(params)
        xml_body = params.map do |k, v|
          "<#{k}>#{v}</#{k}>"
        end.join("\n")
xml = <<-xml_str
<xml>
  #{xml_body}
</xml>
xml_str
       xml
      end

      def self.check_required_params(params, names)
        names.each do |name|
          warn("WeixinPay Warn: missing required option: #{name}") unless params.has_key?(name)
        end
      end
  end
end

