module WeixinPay
  class Result < ::Hash
    SUCCESS_FLAG = 'SUCCESS'.freeze

    def initialize(result)
      super

      if result['xml'].class == Hash
        @raw = result['xml']
        result['xml'].each_pair do |k, v|
          self[k] = v
        end
      end
    end

    def raw
      @raw
    end

    def success?
      self['return_code'] == SUCCESS_FLAG && self['result_code'] == SUCCESS_FLAG
    end
  end
end