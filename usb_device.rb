require 'filesystem'

class USBDevice
  attr_reader :device, :mount, :fstype, :size, :name
  def initialize(fsm)
    @device = fsm.device
    @mount = fsm.mount
    @fstype = fsm.fstype
    stat = FileSystem.stat(fsm.mount)
    @size = {
      total: stat.block_size * stat.blocks,
      free: stat.block_size * stat.blocks_free
    }.freeze
    @name = File.basename(@mount)
  end

  class << self
    def all
      FileSystem.mounts
                .select { |m| m.mount.start_with?('/var/www/dav/usb/') }
                .map { |m| USBDevice.new(m) }
    end

    def find_by_device(device)
      all.select { |usb| usb.device == device }.first
    end
  end
end
