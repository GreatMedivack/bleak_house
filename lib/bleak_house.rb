
if ENV['AUTO_RUBLIQUE']
  
  require 'dispatcher' # rails  
  require 'rublique' # gem
  require 'rublique_logger' # gem
  
  require 'bleak_house/dispatcher' # plugin
  require 'bleak_house/action_controller' # plugin


  class BleakHouse  
    cattr_accessor :last_request_name
    cattr_accessor :dispatch_count
    cattr_accessor :log_interval

    self.dispatch_count = 0
    self.log_interval = (ENV['INTERVAL'] and ENV['INTERVAL'].to_i or 10)

    def self.set_request_name request, other = nil
      self.last_request_name = "#{request.parameters['controller']}/#{request.parameters['action']}/#{request.request_method}#{other}"
    end

    def self.debug s
      s = "#{name.underscore}: #{s}"
      ::ActiveRecord::Base.logger.debug s if ::ActiveRecord::Base.logger
    end
      
    def self.warn s
      s = "#{name.underscore}: #{s}"
      if ::ActiveRecord::Base.logger
        ::ActiveRecord::Base.logger.warn s
      else
        $stderrequest.puts s
      end    
    end

    LOGFILE = "#{RAILS_ROOT}/log/#{RAILS_ENV}_bleak_house.log"
    RubliqueLogger.file = LOGFILE    
  end  
  
  BleakHouse.warn "enabled (log/#{RAILS_ENV}_bleak_house.log) (#{BleakHouse.log_interval} requests per frame)"
  if File.exists?(BleakHouse::LOGFILE)
    File.rename(BleakHouse::LOGFILE, "#{BleakHouse::LOGFILE}.old") 
    BleakHouse.warn "renamed old logfile"
  end

else
  BleakHouse.warn "not enabled"
end
