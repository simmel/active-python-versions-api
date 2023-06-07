#!/usr/bin/env perl
use Mojolicious::Lite -signatures;


app->helper(parse_versions => sub ($c, @values) {
  my $html = $values[0];
  my $dom = Mojo::DOM->new($html);
  my $data = $dom->find('div.active-release-list-widget > ol li span.release-status:is(:text(security), :text(bugfix))')->map("parent")->map("find", ".release-version")->map("first")->map("text")->to_array;
  return $data;
});

my $VERSION = "1.1.0";
my $data = [];

# Forward error messages to the application log
Mojo::IOLoop->singleton->reactor->on(error => sub ($reactor, $err) {
  app->log->error($err);
});

Mojo::IOLoop->recurring(86400 => sub ($ioloop) {
    update_python_versions();
});

sub update_python_versions() {
  app->log->debug("Starting to load Python versions");
  app->ua->transactor->name("active-python-versions-api/$VERSION (+https://github.com/simmel/active-python-versions-api)");
  my $result = app->ua->connect_timeout(10)->request_timeout(10)->get('https://www.python.org/downloads/')->result;
  my $html;
  if ($result->is_success) {
    $html = $result->body;
    $data = app->parse_versions($html);
    app->log->debug("after parse_versions ".join(",", @$data));
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
}

update_python_versions();

get '/' => sub ($c) {
  $c->redirect_to("v1");
};

under '/v1';

get '/' => {text => "I 🐍 Python!\n"};

get '/versions' => sub ($c) {
  $c->render(json => $data);
};

app->start;
