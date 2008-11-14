require 'fileutils'
require 'uv'

css_path = File.join(RAILS_ROOT, 'public', 'stylesheets', 'ultraviolet')
FileUtils.mkdir_p css_path
Uv.copy_files 'xhtml', css_path
