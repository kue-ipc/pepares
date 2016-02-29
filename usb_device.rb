require 'filesystem'

class USBDevice
  attr_reader :device, :mount, :fstype, :size, :name
  def initialize(fsm)
    @device = fsm.device
    @mount = fsm.mount
    @fstype = fsm.fstype
    stat = FileSystem.stat(fsm.mount)
    @size = {
      total: stat.blok_size * stat.blocks,
      free: stat.blok_size * stat.blocks_free,
    }.freeze
    @name = File.basename(@mount)
  end

  def self.list
    FileSystem.mounts
              .select { |m| m.mount.start_with?('/var/www/dav/usb/') }
              .map { |m| USBDevice.new(m) }
  end
end
