CONFFILE=./confd/conf.d/elasticsearch.yml.toml
SHIELDCONFFILE=./confd/conf.d/roles.yml.toml
USERSCONFFILE=./confd/conf.d/users.yml.toml

# Regenerate the config file by inspecting the template
conf:
	@echo '[template]' > ${CONFFILE}
	@echo 'src = "elasticsearch.yml.tmpl"' >> ${CONFFILE}
	@echo 'dest = "/usr/share/elasticsearch/config/elasticsearch.yml"' >> ${CONFFILE}
	@echo 'prefix = "es"' >> ${CONFFILE}
	@echo 'keys = [' >> ${CONFFILE}
	@cat ./confd/templates/elasticsearch.yml.tmpl | grep -oE '"/(\w|/)+"' | uniq | lam /dev/stdin -s "," | sed -e 's/^/  /' >> ${CONFFILE}
	@echo ']' >> ${CONFFILE}

# Generate a list of environment variables
env:
	@cat ./confd/templates/elasticsearch.yml.tmpl | grep -oE '"/(\w|/)+"' | uniq | tr '[a-z]' '[A-Z]' | sed -e 's,"/\(.*\)",\1,' | tr '/' '_' | sed 's/^/ES_/' > .env
	@echo "ES_HOME" >> .env

# Generate Samples
try: conf env
	@rm -rf ./tmp
	@mkdir -p ./tmp/config
	@docker run -e QUIET=true -it `docker build -q .` cat config/elasticsearch.yml > ./tmp/config/elasticsearch.yml
