$LOAD_PATH << '.'

require 'logger'
require 'app_config'
require 'date'


# AppLogger encapsulates different types of logger to provide a simple logger interface to multiple loggers - e.g.
# console loggers, file loggers.
#
# Console loggers produce color-coded output for different log severities.
#
# AppLogger can be initialised repeatedly from different parts of the application - and will be initialised with the
# same logger objects that were setup on first initialisation. This makes usage very simple: just do AppLogger.new to get
# the application logger.

class AppLogger

  @@file_loggers = nil
  @@console_loggers = nil

  @@loggers = nil

  # Something to use to filter out any application secrets, just in case they have crept into a log statement somewhere.
  @@secrets = AppConfig::Secrets

  Colors = {
      :debug => :cyan,
      :info => :green,
      :warn => :yellow,
      :error => :magenta,
      :fatal => :red
  }


  def initialize(prefix="")
    if @@loggers.nil?
      @@loggers = {
          :console => console_loggers,
          :file => file_loggers
      }
    end
    @prefix = prefix
  end


  public
  def debug(msg)
    log(:debug, msg)
  end


  def info(msg)
    log(:info, msg)
  end


  def warn(msg)
    log(:warn, msg)
  end


  def error(msg)
    log(:error, msg)
  end


  def fatal(msg)
    log(:fatal, msg)
  end


  def level(level)
    @@loggers.each do |logger|
      logger.level = level
    end
  end


  def exception(e, msg="")
    unless nil_or_empty?(msg)
      msg = "#{msg}: "
    end

    msg = "#{msg}#{e.message}#{e.backtrace.join("")}"
    log(:error, msg)
  end


  private
  def log(severity, msg)
    msg = "#{@prefix}: #{sanitize(msg)}"

    @@loggers[:console].each do |logger|
      logger.send(severity, msg.send(Colors[severity]))
    end

    @@loggers[:file].each do |logger|
      logger.send(severity, msg)
    end
  end


  def console_loggers
    [config_logger(STDOUT)]
  end


  def file_loggers
    [config_logger("logs/#{DateTime.now().strftime(AppConfig::DateFormat)}.log")]
  end


  def config_logger(type)
    logger = Logger.new(type)
    if AppConfig::Debug
      logger.level = Logger::Debug
    else
      logger.level = Logger::INFO
    end
    logger.datetime_format = AppConfig::DateFormat
    logger
  end


  def sanitize(str)
    @@secrets.keys.each do |key|
      secret = @@secrets[key]
      safe = '*' * secret.length
      str = str.gsub(secret, safe)
    end
    str
  end


  def nil_or_empty?(str)
    if str.to_s == ''
      return true
    else
      return false
    end
  end

end