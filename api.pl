#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

app->helper(parse_versions => sub ($c, @values) {
  my $html = $values[0];
  my $dom = Mojo::DOM->new($html);
  my $data = $dom->find('ol * span.release-version')->map('text')->grep(qr/^[^2]/)->to_array;
  return $data;
});

under '/v1';

get '/' => {text => "I 🐍 Python!\n"};

app->start;
