# Dujudu

A wikidata-backed browser for food & ingredients.

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
