RSpec.shared_examples 'successful creation' do
  it 'returns status created' do
    expect(response).to have_http_status(:created)
  end

  it 'returns success true' do
    expect(JSON.parse(response.body)['success']).to be true
  end
end