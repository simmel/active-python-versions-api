use Test::More;
use Mojo::File qw(curfile);
use Test::Mojo;

# Portably point to "../myapp.pl"
my $script = curfile->dirname->sibling('api.pl');

my $t = Test::Mojo->new($script);
is("meow", "meow", "is meow?");

for my $file (qw(t/2021-04-07.html)) {
  my $data;
  {
    open my $fh, '<', $file or die;
    local $/ = undef;
    $data = <$fh>;
    close $fh;
  }
  is($t->app->parse_versions($data), "fax", "is fax!");
}

done_testing();
