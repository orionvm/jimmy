require 'pathname'
require 'jimmy/version'

module Jimmy
    ROOT = Pathname(__FILE__).parent.parent
end

require_relative 'jimmy/symbol_array'

require_relative 'jimmy/domain'
require_relative 'jimmy/schema'
require_relative 'jimmy/schema_creation'
require_relative 'jimmy/schema_types'
require_relative 'jimmy/schema_type'
require_relative 'jimmy/combination'