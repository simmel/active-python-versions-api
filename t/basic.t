use Test::More;
use Mojo::File qw(curfile);
use Test::Mojo;

# Portably point to "../myapp.pl"
my $script = curfile->dirname->sibling('api.pl');

my $t = Test::Mojo->new($script);
is("meow", "meow", "is meow?");
is($t->app->parse_versions("fax"), "fax", "is fax!");

done_testing();
