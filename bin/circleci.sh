#!/bin/sh

set -x

case $CIRCLE_NODE_INDEX in
  0)
    bundle exec rspec spec --exclude-pattern spec/features --tag ~flaky
    ;;
  1)
    rake ember:test
    ember_result=$?
    bundle exec rspec spec/features/[a-j]*_spec.rb --tag ~flaky
    features_result=$?

    if [ $ember_result != '0' -o $features_result != '0' ]; then
      exit 1;
    fi
    ;;
  2)
    bundle exec rspec spec/features/[k-z]*_spec.rb --tag ~flaky
    features_result=$?
    bundle exec rspec engines --tag ~flaky
    engines_result=$?
    bundle exec rspec spec engines --tag @flaky
    flaky_result=$?

    if [ $flaky_result != '0' -o $engines_result != '0' -o $features_result != '0' ]; then
      exit 1;
    fi
    ;;
esac
