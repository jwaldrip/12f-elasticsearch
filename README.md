# 12 Factor Elasticsearch [![Build Status](https://travis-ci.org/jwaldrip/12f-elasticsearch.svg?branch=master)](https://travis-ci.org/jwaldrip/12f-elasticsearch)
Docker 12 factor elastic search allows a user to configure elastic search using
nothing but environment variables.

## Running
```sh
$ docker run -e ES_{VAR} jwaldrip/12f-elasticsearch
```

## Variables
See `.env` for a list of environment variables.

## Output With Comments
When specifying `COMMENTS=true` the config will generate with documentation as
comments.

## TODO
* Plugin Support
* Better Documentation
* Licensed Version Support

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jwaldrip/12f-elasticsearch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.

# License

The gem is available as open source under the terms of the MIT License.
