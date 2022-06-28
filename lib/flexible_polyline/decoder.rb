# frozen_string_literal: true

module FlexiblePolyline

  class Decoder
    DECODING_TABLE = [
      62, -1, -1, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1,
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
      22, 23, 24, 25, -1, -1, -1, -1, 63, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
      36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
    ].freeze
    FORMAT_VERSION = 1

    class << self

      def decode(encoded)
        raise ArgumentError, 'Invalid string' unless encoded.is_a? String

        decoder = decode_unsigned_values(encoded)
        header = decode_header(decoder[0], decoder[1])

        factor_degree = 10**header[:precision]
        factor_z = 10**header[:third_dim_precision]
        third_dim = header[:third_dim]

        last_lat = 0
        last_lng = 0
        last_z = 0
        res = []

        cnt = 2
        while cnt < decoder.size - 1
          delta_lat = to_signed(decoder[cnt]) / factor_degree.to_f
          delta_lng = to_signed(decoder[cnt + 1]) / factor_degree.to_f
          last_lat += delta_lat
          last_lng += delta_lng

          if third_dim.zero?
            res << [last_lat.round(header[:precision]), last_lng.round(header[:precision])]
            cnt += 2
          else
            delta_z = to_signed(decoder[cnt + 2]) / factor_z.to_f
            last_z += delta_z
            res << [last_lat.round(header[:precision]),
                      last_lng.round(header[:precision]),
                      last_z.round(header[:third_dim_precision])]
            cnt += 3
          end
        end

        raise ArgumentError, 'Invalid encoding. Premature ending reached' if cnt != decoder.size
        {
          header: header,
          positions: res
        }
      end

      private

      def decode_char(char)
        DECODING_TABLE[char[0].ord - 45]
      end

      def decode_unsigned_values(encoded)
        result = 0
        shift = 0
        result_list = []

        encoded.chars.each do |char|
          value = decode_char(char)
          result |= (value & 0x1F) << shift
          if (value & 0x20).zero?
            result_list << result
            result = 0
            shift = 0
          else
            shift += 5
          end
        end

        raise ArgumentError, 'Invalid encoding' if shift.positive?

        result_list
      end

      def decode_header(version, encoded_header)
        raise ArgumentError, 'Invalid format version' if to_numeric(version) != FORMAT_VERSION

        header_number = to_numeric(encoded_header)
        precision = header_number & 15
        third_dim = (header_number >> 4) & 7
        third_dim_precision = (header_number >> 7) & 15
        {
          precision: precision,
          third_dim: third_dim,
          third_dim_precision: third_dim_precision
        }
      end

      def to_signed(val)
        val = ~val unless (val & 1).zero?
        to_numeric(val >> 1)
      end

      def to_numeric(value)
        num = BigDecimal(value.to_s)
        if num.frac.zero?
          num.to_i
        else
          num.to_f
        end
      end
    end
  end
end
