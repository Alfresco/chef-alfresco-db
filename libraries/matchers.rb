if defined?(ChefSpec)
  ChefSpec.define_matcher :mysql_db
  ChefSpec.define_matcher :mysql_database_user

  def redeploy_mycfn_template_mysql_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_service, :redeploy_mycfn_template, resource_name)
  end

  def create_mysql_database_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_database_user, :create, resource_name)
  end

  def grant_mysql_database_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_database_user, :grant, resource_name)
  end
end
