#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

app->helper(parse_versions => sub ($c, @values) {
  my $html = $values[0];
  return $html;
});

under '/v1';

get '/' => {text => "I 🐍 Python!\n"};

app->start;
