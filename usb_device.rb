require 'sys-filesystem'

# USB Device Model Class
class USBDevice
  attr_reader :device, :mount, :fstype, :size, :name
  def initialize(fsm)
    @device = fsm.name
    @mount = fsm.mount_point
    @fstype = fsm.mount_type
    stat = Sys::FileSystem.stat(@mount)
    @size = {
      total: stat.block_size * stat.blocks,
      available: stat.block_size * stat.blocks_avail,
      free: stat.block_size * stat.blocks_free,
    }.freeze
    @name = File.basename(@mount)
  end

  class << self
    def all
      Sys::Filesystem.mounts
                .select { |m| m.mount_point.start_with?('/var/www/dav/usb/') }
                .map { |m| USBDevice.new(m) }
    end

    def find_by_device(device)
      all.select { |usb| usb.device == device }.first
    end
  end
end
