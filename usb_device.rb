require 'sys-filesystem'

# USB Device Model Class
class USBDevice
  attr_reader :device, :mount, :fstype, :size, :name
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
    @name = USBDevice.labels[@device] || File.basename(@mount)
  end

  def create_link(parent_dir)
    symlink_file = File.join(parent_dir, @name)
    if FileTest.exist?(symlink_file)
      unless FileTest.symlink?(symlink_file)
        raise 'シンボリックリンクではありません: ' + symlink_file.to_s
      end

      path = File.expand_path(File.readlink(symlink_file),
        File.dirname(symlink_file))
      if path != @mount
        File.unlink(symlink_file)
        File.symlink(@mount, symlink_file)
      end
    else
      File.symlink(@mount, symlink_file)
    end
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

    def find_by_name(name)
      all.select { |usb| usb.name == name }.first
    end

    def labels
      label_dir = '/dev/disk/by-label'
      if @labels_mtime && @labels_mtime >= File.stat(label_dir).mtime
        return @labels
      end

      @labels = Dir.foreach(label_dir)
        .reject { |name| name == '.' || name == '..' }
        .select { |name| FileTest.symlink?(File.join(label_dir, name)) }
        .map do |name|
          [
            File.expand_path(File.readlink(File.join(label_dir, name)),
              label_dir),
            normalize_label(name),
          ]
        end.to_h
      @labels_mtime = File.stat(label_dir).mtime
      return @labels
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

    def clear_link(parent_dir)
      Dir.foreach(parent_dir) do |name|
        next if name == '.' || name == '..'
        path = File.join(parent_dir, name)
        File.unlink(path) if FileTest.symlink?(path)
      end
    end

    def all_link(parent_dir)
      clear_link(parent_dir)
      all.each do |usb|
        usb.create_link(parent_dir)
      end
    end
  end
end
