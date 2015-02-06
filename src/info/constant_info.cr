require "./base_info"

class ConstantInfo < BaseInfo
  def value
    size = LibGIRepository.constant_info_get_value(self, out value)
    {size, value}
  end

  def with_value
    size, value = self.value
    yield value
  ensure
    LibGIRepository.constant_info_free_value(self, pointerof(value))
  end

  def type
    type = BaseInfo.wrap LibGIRepository.constant_info_get_type(self)
    type.is_a?(TypeInfo) ? type : raise "Bug: didn't get a TypeInfo"
  end

  def literal
    with_value do |value|
      case type.tag
      when LibGIRepository::TypeTag::BOOLEAN
        value.v_boolean.inspect
      when LibGIRepository::TypeTag::INT8
        value.v_int8.inspect
      when LibGIRepository::TypeTag::UINT8
        value.v_uint8.inspect
      when LibGIRepository::TypeTag::INT16
        value.v_int16.inspect
      when LibGIRepository::TypeTag::UINT16
        value.v_uint16.inspect
      when LibGIRepository::TypeTag::INT32
        value.v_int32.inspect
      when LibGIRepository::TypeTag::UINT32
        value.v_uint32.inspect
      when LibGIRepository::TypeTag::INT64
        value.v_int64.inspect
      when LibGIRepository::TypeTag::UINT64
        value.v_uint64.inspect
      when LibGIRepository::TypeTag::FLOAT
        value.v_float.inspect
      when LibGIRepository::TypeTag::DOUBLE
        value.v_double.inspect
      when LibGIRepository::TypeTag::UTF8
        string = String.new(value.v_string)
        string.inspect
      else
        raise "Bug: Unhandled constant type #{type.tag}"
      end
    end
  end

  def definition
    "  #{name} = #{literal} # : #{type.definition}"
  end
end
