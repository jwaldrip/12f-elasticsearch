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
	@cat ./confd/templates/elasticsearch.yml.tmpl | grep -oE '"/(\w|/)+"' | uniq | sed -e 's/$$/,/' | sed -e 's/^/  /' >> ${CONFFILE}
	@echo ']' >> ${CONFFILE}

build: conf
	@docker build -t jwaldrip/12f-elasticsearch .

# Generate a list of environment variables
env: conf
	@cat ./confd/templates/elasticsearch.yml.tmpl | grep -oE '"/(\w|/)+"' | uniq | tr '[a-z]' '[A-Z]' | sed -e 's,"/\(.*\)",\1,' | tr '/' '_' | sed 's/^/ES_/' | sed -e 's/$$/="value"/' > .env
	@echo 'ES_HOME="value"' >> .env

test: env
	@docker run --env-file=.env -e QUIET=true -it `docker build -q .` cat config/elasticsearch.yml | ruby -r json -r yaml -e "raise 'no values!' if YAML.load(STDIN.read) == false"
	@docker run -e QUIET=true -it `docker build -q .` cat config/elasticsearch.yml | ruby -r json -r yaml -e "raise 'no values!' if YAML.load(STDIN.read) == false"

# Generate Samples
try: env
	@mkdir -p ./tmp/config
	@docker run --env-file=.env -e QUIET=true -it `docker build -q .` cat config/elasticsearch.yml > ./tmp/config/elasticsearch.yml
