require "tng/gtk/utils/version"

module Tng
  module Gtk
    module Utils
      def uuid_valid?(uuid)
        return true if (uuid =~ /[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/) == 0
        false
      end
    end
  end
end
