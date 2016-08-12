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
env: conf
	@cat ./confd/templates/elasticsearch.yml.tmpl | grep -oE '"/(\w|/)+"' | uniq | tr '[a-z]' '[A-Z]' | sed -e 's,"/\(.*\)",\1,' | tr '/' '_' | sed 's/^/ES_/' | lam /dev/stdin -s '="value"' > .env
	@echo "ES_HOME" >> .env

test: env
	@docker run --env-file=.env -e QUIET=true -it `docker build -q .` cat config/elasticsearch.yml | ruby -r json -r yaml -e "raise 'no values!' if YAML.load(STDIN.read) == false"

# Generate Samples
try: conf
	@mkdir -p ./tmp/config
	@docker run --env-file=.env -e QUIET=true -it `docker build -q .` cat config/elasticsearch.yml > ./tmp/config/elasticsearch.yml
