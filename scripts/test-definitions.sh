#!/bin/bash
set -o errexit

templates=$(ls humanitec-resource-defs/)
for template in $templates;
do
  if [ "${template}" != "mysql" ] && [ "${template}" != "postgres" ]; then
    echo "## Testing ${template}:"
    cp scripts/test.yaml humanitec-resource-defs/$template/basic/test-$template.yaml
    cd humanitec-resource-defs/$template/basic
    
    template=$template yq -i '.entity.type = env(template)' test-$template.yaml
    
    yq -i '.entity.driver_inputs.values = load("definition-values.yaml")' test-$template.yaml
    
    tests=$(ls tests/*-inputs.yaml)
    for test in $tests;
    do
      echo "## ${template} tested with ${test}."
      humctl resources test-definition test-$template.yaml --inputs $test
    done

    rm test-$template.yaml
    cd ../../../
  fi
done