# frozen_string_literal: true

shared_examples 'should raise invalid input error' do
  it 'raises an error' do
    expect { subject }.to raise_error(GeolocationService::InvalidInput)
  end
end
