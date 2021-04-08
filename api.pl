#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

app->helper(parse_versions => sub ($c, @values) {
  my $html = $values[0];
  my $dom = Mojo::DOM->new($html);
  my $data = $dom->find('ol * span.release-version')->map('text')->grep(qr/^[^2]/)->to_array;
  return $data;
});

my $VERSION = "1.0.0";
my $data = [];

Mojo::IOLoop->recurring(86400 => sub ($ioloop) {
    update_python_versions();
});

sub update_python_versions() {
  app->log->debug("Starting to load Python versions");
  app->ua->transactor->name("active-python-versions-api/$VERSION (+https://github.com/simmel/active-python-versions-api)");
  app->ua->connect_timeout(10)->request_timeout(10)->get('https://www.python.org/downloads/' => sub ($ua, $tx) {
    my $html;
    my $result = $tx->result;
    if ($result->is_success) {
      $html = $result->body;
      $data = app->parse_versions($html);
      my $versions = scalar(@$data);
      if ($versions == 0) {
        app->log->error("Loaded no Python versions");
      }
      else {
        app->log->debug("Loaded python versions: ".join(",", @$data));
        app->log->info("Loaded ".scalar(@$data)." Python versions");
      }
    }
    else {
      app->log->error("Couldn't load Python versions: ". $result->message);
      return;
    }
  });
}

update_python_versions();

get '/' => sub ($c) {
  $c->redirect_to("v1");
};

under '/v1';

get '/' => {text => "I 🐍 Python!\n"};

app->start;
