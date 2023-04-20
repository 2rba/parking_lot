# frozen_string_literal: true
require 'active_support'
require 'active_support/time'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.setup
