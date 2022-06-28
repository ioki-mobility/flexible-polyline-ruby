# frozen_string_literal: true

module FlexiblePolyline

  class Encoder

    ENCODING_TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
    PRECISION = 5
    FORMAT_VERSION = 1

    class << self

      def encode(positions:, precision: nil, third_dim: nil, third_dim_precision: nil)
        precision ||= PRECISION
        third_dim ||= 0
        third_dim_precision ||= 0
        multiplier_degree = 10**precision
        multiplier_z = 10**third_dim_precision
        encoded_header_list = encode_header(precision, third_dim, third_dim_precision)
        encoded_coords = []

        last_lat = 0
        last_lng = 0
        last_z = 0
        positions.each do |location|
          lat = (location[0] * multiplier_degree).round
          encoded_coords << encode_scaled_value(lat - last_lat)
          last_lat = lat

          lng = (location[1] * multiplier_degree).round
          encoded_coords << encode_scaled_value(lng - last_lng)
          last_lng = lng

          next if third_dim.zero?

          z = (location[2] * multiplier_z).round
          encoded_coords << encode_scaled_value(z - last_z)
          last_z = z
        end
        [encoded_header_list, encoded_coords].join('')
      end

      private

      def encode_header(precision, third_dim, third_dim_precision)
        if precision.negative? || precision > 15
          raise ArgumentError, 'precision out of range. Should be between 0 and 15'
        end
        if third_dim_precision.negative? || third_dim_precision > 15
          raise ArgumentError, 'third_dim_precision out of range. Should be between 0 and 15'
        end
        if third_dim.negative? || third_dim > 7 || third_dim == 4 || third_dim == 5
          raise ArgumentError, 'third_dim should be between 0, 1, 2, 3, 6 or 7'
        end

        res = (third_dim_precision << 7) | (third_dim << 4) | precision
        encode_unsigned_number(FORMAT_VERSION) + encode_unsigned_number(res)
      end

      def encode_unsigned_number(val)
        res = String.new
        val = Integer(val)
        while val > 0x1F
          pos = (val & 0x1F) | 0x20
          res << (ENCODING_TABLE[pos]).to_s
          val >>= 5
        end
        "#{res}#{ENCODING_TABLE[val]}"
      end

      def encode_scaled_value(value)
        value = Integer(value)

        negative = value.negative?
        value <<= 1
        if negative
          value = ~value
        end
        encode_unsigned_number(value)
      end
    end
  end
end