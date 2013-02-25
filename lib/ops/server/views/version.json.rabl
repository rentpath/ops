node :version do
  @version.version_or_branch
end
node :last_commit do
  @version.last_commit
end
node :previous_versions do
  @previous_versions
end
node :headers do
  @headers
end
