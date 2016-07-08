require 'sys-filesystem'

# USB Device Model Class
class USBDevice
  attr_reader :device, :mount, :fstype, :size, :name, :label
  def initialize(fsm)
    @device = fsm.name
    @mount = fsm.mount_point
    @fstype = fsm.mount_type
    stat = Sys::Filesystem.stat(@mount)
    @size = {
      total: stat.block_size * stat.blocks,
      available: stat.block_size * stat.blocks_available,
      free: stat.block_size * stat.blocks_free,
    }.freeze
    @name = File.basename(@mount)
    @label = USBDevice.labels[@device]
  end

  class << self
    def all
      Sys::Filesystem.mounts
        .select { |m| m.mount_point.start_with?('/media/') }
        .map { |m| USBDevice.new(m) }
    end

    def find_by_device(device)
      all.select { |usb| usb.device == device }.first
    end

    def labels
      label_dir = '/dev/disk/by-label'
      Encoding.default_external = 'ASCII-8BIT'
      Dir.foreach(label_dir)
        .reject { |name| name == '.' || name == '..' }
        .select { |name| FileTest.symlink?(File.join(label_dir, name)) }
        .map do |name|
          [
            File.expand_path(File.readlink(File.join(label_dir, name)),
              label_dir),
            normalize_label(name)
          ]
        end.to_h
    end

    # USB メモリの日本語のラベルが Windows-31J (CP932) になる問題を解決する。
    def normalize_label(name)
      if name.include?('\\x')
        str8bit = name
          .encode(Encoding::ASCII_8BIT)
          .gsub(/\\x[\da-f]{2}/) do |m|
            m[2..3].to_i(16).chr(Encoding::ASCII_8BIT)
          end
        begin
          return str8bit.encode(Encoding::UTF_8, Encoding::Windows_31J)
        rescue Encoding::InvalidByteSequenceError => e
          warn "raise: #{e.inspect}"
        end
      end
      return name
    end
  end
end

if __FILE__ == $0
  ll = USBDevice.labels
  p ll
  puts ll['/dev/sdb1']
  puts "日本語"
end
