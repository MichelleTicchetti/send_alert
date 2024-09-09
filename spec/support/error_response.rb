shared_examples 'error response' do |status|
  it "returns status #{status}" do
    expect(response).to have_http_status(status)
  end

  it 'returns success false' do
    expect(JSON.parse(response.body)['success']).to be false
  end
end