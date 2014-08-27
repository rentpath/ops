require 'spec_helper'

describe Ops::HealthCheck do
  describe '#check!' do
    before {
      Ops.stub(:config){
        Ops::Config.new({
          dependencies: {
            api: proc { true }
          }
        })
      }
    }

    let(:health_check){
      Ops::HealthCheck.check!
    }

    it 'returns a tuple' do
      puts health_check.inspect
      expect(health_check).to be_a Array
      expect(health_check).to have(2).items
    end

    context 'all dependencies are working' do
      it 'returns true in the first index' do
        expect(health_check.first).to be_true
      end
    end

    context 'one or more dependencies are not working' do
      before {
        Ops.stub(:config){
          Ops::Config.new({
            dependencies: {
              api: proc { false },
              service: proc { true }
            }
          })
        }
      }

      it 'returns false in the first index' do
        expect(health_check.first).to be_false
      end
    end

    context 'dependency does not respond to call' do
      before {
        Ops.stub(:config){
          Ops::Config.new({
            dependencies: {
              api: true
            }
          })
        }
      }

      it 'returns false in the first index' do
        expect(health_check.first).to be_false
      end

      it 'returns an exception message in the second index' do
        expect(health_check[1]).to have_key :exception
      end
    end
  end
end