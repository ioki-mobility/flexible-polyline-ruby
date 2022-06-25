# frozen_string_literal: true

RSpec.describe FlexiblePolyline::Decoder do
  DECODED_LINES = File.read('spec/test/round_half_up/decoded.txt', encoding: 'utf-8').split("\n").freeze
  ENCODED_LINES = File.read('spec/test/round_half_up/encoded.txt', encoding: 'utf-8').split("\n").freeze

  shared_examples 'decode input line' do |encoded, decoded|
    describe 'decode' do

      subject(:result) { described_class.decode(encoded) }

      it 'expects result header to be decoded header' do
        expect(result[:header]).to eq(decoded[:header])
        end

      it 'expects result positions to be approx. decoded positions' do
        result[:positions].each_with_index do |position, pos_index|
          position.each_with_index do |pos_element, element_index|
          expect(pos_element).to be_within(0.00001).of(decoded[:positions][pos_index][element_index])
          end
        end
      end
    end
  end

  DECODED_LINES.each_with_index do |decoded_line, index|
    unless decoded_line
      next
    end

    raw_header, raw_positions = decoded_line.gsub(/[ {}\[\]]/, '')[0...-1]&.split("\;")
    precision, third_dim_precision, third_dim = raw_header[1...-1]&.split(',').map{ |num| Integer(num) }
    positions = raw_positions.split('),(').map do |raw_location|
      raw_location.gsub(/[()]/, '').split(',').map{|num| Float(num)}
    end

    if third_dim == 4 || third_dim == 5 || (precision && precision > 10) || (third_dim_precision && third_dim_precision > 10)
      next
    end

    decoded = {
      header: {
        precision: precision ? precision : 0,
        third_dim: third_dim ? third_dim : 0,
        third_dim_precision: third_dim_precision ? third_dim_precision : 0
      },
      positions: positions
    }

    encoded = ENCODED_LINES[index]
    include_examples 'decode input line', encoded, decoded
  end
end