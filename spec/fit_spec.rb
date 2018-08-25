Dir.glob('./src/**/*.rb').each { |f| require f }

describe Fit do
  let(:sample_data) do
    [
      {
        "id": "404c1873-96e5-4767-899a-c28697b4ccd4",
        "name": "Squats",
        "average_span": 20,
        "average_calorie_consumption": 120
      },
      {
        "id": "075fe124-5b39-4276-b0ac-de4fd5b38f6f",
        "name": "Arm curls",
        "average_span": 10,
        "average_calorie_consumption": 25
      },
      {
        "id": "2085747a-eee5-445a-85fc-92da51709a41",
        "name": "Plank",
        "average_span": 2,
        "average_calorie_consumption": 10
      },
      {
        "id": "81fd3a46-e736-4498-9094-f5d7730d1409",
        "name": "Jumping jacks",
        "average_span": 10,
        "average_calorie_consumption": 35
      }
    ]
  end

  before do
    allow_any_instance_of(Fit).
      to receive(:data).
      and_return(JSON.parse(sample_data.to_json))
  end

  shared_examples 'returns expected consuption' do
    it do
      expect(call[0]).to eq consumption
    end
  end

  shared_examples 'returns expected items' do
    it do
      expect(call[1].map { |i| i['id'] }).to match_array item_ids
    end
  end

  describe '.call' do
    subject(:call) { described_class.call params }

    context 'when data is enough to cover max' do
      let(:params) { { max: 30 } }
      let(:consumption) { 155 }
      let(:item_ids) do
        [
          "81fd3a46-e736-4498-9094-f5d7730d1409",
          "404c1873-96e5-4767-899a-c28697b4ccd4"
        ]
      end

      it { is_expected.to be_truthy }

      it_behaves_like 'returns expected consuption'
      it_behaves_like 'returns expected items'
    end

    context 'when data is not enough to cover max' do
      let(:params) { { max: 100 } }
      let(:consumption) { 190 }
      let(:item_ids) { sample_data.map { |i| i[:id] } }

      it { is_expected.to be_truthy }

      it_behaves_like 'returns expected consuption'
      it_behaves_like 'returns expected items'
    end

    context 'when only 1 item covers request' do
      let(:params) { { max: 2 } }
      let(:consumption) { 10 }
      let(:item_ids) { ["2085747a-eee5-445a-85fc-92da51709a41"] }

      it { is_expected.to be_truthy }

      it_behaves_like 'returns expected consuption'
      it_behaves_like 'returns expected items'
    end

    context 'when data contains 1 item' do
      let(:params) { { max: 100 } }
      let(:consumption) { 120 }
      let(:item_ids) { ["404c1873-96e5-4767-899a-c28697b4ccd4"] }
      let(:sample_data) do
        [
          {
            "id": "404c1873-96e5-4767-899a-c28697b4ccd4",
            "name": "Squats",
            "average_span": 20,
            "average_calorie_consumption": 120
          }
        ]
      end

      it { is_expected.to be_truthy }

      it_behaves_like 'returns expected consuption'
      it_behaves_like 'returns expected items'
    end

    context 'when data does not contain any items' do
      let(:params) { { max: 100 } }
      let(:consumption) { nil }
      let(:sample_data) { [] }

      it { is_expected.to be_truthy }

      it_behaves_like 'returns expected consuption'
    end

    context 'when requested is 0' do
      let(:params) { { max: 0 } }
      let(:consumption) { nil }
      let(:item_ids) { [] }

      it { is_expected.to be_truthy }

      it_behaves_like 'returns expected consuption'
    end

    context 'when requested is 1' do
      let(:params) { { max: 1 } }
      let(:consumption) { nil }
      let(:item_ids) { [] }

      it { is_expected.to be_truthy }

      it_behaves_like 'returns expected consuption'
    end
  end
end
