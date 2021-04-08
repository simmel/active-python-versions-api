requires 'Mojolicious', '>= 9.0, < 10.0';
requires 'IO::Socket::SSL';
requires 'Mozilla::CA';

on 'develop' => sub {
  requires 'App::Prove';
};
