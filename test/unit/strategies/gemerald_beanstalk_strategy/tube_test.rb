require 'test_helper'

class GemeraldBeanstalkStrategyTubeTest < BeanCounter::TestCase

  Tube = BeanCounter::Strategy::GemeraldBeanstalkStrategy::Tube

  context 'attr methods' do

    should 'respond to stats attr methods and retrieve from #to_hash Hash' do
      tube = Tube.new('xxx', [])
      Tube::STATS_METHODS.each do |attr|
        tube.expects(:to_hash).returns({attr => attr})
        assert_equal attr, tube.send(attr.gsub(/-/, '_'))
      end
    end


    should 'respond to #name' do
      assert_equal 'xxx', Tube.new('xxx', []).name
    end

  end


  context 'tests against real servers' do

    setup do
      create_test_beanstalks
      @tube_name = SecureRandom.uuid
      client.transmit("watch #{@tube_name}")
      @tube = @strategy.send(:strategy_tube, @tube_name)
    end


    context '#exists' do

      should 'return true if the tube exists, false otherwise' do
        assert @tube.exists?
        client.transmit("ignore #{@tube_name}")
        refute @tube.exists?
      end

    end


    context '#to_hash' do

      setup do
        @tube_name = SecureRandom.uuid
        client.transmit("watch #{@tube_name}")
        @tube = @strategy.send(:strategy_tube, @tube_name)

        other_client = client(@@gemerald_addrs.last)
        other_client.transmit("watch #{@tube_name}")
      end


      should 'retrieve tube stats from all servers and return merged stats' do
        stats = {
          'cmd-delete' =>  100,
          'cmd-pause-tube' => 101,
          'current-jobs-buried' => 102,
          'current-jobs-delayed' => 103,
          'current-jobs-ready' => 104,
          'current-jobs-reserved' => 105,
          'current-jobs-urgent' => 106,
          'current-using' => 107,
          'current-waiting' => 108,
          'current-watching' => 109,
          'name' => @tube_name,
          'pause' => 111,
          'pause-time-left' => 110,
          'total-jobs' => 112,
        }
        GemeraldBeanstalk::Tube.any_instance.expects(:stats).twice.returns(stats)
        expected = Hash[stats.map{|k, v| [k, v.is_a?(Numeric) ? v * 2 : v]}]
        assert_equal expected, @tube.to_hash
      end


      should 'return empty Hash if the tube does not exist' do
        assert_equal({}, @strategy.send(:strategy_tube, 'xxxx').to_hash)
      end

    end

  end


  def client(addr = nil)
    self.class.create_test_gemerald_beanstalks
    addr ||= @@gemerald_addrs.first
    return @@gemerald_clients[addr]
  end


  def create_test_beanstalks
    self.class.create_test_gemerald_beanstalks
    @strategy = @@gemerald_strategy
    @beanstalks = @@gemerald_beanstalks
  end

end
