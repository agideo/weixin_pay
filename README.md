# WeixinPay

A simple Wechat pay ruby gem, without unnecessary magic or wrapper.
copied from [alipay](https://github.com/chloerei/alipay) .

Please read official document first: <https://mp.weixin.qq.com/paymch/readtemplate?t=mp/business/course3_tmpl&lang=zh_CN>.

## Installation

Add this line to your Gemfile:

```ruby
gem 'weixin_pay', :git => 'https://github.com/agideo/weixin_pay'
```

And then execute:

```sh
$ bundle
```

## Usage

### Config

Create `config/initializers/weixin_pay.rb` and put following configurations into it.

```ruby
# required
WeixinPay.appid = 'YOUR_APPID'
WeixinPay.key = 'YOUR_KEY'
WeixinPay.mch_id = 'YOUR_MCH_ID'
```

Note: You should create your APIKEY (Link to [微信商户平台](https://pay.weixin.qq.com/index.php/home/login)) first if you haven't, and pay attention that **the length of the APIKEY should be 32**.

### APIs

**TODO check required fields**

#### micropay (提交刷卡支付)

WeixinPay supports REST.

```ruby
#order_code build 32bit uuid
order_code = SecureRandom.uuid.tr('-', '')

WeixinPay::Pay.micrpay({
  attach: "微信刷卡支付",
  body: "购买商品",
  device_info: '88888888',
  out_trade_no: order_code,
  spbill_create_ip: '127.0.0.1',
  total_fee: 1,
  auth_code: 'xxxxxxxxxxxxxxxxxxx' #scan by scaner from weixin QR (扫描枪扫描微信二维码所获得)
})
```

`WeixinPay::Pay.micrpay params` will create an payment request and return a WeixinPay::Result instance(subclass of Hash) contains parsed result.

The result would be like this.

```ruby
result = WeixinPay::Pay.micrpay({
  ...
  ...
})

result.raw
# => {
#  "return_code"=>"SUCCESS",
#  "return_msg"=>"OK",
#  "appid"=>"wx0bbf1b0caa980033",
#  "mch_id"=>"13036914",
#  "device_info"=>"88888888",
#  "nonce_str"=>"lyAFYWYrbn33Y065",
#  "sign"=>"9EC971A06B1CD5B74DDAABA961DD90F",
#  "result_code"=>"SUCCESS",
#  "openid"=>"3Ea4HjqNk5BMEG6Ww6FVqO1tt1bI",
#  "is_subscribe"=>"Y",
#  "trade_type"=>"MICROPAY",
#  "bank_type"=>"CMB_DEBIT",
#  "total_fee"=>"1",
#  "fee_type"=>"CNY",
#  "transaction_id"=>"1004840644201510151204462655",
#  "out_trade_no"=>"e4bcf8b3f6b54c70ad784a73b254a556",
#  "attach"=>"微信刷卡支付", "time_end"=>"20151015133846",
#  "cash_fee"=>"1",
#  "cash_fee_type"=>""
}
```

Return true if both `return_code` and `result_code` equal `SUCCESS`

```ruby
result.success? # => true
```

#### orderquery (查询订单)

WeixinPay supports REST.

```ruby
WeixinPay::Pay.orderquery({
  out_trade_no: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx'
})
```

`WeixinPay::Pay.orderquery params` will create an payment request and return a WeixinPay::Result instance(subclass of Hash) contains parsed result.

The result would be like this.

```ruby
result = WeixinPay::Pay.orderquery({
  ...
  ...
})

result.raw
{
  "success":true,
  "paid":true,
  "out_trade_no":"b6c603e17874453fb513f7b46a5706e0",
  "trade_state":"SUCCESS",
  "errorobj":{
    "result_code":"SUCCESS",
    "err_code":null,
    "err_code_des":null,
    "return_msg":"OK"
  }
}
```

Details link to Weixin API doc [提交刷卡支付API](https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_10&index=1)

## TODO

Write test for WeixinPay gem

## Contributing

Bug report or pull request are welcome.

### Make a pull request

- 1. Fork it Fork it ( https://github.com/agideo/weixin_pay )
- 2. Create your feature branch (`git checkout -b my-new-feature`)
- 3. Commit your changes (`git commit -am 'Add some feature'`)
- 4. Push to the branch (`git push origin my-new-feature`)
- 5. Create new Pull Request

Please write unit test with your code if necessary.

## License

This project rocks and uses MIT-LICENSE.