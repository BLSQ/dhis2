def symbolize_keys(obj)
  case obj
  when Hash
    obj.each_with_object({}) do |(k, v), hash|
      hash[k.to_sym] = symbolize_keys(v)
    end
  when Array
    obj.map { |elt| symbolize_keys(elt) }
  else
    obj
  end
end