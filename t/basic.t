use Test::More;
use Mojo::File qw(curfile);
use Test::Mojo;

# Portably point to "../myapp.pl"
my $script = curfile->dirname->sibling('api.pl');

my $t = Test::Mojo->new($script);
is("meow", "meow", "is meow?");

my @tests = (
["t/2021-04-07.html", ["3.9", "3.8", "3.7", "3.6"]]
);
use Data::Dumper;
for my $test (@tests) {
  my $file = $$test[0];
  my $data;
  {
    open my $fh, '<', $file or die;
    local $/ = undef;
    $data = <$fh>;
    close $fh;
  }
  is_deeply($t->app->parse_versions($data), $$test[1], $$test[0]." correctly parsed?");
}

done_testing();
