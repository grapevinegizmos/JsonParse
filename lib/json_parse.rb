require "json_parse/version"
require "active_support/all"

class JsonParse
  include Enumerable
  @jsonstring = nil
  @rootkey = nil
  @throwmissing = true #determines whether the parser throws an exception or returns nil if a key is not found.  Set to false after debugging!
  @source = nil
  @h = nil


  def method_missing(m, *args)

    #looks for top level keys and returns the value
    a = args
    if !(self.keys!.include?(m))
      if @throwmissing
        super
      else
        return nil
      end
    end
    self._value(m)
  end

  # @return [JsonParse]
  # @param [Object] symbol
  def get_by_key(symbol)
    method_missing(symbol.to_sym, nil)
  end

  def each(&block)
    if self._check_for_keyword("each")
      return _value(:each)
    end
    _each(&block)
  end

  def each!(&block)
    _each(&block)
  end

  def length
    if self._check_for_keyword("length")
      return _value(:length)
    end
    @h.length
  end

  def length!
    return _length
  end

  def keys!
    _keys
  end

  def keys
    if self._check_for_keyword("keys")
      return self._value(:keys)
    end
    _keys
  end

  def source!
    _source
  end
  def source
    if self._check_for_keyword("keys")
      return self._value(:keys)
    end
    _source
  end

  def add(key, value)
    @h[key.to_sym] = value
  end

  def initialize(val, rootkey = nil, throwmissing = false) #, jsonstring = '{"root": {"name":"Josh Kramer", "age":60, "children": [{"name": "jack", "age": 21},{"name": "sally","age":14}],  "pets": ["ruby","buddy","fluffy"], "address": {"city" : "Bainbridge Island", "state" : "WA"}}}')
    @source = val
    if val.nil?
      @h = {}
      @rootkey = nil
      return
    end
    @throwmissing = throwmissing
    @rootkey = rootkey
    if val.is_a?(JsonParse)
      @h = val.hash
      @rootkey = val.rootkey

    end

    if val.is_a?(Array)
      retval = []
      @rootkey = rootkey
      val.each do |item|
        if item.is_a?(Hash) || item.is_a?(Array)
          retval.push(JsonParse.new(item))
        else
          retval.push(item);
        end

      end
      @h = retval
    end
    if val.is_a?(Hash)
      @h = val.symbolize_keys!
      _discard_root #
    end
    if val.is_a?(String) #if it sa string, it should be a json string
      _load(val)
      @jsonstring = val
    end

    if @h.nil?
      raise "an unusable object was provided to the initializer"
    end

  end


  def rootkey
    if self._check_for_keyword("rootkey")
      return _value(:rootkey)
    end
    _rootkey
  end
  def rootkey!
    _rootkey
  end


  def json_string
    if self._check_for_keyword("json_string")
      return _value(:json_string)
    end
    @h.to_json
  end

  def json_string!
    _json_string
  end



  def contains_key(key = nil)
    if key == nil && self._check_for_keyword("contains_key")
      return _value(:contains_key)
    end
    @h.keys.include?(key)
  end




  def [](index)
    if @h.is_a?(Array)
      return @h[index]
    end
    nil

  end

  def count!
    _count
  end
  def count
    if self._check_for_keyword("hash")
      return _value(:hash)
    end
    _count
  end

  def hash!
    _hash
  end
  def hash
    if self._check_for_keyword("hash")
      return _value(:hash)
    end
   _hash
  end

  def _symbolize(h)
    if self._check_for_keyword("_symbolize")
      return _value("_symbolize")
    end

    h.symbolize_keys!
    h.each do |k, v|
      if v.is_a?(Hash)
        self._symbolize(v)
      end
    end
  end




  def _check_for_keyword(keyword)
    mykeys = []
    if @h.is_a?(Hash)
      mykeys = @h.keys
    end
    mykeys.include?(keyword.to_sym)
  end


  # @return (Hash)
  # @param [String] jsonString
  def _parse_json(jsonString)
    v = ActiveSupport::JSON.decode(jsonString)
  end

  def _value(key)
    if @h.is_a?(Array)
      return @h[key]
    end
    if @h.key?(key.to_sym)
      if @h[key].is_a?(Hash) || @h[key].is_a?(Array)
        return JsonParse.new(@h[key], key)
      else
        retval = @h[key]

        return retval
      end
    end
  end


  private

  def _length
    return @h.length
  end


  def _keys
    if @h.is_a?(Hash)
      return @h.keys
    end
    if @h.is_a?(Array)
      return "[]"
    else
      return nil if @h.nil?
      raise "expecting hash or array, got #{@h.class.name}"
    end

  end

  def _each(&block)
    if block_given?
      @h.each(&block)
    else
      return nil
    end
  end

  def _source
    @source
  end
  def _hash
    @h
  end
  def _count
    @h.length
  end

  def _load(jsonstring)
    if jsonstring.nil? && self._check_for_keyword("load")
      return _value(:load)
    end
    # var [Hash] @h
    @h = _parse_json(jsonstring)
    self._symbolize(@h)
    self._discard_root
  end

  def _json_string
    @h.to_json
  end
  def _rootkey
    @rootkey.to_s
  end

  def _discard_root()

    h2 = {}

    if @h.length == 1
      @rootkey = @h.keys[0]

      if @h.values[0].is_a?(Hash)
        @h.values[0].each do |k, v|
          h2[k] = v
        end
      end
    end
    if h2.length > 0
      @h = h2

    end
  end



end

