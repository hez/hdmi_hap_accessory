import Config

config :hdmi_hap_accessory, :logger, [
  {:handler, :file_log, :logger_std_h,
   %{
     config: %{
       file: ~c"logs/hdmi_hap_accessory.log",
       filesync_repeat_interval: 5000,
       file_check: 5000,
       max_no_bytes: 10_000_000,
       max_no_files: 5,
       compress_on_rotate: true
     },
     formatter: Logger.Formatter.new()
   }}
]
