# frozen_string_literal: true
require 'byebug'

RSpec.describe FlexiblePolyline::Encoder do
  ORIGINAL_LINES = File.read('spec/test/original.txt', encoding: 'utf-8').split("\n").freeze
  ENCODED_LINES = File.read('spec/test/round_half_even/encoded.txt', encoding: 'utf-8').split("\n").freeze

  shared_examples 'encode input line' do |positions, precision, third_dim, third_dim_precision, encoded|
    describe 'encode' do

      subject(:result) { described_class.encode(positions: positions,
                               precision: precision,
                               third_dim: third_dim,
                               third_dim_precision: third_dim_precision) }

      it 'expects result to be encoded' do
        expect(result).to eq(encoded)
      end
    end
  end

  ORIGINAL_LINES.each_with_index do |original_line, index|
    unless original_line
      next
    end

    raw_header, raw_positions = original_line.gsub(/[ {}\[\]]/, '')[0...-1]&.split("\;")
    precision, third_dim_precision, third_dim = raw_header[1...-1]&.split(',').map{ |num| Integer(num) }
    positions = raw_positions.split('),(').map do |raw_location|
      raw_location.gsub(/[()]/, '').split(',').map{|num| Float(num)}
    end

    if third_dim == 4 || third_dim == 5 || (precision && precision > 10) || (third_dim_precision && third_dim_precision > 10)
      next
    end

    encoded = ENCODED_LINES[index]
    include_examples 'encode input line',positions, precision, third_dim, third_dim_precision, encoded
  end
end