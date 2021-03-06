require 'open3'

module ThorSCMVersion
  class GitVersion < ScmVersion
    class << self          
      def all_from_path(path)
        Dir.chdir(path) do
          tags = Open3.popen3("git tag") { |stdin, stdout, stderr| stdout.read }.split(/\n/)
          version_tags = tags.select { |tag| tag.match(ScmVersion::VERSION_FORMAT) }
          version_tags.collect { |tag| new(*tag.split('.')) }.sort.reverse
        end
      end
    end
        
    def tag
      ShellUtils.sh "git tag -a -m \"Version #{self}\" #{self}"
      ShellUtils.sh "git push --tags || true"
    end 
  end
end
