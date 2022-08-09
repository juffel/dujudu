# Dujudu

A wikidata-backed browser for food & ingredients.

## Executing things in the docker container

For most of the following examples, the `script/` directory contains a shortcut, like `script/mix` or `script/test`.

Running migrations:

```sh
$ docker-compose run web mix ecto.migrate
```

Running tests:

```sh
$ docker-compose run -e MIX_ENV=test web mix test test/dujudu/wikidata/client_test.exs
```

### Getting an interactive shell with phoenix context

```sh
$ docker-compose run web iex -S mix
```

### Accessing the database

```sh
$ docker-compose run db sh -c 'psql -h db -U postgres -d dujudu_dev'
```

### Running credo

```sh
$ docker-compose run web mix credo
```

## Querying Wikidata

Extensive tutorial on wikidata SPARQL API https://www.wikidata.org/wiki/Wikidata:SPARQL_tutorial

Slightly adjusted "cat" example, with filter for `wd:Q25403900` - "Food ingredient" https://www.wikidata.org/wiki/Q25403900

```sparql
#Ingredients
SELECT ?item ?itemLabel
WHERE
{
  ?item wdt:P31 wd:Q25403900.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
}
```

As noted in the [interfacing guide](https://www.wikidata.org/wiki/Wikidata:SPARQL_query_service#Interfacing) of the wikidata sparql guide, the api can be queried via GET to `https://query.wikidata.org/sparql?query={SPARQL}`, while the response format defaults to XML but can be set to JSON with a respective header `Accept: application/sparql-results+json`

# Roadmap

* integrate LiveView
* fetch additional data from Wikidata, when viewing a single ingredient, like direct links to wikipedia articles or titles in different languages
* add login with Firefox
